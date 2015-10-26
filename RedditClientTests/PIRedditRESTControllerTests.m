//
//  PIRedditRESTControllerTests.m
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTest+PIReddit.h"
#import "PIRedditRESTController.h"
#import "PIRedditSerializationStrategy.h"
#import "PIRMockSession.h"

@interface PIRedditRESTControllerTests : XCTestCase

@end

@implementation PIRedditRESTControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testREST {
    PIRedditRESTController *rest = [[PIRedditRESTController alloc] initWithSession:[NSURLSession sharedSession] baseURL:[NSURL URLWithString:@"https://google.com"]];
    XCTAssertNotNil(rest);
    XCTAssertEqualObjects(rest.baseURL, [NSURL URLWithString:@"https://google.com"]);
    XCTAssertEqualObjects(rest.session, [NSURLSession sharedSession]);
    
    rest.additionalHTTPHeaders = @{@"User-Agent": @"PIReddit"};
    XCTAssertEqualObjects(rest.additionalHTTPHeaders, @{@"User-Agent": @"PIReddit"});
}

- (void)testOperation {
    PIRedditRESTController *rest = [[PIRedditRESTController alloc] initWithSession:[NSURLSession sharedSession] baseURL:[NSURL URLWithString:@"https://google.com"]];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    PIRedditSerializationStrategy *strategy = [[PIRedditSerializationStrategy alloc] initWithStrategyType:PIRedditSerializationStrategyPlainText];
    strategy.plainTextEncoding = NSASCIIStringEncoding;
    NSOperation *op = [rest requestOperationWithMethod:@"GET" atPath:@"/" parameters:nil responseSerialization:strategy completion:^(NSError *error, id responseObject) {
        XCTAssertNil(error);
        XCTAssertNotNil(responseObject);
        XCTAssertTrue([responseObject isKindOfClass:[NSString class]]);
        [exp fulfill];
    }];
    [op start];
    
    [self startExpectations];
}

- (void)testJSONRequestMockGET1 {
    PIRMockSession *mockSession = [PIRMockSession new];
    PIRedditRESTController *rest = [[PIRedditRESTController alloc] initWithSession:mockSession baseURL:[NSURL URLWithString:@"https://reddit.mock/mockapi/v1"]];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    NSOperation *op = [rest requestOperationWithMethod:@"GET" atPath:@"me" parameters:@{@"showMockDummyResponse": @(YES)}  completion:^(NSError *error, id responseObject) {
        XCTAssertNil(error);
        XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]]);
        XCTAssertTrue([GDDynamicCast(responseObject[@"mock"], NSString) isEqualToString:@"duck"]);
        XCTAssertEqualObjects(responseObject[@"mockDummyResponse"], @(100));
        [exp fulfill];
    }];
    [op start];
    
    [self startExpectations];
}

- (void)testJSONRequestMockGET2 {
    PIRMockSession *mockSession = [PIRMockSession new];
    PIRedditRESTController *rest = [[PIRedditRESTController alloc] initWithSession:mockSession baseURL:[NSURL URLWithString:@"https://reddit.mock/mockapi/v1"]];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    NSOperation *op = [rest requestOperationWithMethod:@"GET" atPath:@"me" parameters:@{@"showMockDummyResponse": @(NO)}  completion:^(NSError *error, id responseObject) {
        XCTAssertNil(error);
        XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]]);
        XCTAssertTrue([GDDynamicCast(responseObject[@"mock"], NSString) isEqualToString:@"duck"]);
        XCTAssertEqualObjects(responseObject[@"newResponse"], @(11.111));
        [exp fulfill];
    }];
    [op start];
    
    [self startExpectations];
}

@end
