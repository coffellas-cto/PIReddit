//
//  PIRedditSerializationStrategyTests.m
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditSerializationStrategy.h"

@interface PIRedditSerializationStrategyTests : XCTestCase

@end

@implementation PIRedditSerializationStrategyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDefault {
    PIRedditSerializationStrategy *strategy = [PIRedditSerializationStrategy new];
    XCTAssertEqual(strategy.strategyType, PIRedditSerializationStrategyJSON);
    XCTAssertEqual(strategy.plainTextEncoding, NSUTF8StringEncoding);
}

- (void)testJSON {
    NSDictionary *initialDic = @{@"key1": @"value", @"key2": @100};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:initialDic options:0 error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(data);
    
    PIRedditSerializationStrategy *strategy = [[PIRedditSerializationStrategy alloc] initWithStrategyType:PIRedditSerializationStrategyJSON];
    XCTAssertEqual(strategy.strategyType, PIRedditSerializationStrategyJSON);

    id restoredDic = [strategy serializeData:data error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(restoredDic);
    XCTAssertTrue([restoredDic isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(initialDic, restoredDic);
}

- (void)testJSONFailure {
    NSData *data = [@"This is not a JSON" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNotNil(data);
    
    PIRedditSerializationStrategy *strategy = [[PIRedditSerializationStrategy alloc] initWithStrategyType:PIRedditSerializationStrategyJSON];
    NSError *error;
    id restoredDic = [strategy serializeData:data error:&error];
    XCTAssertNotNil(error);
    XCTAssertNil(restoredDic);
}

- (void)testNone {
    PIRedditSerializationStrategy *strategy = [[PIRedditSerializationStrategy alloc] initWithStrategyType:PIRedditSerializationStrategyNone];
    id test = @"test";
    NSError *error;
    id serialized = [strategy serializeData:test error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(test, serialized);
}

@end
