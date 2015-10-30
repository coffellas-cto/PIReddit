//
//  PIRedditNetworking.m
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

#import "PIRedditNetworking_Private.h"
#import "PIRedditRESTController.h"
#import "PIRedditSerializationStrategy.h"

@interface PIRedditNetworking ()

@property (readonly, nonatomic) PIRedditRESTController *REST;

@end

@implementation PIRedditNetworking

@synthesize REST = _REST;

#pragma mark - Accessors

- (void)setAccessToken:(NSString *)accessToken {
    @synchronized(self) {
        _accessToken = accessToken;
    }
}

- (PIRedditRESTController *)REST {
    if (!_REST) {
        NSURL *baseURL = [NSURL URLWithString:@"https://oauth.reddit.com/"];
        _REST = [[PIRedditRESTController alloc] initWithSession:[NSURLSession sharedSession] baseURL:baseURL];
    }
    
    return _REST;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

@end
