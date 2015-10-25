//
//  PIRedditRESTController.h
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

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
 */
@property (readwrite, strong, atomic) NSURL *baseURL;

/**
 Additional HTTP headers to send with every request.
 */
@property (readwrite, strong, atomic) NSDictionary *additionalHTTPHeaders;

/**
 The timeout interval for the request. Default is 30 sec.
 */
@property (assign, readwrite, nonatomic) NSTimeInterval timeoutInterval;

/**
 Initializes and returns a newly allocated asynchronous operation object which manages the request at the specified path.
 @param HTTPMethod HTTP request method.
 @param path Path relative to `baseURL`.
 @param parameters Dictionary which represents parameters for the request.
 @param completion The block to be executed upon the completion of a request. This block has no return value and takes two arguments:
 the de-srialized response object; an error if any. It is always called on main thread.
 
 @return Newly allocated operation object.
 
 @discussion The returned operation is not started immediately. You must add it to operation queue or fire manually. Using this method yields to serializing response via `PIRedditSerializationStrategyJSON` strategy.
 */
- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 completion:(void(^)(NSError *error, id responseObject))completion;

/**
 Initializes and returns a newly allocated asynchronous operation object which manages the request at the specified path.
 @param HTTPMethod HTTP request method.
 @param path Path relative to `baseURL`.
 @param parameters Dictionary which represents parameters for the request.
 @param responseSerialization  Strategy used to serialize data. Default strategy serializes to JSON.
 @param completion The block to be executed upon the completion of a request. This block has no return value and takes two arguments:
 the de-srialized response object; an error if any. It is always called on main thread.
 
 @return Newly allocated operation object.
 
 @discussion The returned operation is not started immediately. You must add it to operation queue or fire manually.
 */
- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                      responseSerialization:(PIRedditSerializationStrategy *)responseSerialization
                                 completion:(void(^)(NSError *error, id responseObject))completion;

/**
 Initializes and returns a newly allocated REST controller object with the specified URL session and base URL.
 This is the designated initializer.
 @param session The URL session to perform the task on.
 @param baseURL The base URL for performing requests to addresses relative to it.
 @return Newly allocated REST controller object.
 */
- (instancetype)initWithSession:(NSURLSession *)session baseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

@end
