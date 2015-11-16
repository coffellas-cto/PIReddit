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

- (id)loadJSONFromFile:(NSString *)name ofType:(NSString *)ext {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:name ofType:ext];
    NSData *listingData = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    id retVal = [NSJSONSerialization JSONObjectWithData:listingData options:0 error:&error];
    XCTAssertNil(error);
    return retVal;
}

@end
