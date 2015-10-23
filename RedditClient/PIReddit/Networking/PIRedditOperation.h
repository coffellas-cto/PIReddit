//
//  PIRedditOperation.h
//  RedditClient
//
//  Created by Alex G on 23.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `PIRedditOperation` is a subclass of `NSOperation` for performing basic HTTP/HTTPS requests.
 */
@interface PIRedditOperation : NSOperation

/**
 Request object the operation was initialized with.
 */
@property (readonly, strong, atomic) NSURLRequest *request;

/**
 The block to be executed on the completion of a request. This block has no return value and takes three arguments:
 the response object;
 an error if any;
 an object constructed from the response data of the request if any.
 Changes to the property are ignored once the operation starts.
 */
@property (readwrite, copy, nonatomic) void (^completion)(NSURLResponse *response, NSError *error, id responseObject);

/**
 Initializes and returns a newly allocated operation object with the specified url request.
 This is the designated initializer.
 @param urlRequest The request object to be used by the operation.
 @param session The URL session to perform the task on.
 */
- (instancetype)initWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/**
 Initializes and returns a newly allocated operation object with the specified url request and its completion handler.
 This is the "factory method".
 @param urlRequest The request object to be used by the operation.
 @param session The URL session to perform the task on.
 @param completion The block to be executed on the completion of a request. This block has no return value and takes three arguments: the response object; an error if any; the object constructed from the response data of the request if any.
 */
+ (PIRedditOperation *)operationWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session completion:(void (^)(NSURLResponse *response, NSError *error, id responseObject))completion;

@end
