//
//  PIRedditApp.h
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

/**
 Class which represents reddit client's basic settings. It is also used to save authorization details.
 */
@interface PIRedditApp : NSObject

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
 Current refresh token.
 */
@property (readonly, copy, atomic) NSString *refreshToken;

/**
 Initializes and returns a newly allocated app object with the specified settings.
 This is the designated initializer.
 @param userAgent User agent string to forward in User-Agent HTTP header field.
 @param redirectURI Must correspond to `redirect uri` string you have used when creating your app at reddit.com.
 @param clientName Must correspond to `installed app` string which was generated after you created your app at reddit.com.
 @return Newly allocated and initialized app object.
 */
- (instancetype)initWithUserAgent:(NSString *)userAgent
                      redirectURI:(NSString *)redirectURI
                       clientName:(NSString *)clientName NS_DESIGNATED_INITIALIZER;

/**
 Initializes and returns a newly allocated app object with the specified settings.
 This is the "factory method".
 @param userAgent User agent string to forward in User-Agent HTTP header field.
 @param redirectURI Must correspond to `redirect uri` string you have used when creating your app at reddit.com.
 @param clientName Must correspond to `installed app` string which was generated after you created your app at reddit.com.
 @return Newly allocated and initialized app object.
 */
+ (instancetype)appWithUserAgent:(NSString *)userAgent
                     redirectURI:(NSString *)redirectURI
                      clientName:(NSString *)clientName;

@end
