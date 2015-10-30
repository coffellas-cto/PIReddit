//
//  PIRedditOperation.h
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
