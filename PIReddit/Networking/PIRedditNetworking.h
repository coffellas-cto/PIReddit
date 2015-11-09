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

/**
 Class that sends requests to Reddit API.
 @attention If you don't set the `encryptionKey` property, no encryption will be used for locally saved token.
 */
@interface PIRedditNetworking : NSObject

/**
 User agent string to forward in User-Agent HTTP header field.
 */
@property (readwrite, copy, atomic) NSString *userAgent;
/**
 Must correspond to `redirect uri` string you have used when creating your app at reddit.com.
 */
@property (readwrite, copy, atomic) NSString *redirectURI;
/**
 Must correspond to `installed app` string which was generated after you created your app at reddit.com.
 */
@property (readwrite, copy, atomic) NSString *clientName;
/**
 Current access token.
 */
@property (readonly, copy, atomic) NSString *accessToken;
/**
 Key to encrypt locally saved token.
 @discussion This value must be the same between app launches, otherwise restored token will be corrupted.
 @attention No encryption will be used if you don't provide this key.
 */
@property (readwrite, copy, atomic) NSString *encryptionKey;

/**
 Operation queue on which all requests are executed.
 */
@property (readonly, strong, nonatomic) NSOperationQueue *operationQueue;

/**
 Processes Reddit's OAuth redirect URL.
 @param redirectURL URL received in `AppDelegate`'s `application:openURL:options:` method.
 @param error A pointer to `NSError *` object to be set if URL is not successfully processed or its content is unexpected.
 @return `YES` no error occured, `NO` otherwise.
 */
- (BOOL)processRedirectURL:(NSURL *)redirectURL error:(NSError *__autoreleasing *)error;

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

// TODO:
// https://www.reddit.com/dev/api/oauth#GET_search

/**
 Search links page on Reddit.
 @param searchTerm A string to search for (512 characters maximum). Cannot be `nil`.
 @param limit The maximum number of items desired (default: 25, maximum: 100).
 @param fullNameBefore Previous link's fullname string.
 @param fullNameAfter Next link's fullname string.
 @param subreddit A subreddit to search on. Can be `nil`.
 @param time Creation time limit. one of `PIRedditTime` enum values. Can be 0.
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
 Singleton accessor.
 @return Static `PIRedditNetworking` singleton instance.
 */
+ (instancetype)sharedInstance;

@end
