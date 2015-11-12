//
//  PIRedditKeychainManagerTests.m
//  RedditClient
//
//  Created by Alex G on 12.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditKeychainManager.h"

@interface PIRedditKeychainManagerTests : XCTestCase

@end

@implementation PIRedditKeychainManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFailedSearch {
    NSData *data = [PIRedditKeyChainManager searchKeychainCopyMatching:@"noKey"];
    XCTAssertNil(data);
}

- (void)testFailedDelete {
    XCTAssertFalse([PIRedditKeyChainManager deletePasswordForIdentifier:@"noKey"]);
}

- (void)testWorkflow {
    [PIRedditKeyChainManager savePassword:@"somePass" forIdentifier:@"ID1"];
    NSData *data = [PIRedditKeyChainManager searchKeychainCopyMatching:@"ID1"];
    XCTAssertNotNil(data);
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(result, @"somePass");
    
    [PIRedditKeyChainManager savePassword:@"newPass" forIdentifier:@"ID1"];
    data = [PIRedditKeyChainManager searchKeychainCopyMatching:@"ID1"];
    XCTAssertNotNil(data);
    result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(result, @"newPass");
    
    [PIRedditKeyChainManager deletePasswordForIdentifier:@"ID1"];
    XCTAssertNil([PIRedditKeyChainManager searchKeychainCopyMatching:@"ID1"]);
}

@end
