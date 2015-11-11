//
//  PIRedditApp.m
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

#import "PIRedditApp.h"

@implementation PIRedditApp

#pragma mark - Accessors

- (void)setRefreshToken:(NSString *)refreshToken {
    @synchronized(self) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(refreshToken))];
        _refreshToken = refreshToken;
        [self didChangeValueForKey:NSStringFromSelector(@selector(refreshToken))];
    }
}

- (void)setAccessToken:(NSString *)accessToken {
    @synchronized(self) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(accessToken))];
        _accessToken = accessToken;
        [self didChangeValueForKey:NSStringFromSelector(@selector(accessToken))];
    }
}

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithUserAgent:nil redirectURI:nil clientName:nil];
}

- (instancetype)initWithUserAgent:(NSString *)userAgent
                      redirectURI:(NSString *)redirectURI
                       clientName:(NSString *)clientName {
    self = [super init];
    if (self) {
        _userAgent = userAgent;
        _redirectURI = redirectURI;
        _clientName = clientName;
    }
    return self;
}

+ (instancetype)appWithUserAgent:(NSString *)userAgent
                     redirectURI:(NSString *)redirectURI
                      clientName:(NSString *)clientName {
    return [[self alloc] initWithUserAgent:userAgent redirectURI:redirectURI clientName:clientName];
}

@end
