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
#import "PIRedditKeyChainManager.h"

static inline NSString *s_PIRedditAppRefreshTokenID(PIRedditApp *app) {
    return [NSString stringWithFormat:@"%lu.rt", (unsigned long)app.hash];
}

static inline NSString *s_PIRedditAppAccessTokenID(PIRedditApp *app) {
    return [NSString stringWithFormat:@"%lu.at", (unsigned long)app.hash];
}

@implementation PIRedditApp

#pragma mark - Accessors

@synthesize refreshToken = _refreshToken, accessToken = _accessToken;

- (NSString *)refreshToken {
    @synchronized(self) {
        if (!_refreshToken) {
            _refreshToken = [PIRedditKeyChainManager stringForIdentifier:s_PIRedditAppRefreshTokenID(self)];
        }
    }
    
    return _refreshToken;
}

- (void)setRefreshToken:(NSString *)refreshToken {
    @synchronized(self) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(refreshToken))];
        _refreshToken = refreshToken;
        NSString *refreshTokenID = s_PIRedditAppRefreshTokenID(self);
        if (!refreshToken) {
            [PIRedditKeyChainManager deletePasswordForIdentifier:refreshTokenID];
        } else {
            [PIRedditKeyChainManager savePassword:refreshToken forIdentifier:refreshTokenID];
        }
        [self didChangeValueForKey:NSStringFromSelector(@selector(refreshToken))];
    }
}

- (NSString *)accessToken {
    @synchronized(self) {
        if (!_accessToken) {
            _accessToken = [PIRedditKeyChainManager stringForIdentifier:s_PIRedditAppAccessTokenID(self)];
        }
    }
    
    return _accessToken;
}

- (void)setAccessToken:(NSString *)accessToken {
    @synchronized(self) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(accessToken))];
        _accessToken = accessToken;
        NSString *accessTokenID = s_PIRedditAppAccessTokenID(self);
        if (!accessToken) {
            [PIRedditKeyChainManager deletePasswordForIdentifier:accessTokenID];
        } else {
            [PIRedditKeyChainManager savePassword:accessToken forIdentifier:accessTokenID];
        }
        [self didChangeValueForKey:NSStringFromSelector(@selector(accessToken))];
    }
}

- (BOOL)isAuthorized {
    @synchronized(self) {
        return self.refreshToken.length && self.accessToken.length;
    }
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    
    return [self hash] == [object hash];
}

- (NSUInteger)hash {
    return [NSString stringWithFormat:@"%@%@%@", self.userAgent, self.redirectURI, self.clientName].hash;
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
