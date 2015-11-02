//
//  PIRedditNetworking.m
//  RedditClient

/*
 The MIT License (MIT)
 
 Copyright © 2015 Alexey Gordiyenko. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "PIRedditNetworking_Private.h"
#import "PIRedditRESTController.h"
#import "PIRedditSerializationStrategy.h"

NSString * const kPIRHTTPMethodGET = @"GET";
NSString * const kPIRHTTPMethodPOST = @"POST";

@interface PIRedditNetworking () {
    NSLock *_tokenRefreshLock;
    dispatch_queue_t _tokenRefreshQueue;
}

@property (readonly, nonatomic) PIRedditRESTController *REST;
@property (readonly, nonatomic) NSDictionary *additionalHTTPHeaders;

@end

@implementation PIRedditNetworking

@synthesize REST = _REST, additionalHTTPHeaders = _additionalHTTPHeaders, operationQueue = _operationQueue;

#pragma mark - Accessors

- (NSOperationQueue *)operationQueue {
    @synchronized(self) {
        if (!_operationQueue) {
            _operationQueue = [NSOperationQueue new];
            _operationQueue.maxConcurrentOperationCount = 10;
        }
        
        return _operationQueue;
    }
}

- (void)setAccessToken:(NSString *)accessToken {
    @synchronized(self) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(accessToken))];
        _accessToken = accessToken;
        [self didChangeValueForKey:NSStringFromSelector(@selector(accessToken))];
    }
}

- (NSDictionary *)additionalHTTPHeaders {
    @synchronized(self) {
        if (!_additionalHTTPHeaders) {
            _additionalHTTPHeaders = @{@"Authorization": [NSString stringWithFormat:@"bearer %@", self.accessToken],
                                       @"User-Agent": self.userAgent ?: @"Unknown User Agent"};
        }
    }
    
    return _additionalHTTPHeaders;
}

- (PIRedditRESTController *)REST {
    @synchronized(self) {
        if (!_REST) {
            NSURL *baseURL = [NSURL URLWithString:@"https://oauth.reddit.com/"];
            _REST = [[PIRedditRESTController alloc] initWithSession:[NSURLSession sharedSession] baseURL:baseURL];
        }
        
        _REST.additionalHTTPHeaders = self.additionalHTTPHeaders;
        
        return _REST;
    }
}

#pragma mark - Public Methods

- (NSOperation *)searchFor:(NSString *)searchTerm limit:(NSUInteger)limit completion:(PIRedditNetworkingCompletion)completion {
    NSParameterAssert(searchTerm);
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"q"] = searchTerm;
    if (limit) {
        params[@"limit"] = @(limit);
    }
    
    return [self requestOperationAtPath:@"search" parameters:[params copy] completion:completion];
}

#pragma mark - Private Methods

- (NSOperation *)requestOperationAtPath:(NSString *)path
                             parameters:(NSDictionary *)parameters
                             completion:(void (^)(NSError *error, id responseObject))completion
{
    return [self requestOperationWithMethod:kPIRHTTPMethodGET atPath:path parameters:parameters completion:completion];
}

- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 completion:(void (^)(NSError *error, id responseObject))completion {
    return [self requestOperationWithMethod:HTTPMethod atPath:path parameters:parameters allowReauth:YES completion:completion];
}

- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                allowReauth:(BOOL)allowReauth
                                 completion:(void (^)(NSError *error, id responseObject))completion
{
    NSOperation *retVal = [self.REST requestOperationWithMethod:HTTPMethod
                                                         atPath:path
                                                     parameters:parameters
                                          responseSerialization:nil
                                                     completion:completion ?
                           ^(NSError *error, id responseObject, NSURLRequest *originalRequest)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self processServerResponseError:error responseObject:responseObject originalRequest:originalRequest allowReauth:allowReauth completion:completion];
        });
    } : nil];
    
    [self.operationQueue addOperation:retVal];
    
    return retVal;
}

- (void)processServerResponseError:(NSError *)error
                    responseObject:(id)responseObject
                   originalRequest:(NSURLRequest *)originalRequest
                       allowReauth:(BOOL)allowReauth
                        completion:(PIRedditNetworkingCompletion)completion
{
    NSParameterAssert(completion);
    XLog(@"%@", error);
    XLog(@"%@", responseObject);
    NSError *retValError;
    id retValObject;
    if (error) {
        switch (error.code) {
            case 401:
                if (allowReauth) {
                    __weak typeof(self) weakSelf = self;
                    dispatch_block_t resendRequestBlock = ^{
                        __weak typeof(weakSelf) strongSelf = weakSelf;
                        NSOperation *op = [strongSelf.REST requestOperationWithRequest:originalRequest
                                                                 responseSerialization:[[PIRedditSerializationStrategy alloc] initWithStrategyType:PIRedditSerializationStrategyJSON]
                                                                            completion:^(NSError *resendError, id resendResponseObject, NSURLRequest *resendOriginalRequest)
                                           {
                                               [strongSelf processServerResponseError:resendError responseObject:resendResponseObject originalRequest:nil allowReauth:NO completion:completion];
                                           }];
                        [strongSelf.operationQueue addOperation:op];
                    };
                    
                    dispatch_async(_tokenRefreshQueue, ^{
                        NSString *oldToken = self.accessToken;
                        [_tokenRefreshLock lock];
                        if ([self.accessToken isEqualToString:oldToken]) {
                            // Token is the same. Must reauthorize
                            [self refreshTokenWithCompletion:^(NSError *tokenError, NSString *newToken) {
                                dispatch_async(_tokenRefreshQueue, ^{
                                    [_tokenRefreshLock unlock];
                                    if (tokenError) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completion(tokenError, nil);
                                        });
                                    } else {
                                        self.accessToken = newToken;
                                        resendRequestBlock();
                                    }
                                });
                            }];
                        } else {
                            // Previous token refresh operation was a success.
                            [_tokenRefreshLock unlock];
                            resendRequestBlock();
                        }
                    });
                    return;
                }
                // No break here.
                
            default:
                retValError = error;
                break;
        }
    } else {
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(retValError, retValObject);
    });
}

#pragma mark - Token

- (void)refreshTokenWithCompletion:(void(^)(NSError *error, NSString *newToken))completion {
    // TODO:
    if (completion) {
        completion(nil, @"");
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self &&
        ([keyPath isEqualToString:NSStringFromSelector(@selector(accessToken))] ||
         [keyPath isEqualToString:NSStringFromSelector(@selector(userAgent))]))
    {
        @synchronized(self) {
            _additionalHTTPHeaders = nil;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(accessToken)) options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(userAgent)) options:NSKeyValueObservingOptionNew context:NULL];
        _tokenRefreshLock = [NSLock new];
        _tokenRefreshQueue = dispatch_queue_create("reddit_token_refresh", 0);
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(accessToken))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(userAgent))];
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

@end
