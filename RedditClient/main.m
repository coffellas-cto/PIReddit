//
//  main.m
//  RedditClient
//
//  Created by Alex G on 21.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appDelegateClassName = nil;
        
        NSString *testBundlePath = [NSProcessInfo processInfo].environment[@"TestBundleLocation"];
#if !TARGET_IPHONE_SIMULATOR
        NSString *testBundleName = [testBundlePath lastPathComponent];
        testBundlePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:testBundleName] stringByStandardizingPath];
#endif
        if (testBundlePath) {
            NSError *error = nil;
            NSBundle *testBundle = [NSBundle bundleWithPath:testBundlePath];
            [testBundle load];
            if(testBundle == nil || error) {
                NSLog(@"Error loading bundle %@: %@", testBundle, error);
            }
            
            appDelegateClassName = @"TestAppDelegate";
        } else {
            appDelegateClassName = NSStringFromClass([AppDelegate class]);
        }
        
        return UIApplicationMain(argc, argv, nil, appDelegateClassName);
    }
}
