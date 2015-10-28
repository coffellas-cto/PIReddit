//
//  PIRedditNetworking.h
//  RedditClient
//
//  Created by Alex G on 28.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class that sends requests to Reddit API.
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


@end
