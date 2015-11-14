//
//  PIRedditNetworking.h
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
#import "PIRedditConstants.h"

typedef void(^PIRedditNetworkingCompletion)(NSError *error, id responseObject);

@class PIRedditListing;
@class PIRedditApp;

/**
 Class that sends requests to Reddit API server.
 @attention You must set your application settings using the `setRedditApp:` method in order to be able to send any requests to Reddit API server.
 */
@interface PIRedditNetworking : NSObject

/**
 Operation queue on which all requests are executed.
 */
@property (readonly, strong, nonatomic) NSOperationQueue *operationQueue;

/**
 Application object used to initialize current instance with.
 */
@property (readonly, strong, atomic) PIRedditApp *app;

/**
 Tries to start OAuth2 authorization process for an application described by an `app` property.
 @discussion Catch the callback from Reddit OAuth in your `AppDelegate`'s `application:openURL:options:` and forward a received `url` object to `processRedirectURL:completion:` method of this class to finish authorization.
 
 Read about the whole routine here: https://github.com/reddit/reddit/wiki/OAuth2.
 @return `NO` if app object wasn't set up correctly.
 */
- (BOOL)authorize;

/**
 Logs out currently authorized user by cleaning tokens for `PIRedditApp`.
 */
- (void)cleanSession;

/**
 Processes Reddit's OAuth redirect URL.
 @param redirectURL URL received in `AppDelegate`'s `application:openURL:options:` method.
 @param completion A block which is called upon the completion of the operation. If an error occurs `error` parameter passed to the block represents the error, otherwise in contains `nil`.
 */
- (void)processRedirectURL:(NSURL *)redirectURL completion:(void(^)(NSError *error))completion;

/**
 Search links page on Reddit.
 @param searchTerm A string to search for (512 characters maximum). Cannot be `nil`.
 @param limit The maximum number of items desired (default: 25, maximum: 100).
 @param completion Block to be called after response is received.
 @return Operation object.
 */
- (NSOperation *)searchFor:(NSString *)searchTerm
                     limit:(NSUInteger)limit
                completion:(void(^)(NSError *error, PIRedditListing *listing))completion;

/**
 Search links page on Reddit.
 @param searchTerm A string to search for (512 characters maximum). Cannot be `nil`.
 @param limit The maximum number of items desired (default: 25, maximum: 100).
 @param fullNameBefore Previous link's fullname string.
 @param fullNameAfter Next link's fullname string.
 @param subreddit A subreddit to search on. Can be `nil`.
 @param time Creation time limit. One of `PIRedditTime` enum values. Can be 0.
 @param otherParams Dictionary of parameters as described at https://www.reddit.com/dev/api/oauth#GET_search. Can be `nil`.
 @param completion Block to be called after response is received.
 @return Operation object.
 */
- (NSOperation *)searchFor:(NSString *)searchTerm
                     limit:(NSUInteger)limit
            fullNameBefore:(NSString *)fullNameBefore
             fullNameAfter:(NSString *)fullNameAfter
                 subreddit:(NSString *)subreddit
                      time:(PIRedditTime)time
               otherParams:(NSDictionary *)otherParams
                completion:(void(^)(NSError *error, PIRedditListing *listing))completion;

/**
 Get the comment tree for a given Link article.
 @param linkID ID36 of a link.
 @param depth The maximum depth of subtrees in the thread.
 @param limit The maximum number of comments to return.
 @param completion Block to be called after response is received.
 @return Operation object.
 */
- (NSOperation *)commentsForLink:(NSString *)linkID
                           depth:(NSUInteger)depth
                           limit:(NSUInteger)limit
                      completion:(void(^)(NSError *error, id object))completion;

/**
 Sets the `PIRedditApp` application object as a dependecy.
 @param app Previousely set up reddit application object. Cannot be `nil`.
 */
- (void)setRedditApp:(PIRedditApp *)app;

/**
 Singleton accessor.
 @return Static `PIRedditNetworking` singleton instance.
 */
+ (instancetype)sharedInstance;

@end
