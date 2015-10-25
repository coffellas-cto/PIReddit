//
//  PIRedditOperation.h
//  RedditClient
//
//  Created by Alex G on 23.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIRedditSerializationStrategy;

/**
 `PIRedditOperation` is a subclass of `NSOperation` for performing basic HTTP/HTTPS requests.
 */
@interface PIRedditOperation : NSOperation

/**
 Request object the operation was initialized with.
 */
@property (readonly, strong, atomic) NSURLRequest *request;

/**
 The block to be executed upon the completion of a request. This block has no return value and takes three arguments:
 the response object;
 an error if any;
 the object serialized from response data using the strategy from `serializationStrategy` property.
 Changes to the property are ignored once the operation starts.
 
 @discussion
 The completion block is removed after being called, thus eliminating retain-cycle effects. On the other hand, if you are not sure that the handler is ever going to be executed (e.g. you don't call `start` for the operation or don't add it to any queue), general rules for avoiding retain-cycles should be followed.
 */
@property (readwrite, copy, atomic) void (^completion)(NSHTTPURLResponse *response, NSError *error, id responseObject);

/**
 Strategy used to serialize data. Default strategy serializes to JSON.
 */
@property (readwrite, strong, atomic) PIRedditSerializationStrategy *serializationStrategy;

/**
 Initializes and returns a newly allocated operation object with the specified url request.
 This is the designated initializer.
 @param urlRequest The request object to be used by the operation.
 @param session The URL session to perform the task on.
 @return Newly allocated operation object.
 */
- (instancetype)initWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/**
 Initializes and returns a newly allocated operation object with the specified url request and its completion handler.
 This is the "factory method".
 @param urlRequest The request object to be used by the operation.
 @param session The URL session to perform the task on.
 @param completion The block to be executed upon the completion of a request. This block has no return value and takes three arguments:
 the response object;
 an error if any;
 the object serialized from response data using the strategy from `serializationStrategy` property.
 @return Newly allocated operation object.
 
 @discussion
 The completion block is removed after being called, thus eliminating retain-cycle effects. On the other hand, if you are not sure that the handler is ever going to be executed (e.g. you don't call `start` for the operation or don't add it to any queue), general rules for avoiding retain-cycles should be followed.
 */
+ (PIRedditOperation *)operationWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session completion:(void (^)(NSHTTPURLResponse *response, NSError *error, id responseObject))completion;

@end
