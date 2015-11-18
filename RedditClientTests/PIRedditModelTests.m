//
//  PIRedditModelTests.m
//  RedditClient
//
//  Created by Alex G on 18.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditModel.h"

@interface PIRedditModelTests : XCTestCase

@end

@implementation PIRedditModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmptyInitializer {
    XCTAssertNil([[PIRedditModel alloc] init]);
}

- (void)testNonDictionary {
    XCTAssertNil([[PIRedditModel alloc] initWithDictionary:(NSDictionary *)@[]]);
}

- (void)testNormal {
    XCTAssertNotNil([[PIRedditModel alloc] initWithDictionary:@{}]);
}

@end
