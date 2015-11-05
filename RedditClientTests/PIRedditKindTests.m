//
//  PIRedditKindTests.m
//  RedditClient
//
//  Created by Alex G on 05.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditKind.h"
#import "PIRedditLink.h"

@interface PIRedditKindTests : XCTestCase

@end

@implementation PIRedditKindTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreation {
    PIRedditKind *kind = [PIRedditKind redditKindWithDictionary:@{@"kind": @"t3", @"data": @{@"id": @"nvqe00s"}}];
    XCTAssertNotNil(kind);
    XCTAssertTrue([kind isKindOfClass:[PIRedditLink class]]);
}

- (void)testFailedCreations {
    PIRedditKind *kind = [PIRedditKind redditKindWithDictionary:nil];
    XCTAssertNil(kind);
    
    kind = [PIRedditKind redditKindWithDictionary:@{}];
    XCTAssertNil(kind);
    
    kind = [PIRedditKind redditKindWithDictionary:@{@"kind": @"t223"}];
    XCTAssertNil(kind);
    
    kind = [PIRedditKind redditKindWithDictionary:@{@"kind": @"t3", @"data": @{}}];
    XCTAssertNil(kind);
}

@end
