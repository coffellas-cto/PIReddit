//
//  AppDelegate.m
//  RedditClient
//
//  Created by Alex G on 21.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PIRedditNetworking.h"
#import "PIRedditApp.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[PIRedditNetworking sharedInstance] processRedirectURL:url completion:^(NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Failed to retrieve auth token: %@", error.localizedDescription ?: @"Unknown error."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reddit_authorized" object:nil];
        }
    }];
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    
    PIRedditApp *app = [PIRedditApp appWithUserAgent:@"RedditClientTestiOS"
                                         redirectURI:@"testredditclient://apiredirect"
                                          clientName:@"nhFJDb_f9RYThw"];
    
    [[PIRedditNetworking sharedInstance] setRedditApp:app];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!app.authorized) {
            // Read the manual
            // https://github.com/reddit/reddit/wiki/OAuth2
            [[PIRedditNetworking sharedInstance] authorize];   
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reddit_authorized" object:nil];
        }
    });
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
