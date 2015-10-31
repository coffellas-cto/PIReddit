//
//  PIRedditRESTController.h
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

#import <Foundation/Foundation.h>

@class PIRedditSerializationStrategy;

/**
 Controller class which performs requests to HTTP/HTTPS server described by `baseURL`.
 */
@interface PIRedditRESTController : NSObject

/**
 The URL session to perform the tasks on.
 */
@property (readwrite, strong, atomic) NSURLSession *session;
/**
 The base URL for performing requests to addresses relative to it.
 @discussion
 Base URL string must end with a `/` if you want to include the last path part of it in . E.g. "https://example.com/api/v1" is not the same as "https://example.com/api/v1/". Please consult Relative Uniform Resource Locators RFC for more info https://tools.ietf.org/html/rfc1808 .
 */
@property (readwrite, strong, atomic) NSURL *baseURL;

/**
 Additional HTTP headers to send with every request.
 */
@property (readwrite, strong, nonatomic) NSDictionary *additionalHTTPHeaders;

/**
 The timeout interval for the request. Default is 30 sec.
 */
@property (assign, readwrite, nonatomic) NSTimeInterval timeoutInterval;

/**
 Initializes and returns a newly allocated asynchronous operation object which manages the request at the specified path.
 @param HTTPMethod HTTP request method.
 @param path Path relative to `baseURL`. Should not be started with `/`.
 @param parameters Dictionary which represents parameters for the request.
 @param completion The block to be executed upon the completion of a request. This block has no return value and takes three arguments:
 an error if any; the de-serialized response object; original request. It is always called on main thread.
 
 @return Newly allocated operation object.
 
 @discussion The returned operation is not started immediately. You must add it to operation queue or fire manually. Using this method yields to serializing response via `PIRedditSerializationStrategyJSON` strategy.
 */
- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 completion:(void (^)(NSError *error, id responseObject, NSURLRequest *originalRequest))completion;

/**
 Initializes and returns a newly allocated asynchronous operation object which manages the request at the specified path.
 @param HTTPMethod HTTP request method.
 @param path Path relative to `baseURL`. Should not be started with `/`.
 @param parameters Dictionary which represents parameters for the request.
 @param responseSerialization  Strategy used to serialize data. Default strategy serializes to JSON.
 @param completion The block to be executed upon the completion of a request. This block has no return value and takes three arguments:
 an error if any; the de-serialized response object; original request. It is always called on main thread.
 
 @return Newly allocated operation object.
 
 @discussion The returned operation is not started immediately. You must add it to operation queue or fire manually.
 */
- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                      responseSerialization:(PIRedditSerializationStrategy *)responseSerialization
                                 completion:(void (^)(NSError *error, id responseObject, NSURLRequest *originalRequest))completion;

/**
 Initializes and returns a newly allocated asynchronous operation object which manages the request at the specified path.
 @param urlRequest The request object to be used by the operation.
 @param responseSerialization  Strategy used to serialize data. Default strategy serializes to JSON.
 @param completion The block to be executed upon the completion of a request. This block has no return value and takes three arguments:
 an error if any; the de-serialized response object; original request. It is always called on main thread.
 
 @return Newly allocated operation object.
 
 @discussion The returned operation is not started immediately. You must add it to operation queue or fire manually.
 */
- (NSOperation *)requestOperationWithRequest:(NSURLRequest *)urlRequest
                       responseSerialization:(PIRedditSerializationStrategy *)responseSerialization
                                  completion:(void (^)(NSError *error, id responseObject, NSURLRequest *originalRequest))completion;

/**
 Initializes and returns a newly allocated REST controller object with the specified URL session and base URL.
 This is the designated initializer.
 @param session The URL session to perform the task on.
 @param baseURL The base URL for performing requests to addresses relative to it.
 @return Newly allocated REST controller object.
 */
- (instancetype)initWithSession:(NSURLSession *)session baseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

@end
