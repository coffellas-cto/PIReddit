//
//  XCTest+PIReddit.m
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "XCTest+PIReddit.h"

@implementation XCTestCase (PIReddit)

- (void)startExpectations {
    [self waitForExpectationsWithTimeout:1000 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
