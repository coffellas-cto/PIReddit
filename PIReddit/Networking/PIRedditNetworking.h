//
//  PIRedditNetworking.h
//  RedditClient
//
//  Created by Alex G on 28.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PIRedditNetworkingCompletion)(NSError *error, id responseObject);

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
 Processes Reddit's OAuth redirect URL.
 @param redirectURL URL received in `AppDelegate`'s `application:openURL:options:` method.
 @param error A pointer to `NSError *` object to be set if URL is not successfully processed or its content is unexpected.
 @return `YES` no error occured, `NO` otherwise.
 */
- (BOOL)processRedirectURL:(NSURL *)redirectURL error:(NSError *__autoreleasing *)error;

// TODO:
// https://www.reddit.com/dev/api/oauth#GET_search

/**
 Search links page on Reddit.
 @param searchTerm A string to search for (512 characters maximum).
 @param limit The maximum number of items desired (default: 25, maximum: 100).
 @param completion Block to be called after response is received.
 */
- (void)searchFor:(NSString *)searchTerm
            limit:(NSUInteger)limit
       completion:(PIRedditNetworkingCompletion)completion;

/**
 Singleton accessor.
 @return Static `PIRedditNetworking` singleton instance.
 */
+ (instancetype)sharedInstance;

@end
