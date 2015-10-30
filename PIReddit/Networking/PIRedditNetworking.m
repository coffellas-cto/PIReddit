//
//  PIRedditNetworking.m
//  RedditClient
//
//  Created by Alex G on 28.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

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
        NSURL *baseURL = [NSURL URLWithString:@"https://www.reddit.com/api/"];
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
