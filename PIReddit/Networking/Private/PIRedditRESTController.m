//
//  PIRedditRESTController.m
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

#import "PIRedditRESTController.h"
#import "PIRedditOperation.h"
#import "PIRedditSerializationStrategy.h"
#import "PIRedditCommon.h"

@implementation PIRedditRESTController {
    NSLock *_headersLock;
}

@synthesize timeoutInterval = _timeoutInterval;

#pragma mark - Accessors

- (void)setAdditionalHTTPHeaders:(NSDictionary *)additionalHTTPHeaders {
    [_headersLock lock];
    _additionalHTTPHeaders = additionalHTTPHeaders;
    [_headersLock unlock];
}

- (NSTimeInterval)timeoutInterval {
    NSTimeInterval retVal;
    @synchronized(self) {
        retVal = _timeoutInterval ?: 30.0;
    }
    
    return retVal;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    @synchronized(self) {
        _timeoutInterval = timeoutInterval;
    }
}

#pragma mark - Public Methods

- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 completion:(void (^)(NSError *error, id responseObject, NSURLRequest *originalRequest))completion
{
    return [self requestOperationWithMethod:HTTPMethod atPath:path parameters:parameters responseSerialization:nil completion:completion];
}


- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                      responseSerialization:(PIRedditSerializationStrategy *)responseSerialization
                                 completion:(void (^)(NSError *error, id responseObject, NSURLRequest *originalRequest))completion
{
    NSParameterAssert(HTTPMethod);
    NSAssert(!parameters || [parameters isKindOfClass:[NSDictionary class]], nil);
    NSString *paramsString = nil;
    if (parameters) {
        NSMutableArray *parametersPairsArray = [[NSMutableArray alloc] initWithCapacity:parameters.count];
        for (id key in parameters) {
            [parametersPairsArray addObject:[NSString stringWithFormat:@"%@=%@", [[key description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]], [[parameters[key] description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]];
        }
        paramsString = [parametersPairsArray componentsJoinedByString:@"&"];
    }
    
    BOOL encodeParamsInURIForMethod = NO;
    if (paramsString && (encodeParamsInURIForMethod = [self encodeParamsInURIForMethod:HTTPMethod])) {
            path = [path stringByAppendingFormat:@"?%@", paramsString];
    }
    
    NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
    request.HTTPMethod = HTTPMethod;
    [_headersLock lock];
    for (id key in self.additionalHTTPHeaders) {
        [request setValue:self.additionalHTTPHeaders[key] forHTTPHeaderField:key];
    }
    [_headersLock unlock];
    
    if (paramsString && !encodeParamsInURIForMethod) {
        // Encode params in body
        NSData *data = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            [request setHTTPBody:data];
        } else {
            // TODO: Error
        }
    }
    
    return [self requestOperationWithRequest:[request copy] responseSerialization:responseSerialization completion:completion];
}

- (NSOperation *)requestOperationWithRequest:(NSURLRequest *)urlRequest
                       responseSerialization:(PIRedditSerializationStrategy *)responseSerialization
                                  completion:(void (^)(NSError *error, id responseObject, NSURLRequest *originalRequest))completion
{
    PIRedditOperation *op = [PIRedditOperation operationWithRequest:urlRequest session:self.session completion:^(NSHTTPURLResponse *response, NSError *error, id responseObject) {
        if (completion) {
            if (!error) {
                if (response.statusCode > 399 && response.statusCode <= 599) {
                    error = [NSError errorWithDomain:PIRedditURLErrorDomain code:response.statusCode userInfo:@{NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]}];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error, responseObject, urlRequest);
            });
        }
    }];
    
    if (responseSerialization) {
        op.serializationStrategy = responseSerialization;
    }
    
    return op;
}

#pragma mark - Private Method

- (BOOL)encodeParamsInURIForMethod:(NSString *)HTTPMethod {
    static NSSet *s_PIRedditRESTControllerMethodsUseParamsInURI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_PIRedditRESTControllerMethodsUseParamsInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
    });
    
    return [s_PIRedditRESTControllerMethodsUseParamsInURI containsObject:HTTPMethod];
}

#pragma mark - Life Cycle

- (instancetype)initWithSession:(NSURLSession *)session baseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _session = session;
        _baseURL = baseURL;
        _headersLock = [NSLock new];
    }
    return self;
}

- (instancetype)init {
    return [self initWithSession:nil baseURL:nil];
}

@end
