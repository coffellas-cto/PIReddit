//
//  PIRedditOperationTests.m
//  RedditClient
//
//  Created by Alex G on 23.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditOperation.h"
#import "XCTest+PIReddit.h"
#import "PIRedditSerializationStrategy.h"

@interface PIRedditOperationTests : XCTestCase {
    NSMutableURLRequest *_initialRequest;
}

@end

@implementation PIRedditOperationTests

- (void)setUp {
    [super setUp];
    
    _initialRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://google.com"] cachePolicy:0 timeoutInterval:30];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreation {
    PIRedditOperation *operation = [[PIRedditOperation alloc] initWithRequest:_initialRequest session:nil];
    XCTAssertNotNil(operation);
    XCTAssertFalse(operation.request == _initialRequest);
    XCTAssertTrue([operation.request isMemberOfClass:[NSURLRequest class]]);
    XCTAssertEqualObjects(operation.request, _initialRequest);
    
    __block BOOL blockCheck = NO;
    void(^completion)(NSHTTPURLResponse *, NSError *, id) = ^(NSHTTPURLResponse *response, NSError *error, NSData *responseData) {
        blockCheck = YES;
    };
    
    operation = [PIRedditOperation operationWithRequest:_initialRequest session:nil completion:completion];
    XCTAssertNotNil(operation);
    XCTAssertFalse(operation.request == _initialRequest);
    XCTAssertTrue([operation.request isMemberOfClass:[NSURLRequest class]]);
    XCTAssertEqualObjects(operation.request, _initialRequest);
    operation.completion(nil, nil, nil);
    XCTAssertTrue(blockCheck);
    XCTAssertEqualObjects(operation.completion, completion);
}

- (void)testBasicRequest {
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    PIRedditOperation *operation = [PIRedditOperation operationWithRequest:_initialRequest session:[NSURLSession sharedSession] completion:^(NSHTTPURLResponse *response, NSError *error, NSData *responseData) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(responseData);
        XCTAssertTrue([response isKindOfClass:[NSHTTPURLResponse class]]);
        XCTAssertEqual(response.statusCode, 200);
        XCTAssertFalse(operation.executing);
        [exp fulfill];
    }];
    PIRedditSerializationStrategy *strategy = [[PIRedditSerializationStrategy alloc] initWithStrategyType:PIRedditSerializationStrategyPlainText];
    strategy.plainTextEncoding = NSASCIIStringEncoding;
    operation.serializationStrategy = strategy;
    
    XCTAssertFalse(operation.executing);
    XCTAssertFalse(operation.finished);
    
    [[NSOperationQueue new] addOperation:operation];
    XCTAssertFalse(operation.finished);
    
    [self startExpectations];
    XCTAssertFalse(operation.executing);
    XCTAssertTrue(operation.finished);
}

- (void)testTimeout {
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    _initialRequest.timeoutInterval = 0.0001;
    PIRedditOperation *op = [PIRedditOperation operationWithRequest:_initialRequest session:[NSURLSession sharedSession] completion:^(NSHTTPURLResponse *response, NSError *error, NSData *responseData) {
        XCTAssertNil(response);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, NSURLErrorTimedOut);
        [exp fulfill];
    }];
    [op start];
    [self startExpectations];
}

- (void)testBadRequests {
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    // Hope this url is invalid :)
    _initialRequest.URL = [NSURL URLWithString:@"https://blablavb493f02fh-2f-2-fn-23f23hf-923h8f320fh-23hf-23f-2h3-f23f923hf-23h-923hfh23-fh23-f92h3-fh23-f.195"];
    PIRedditOperation *op = [PIRedditOperation operationWithRequest:_initialRequest session:[NSURLSession sharedSession] completion:^(NSHTTPURLResponse *response, NSError *error, NSData *responseData) {
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, NSURLErrorCannotFindHost);
        [exp fulfill];
    }];
    [op start];
    [self startExpectations];
}

- (void)testCancellation {
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    PIRedditOperation *op = [PIRedditOperation operationWithRequest:_initialRequest session:[NSURLSession sharedSession] completion:^(NSHTTPURLResponse *response, NSError *error, NSData *responseData) {
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, NSURLErrorCancelled);
        [exp fulfill];
    }];
    [op cancel];
    [op start];
    [self startExpectations];
}

@end
