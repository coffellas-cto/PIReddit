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
#import "PIRedditCommon.h"
#import "PIRedditListing.h"

NSString * const kPIRHTTPMethodGET = @"GET";
NSString * const kPIRHTTPMethodPOST = @"POST";

#pragma mark - Categories

@implementation NSDictionary (PIRedditNetworking)

+ (NSDictionary *)pireddit_basicAuthDictionaryWithUser:(NSString *)user {
    NSData *authData = [[NSString stringWithFormat:@"%@:", user] dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [[NSString alloc] initWithData:[authData base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding]];
    return @{@"Authorization": authValue};
}

@end

#pragma mark - PIRedditNetworking

@interface PIRedditNetworking () {
    NSLock *_tokenRefreshLock;
}

@property (readonly, nonatomic) PIRedditRESTController *REST;
@property (readonly, nonatomic) NSDictionary *additionalHTTPHeaders;
@property (readwrite, copy, atomic) NSString *refreshToken;

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

- (NSOperation *)searchFor:(NSString *)searchTerm
                     limit:(NSUInteger)limit
                completion:(void(^)(NSError *error, PIRedditListing *listing))completion {
    return [self searchFor:searchTerm limit:limit fullNameBefore:nil fullNameAfter:nil subreddit:nil time:0 otherParams:nil completion:completion];
}

- (NSOperation *)searchFor:(NSString *)searchTerm
                     limit:(NSUInteger)limit
            fullNameBefore:(NSString *)fullNameBefore
             fullNameAfter:(NSString *)fullNameAfter
                 subreddit:(NSString *)subreddit
                      time:(PIRedditTime)time
               otherParams:(NSDictionary *)otherParams
                completion:(void(^)(NSError *error, PIRedditListing *listing))completion
{
    NSParameterAssert(searchTerm);
    if (searchTerm.length > 512) {
        searchTerm = [searchTerm substringToIndex:512];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"q"] = searchTerm;
    if (limit) { params[@"limit"] = @(limit); }
    if (time != 0) { params[@"t"] = PIRedditStringFromTime(time); }
    if (fullNameBefore) { params[@"before"] = fullNameBefore; }
    if (fullNameAfter) { params[@"after"] = fullNameAfter; }
    if (otherParams.count) {
        for (NSString *key in otherParams.allKeys) {
            params[key] = otherParams[key];
        }
    }
    
    NSString *path = subreddit ? [NSString stringWithFormat:@"r/%@/search", subreddit] : @"search";
    __weak typeof(self) weakSelf = self;
    return [self requestOperationAtPath:path parameters:[params copy] completion:^(NSError *error, id responseObject) {
        [weakSelf parseListingWithError:error responseObject:responseObject completion:completion];
    }];
}

- (NSOperation *)commentsForLink:(NSString *)linkID
                           depth:(NSUInteger)depth
                           limit:(NSUInteger)limit
                      completion:(void(^)(NSError *error, id object))completion {
    NSParameterAssert(linkID);
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"article"] = linkID;
    if (limit) { params[@"limit"] = @(limit); }
    if (depth) { params[@"depth"] = @(depth); }
    return [self requestOperationAtPath:@"comments/article" parameters:@{@"article": linkID} completion:completion];
}

#pragma mark - Private Methods

- (void)parseListingWithError:(NSError *)error responseObject:(id)responseObject completion:(void (^)(NSError *, PIRedditListing *))completion {
    if (!error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *parseError;
            PIRedditListing *listing = [[PIRedditListing alloc] initWithDictionary:responseObject];
            if (!listing) {
                // TODO: Error
                parseError = [NSError errorWithDomain:PIRedditErrorDomain code:-1000 userInfo:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(parseError, listing);
            });
        });
    } else {
        completion(error, nil);
    }
}

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
    __weak typeof(self) weakSelf = self;
    NSOperation *retVal = [self.REST requestOperationWithMethod:HTTPMethod
                                                         atPath:path
                                                     parameters:parameters
                                          responseSerialization:nil
                                                     completion:completion ?
                           ^(NSError *error, id responseObject, NSURLRequest *originalRequest)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf processServerResponseError:error responseObject:responseObject originalRequest:originalRequest allowReauth:allowReauth completion:completion];
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        XLog(@"[1] %@", [NSThread currentThread]);
                        NSString *oldToken = self.accessToken;
                        [_tokenRefreshLock lock];
                        if ([self.accessToken isEqualToString:oldToken]) {
                            // Token is the same. Must reauthorize
                            [self refreshTokenWithCompletion:^(NSError *tokenError, NSString *newToken) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    XLog(@"[2] %@", [NSThread currentThread]);
                                    [_tokenRefreshLock unlock];
                                    if (tokenError) {
                                        completion(tokenError, nil);
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
        retValObject = responseObject;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(retValError, retValObject);
    });
}

#pragma mark - Token

- (void)refreshTokenWithCompletion:(void(^)(NSError *error, NSString *newToken))completion {
    if (!self.clientName.length) {
        // TODO: error
        NSError *error = [NSError errorWithDomain:PIRedditErrorDomain code:-1000 userInfo:nil];
        if (completion) {
            completion(error, nil);
        }
        return;
    }
    
    PIRedditRESTController *REST = [[PIRedditRESTController alloc] initWithSession:[NSURLSession sharedSession] baseURL:[NSURL URLWithString:@"https://www.reddit.com/api/v1/"]];

    REST.additionalHTTPHeaders = [NSDictionary pireddit_basicAuthDictionaryWithUser:self.clientName];
    NSOperation *op = [REST requestOperationWithMethod:kPIRHTTPMethodPOST
                                                atPath:@"access_token"
                                            parameters:@{@"grant_type": @"refresh_token",
                                                         // TODO: real refresh token here
                                                         @"refresh_token": self.refreshToken ?: @"45906542-yBkmMHPRtH5fXkz8nm43s2pvsSM"}
                                            completion:^(NSError *opError, id responseObject, NSURLRequest *originalRequest)
    {
        NSString *newToken;
        if (!opError) {
            NSDictionary *responseDic = GDDynamicCast(responseObject, NSDictionary);
            if (responseDic) {
                XLog(@"%@", responseDic);
                newToken = responseDic[@"access_token"];
                if (!newToken) {
                    // TODO: error
                    opError = [NSError errorWithDomain:PIRedditErrorDomain code:-1000 userInfo:@{NSLocalizedDescriptionKey: responseDic[@"error"] ?: @"Unknown error"}];
                }
            } else {
                // TODO: error
                opError = [NSError errorWithDomain:PIRedditErrorDomain code:-1000 userInfo:nil];
            }
        }
        
        if (completion) {
            completion(opError, newToken);
        }
    }];
    [self.operationQueue addOperation:op];
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
