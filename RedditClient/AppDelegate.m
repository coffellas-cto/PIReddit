//
//  AppDelegate.m
//  RedditClient
//
//  Created by Alex G on 21.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([url.host isEqualToString:@"apiredirect"]) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        for (NSURLQueryItem *item in queryItems) {
            if ([item.name isEqualToString:@"code"]) {
                NSString *code = item.value;
                
                NSData *authData = [@"nhFJDb_f9RYThw:" dataUsingEncoding:NSASCIIStringEncoding];
                NSString *authValue = [NSString stringWithFormat:@"Basic %@", [[NSString alloc] initWithData:[authData base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding]];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.reddit.com/api/v1/access_token"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[[NSString stringWithFormat:@"grant_type=authorization_code&code=%@&redirect_uri=testredditclient://apiredirect", code] dataUsingEncoding:NSASCIIStringEncoding]];
                [request setValue:authValue forHTTPHeaderField:@"Authorization"];
                
                [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            NSString *errorString = error.localizedDescription;
                            if (!errorString && [response isKindOfClass:[NSHTTPURLResponse class]]) {
                                errorString = [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *)response).statusCode];
                            }
                            [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Failed to retrieve auth token: %@", errorString ?: @"Unknown error."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                        if (!error) {
                            NSError *JSONError = nil;
                            NSDictionary *responseObject = GDDynamicCast([NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError], NSDictionary);
                            XLog(@"%@", responseObject);
                            NSString *tokenType = GDDynamicCast(responseObject[@"token_type"], NSString);
                            NSString *accessToken = GDDynamicCast(responseObject[@"access_token"], NSString);
                            NSString *refreshToken = GDDynamicCast(responseObject[@"refresh_token"], NSString);
                            if (tokenType.length && accessToken.length) {
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setObject:accessToken forKey:@"accessToken"];
                                [defaults setObject:tokenType forKey:@"tokenType"];
                                if (refreshToken.length) {
                                    [defaults setObject:refreshToken forKey:@"refreshToken"];
                                }
                                
                                [defaults synchronize];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"OAuthTokenDidReceive" object:nil];
                            } else {
                                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to retrieve auth token" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            }
                        }
                    });
                }] resume];
                
                break;
            }
        }
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
