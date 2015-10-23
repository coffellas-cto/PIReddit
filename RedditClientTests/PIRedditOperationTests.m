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
    void(^completion)(NSURLResponse *, NSError *, id) = ^(NSURLResponse *response, NSError *error, id responseObject) {
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
    PIRedditOperation *operation = [PIRedditOperation operationWithRequest:_initialRequest session:[NSURLSession sharedSession] completion:^(NSURLResponse *response, NSError *error, id responseObject) {
        NSLog(@"ref to self: %@", self);
        NSLog(@"%@\n%@\n%@", response, error, responseObject);
        XCTAssertFalse(operation.executing);
        [exp fulfill];
    }];
    
    XCTAssertFalse(operation.executing);
    XCTAssertFalse(operation.finished);
    
    [[NSOperationQueue new] addOperation:operation];
    XCTAssertFalse(operation.finished);
    
    [self startExpectations];
    XCTAssertFalse(operation.executing);
    XCTAssertTrue(operation.finished);
}

@end