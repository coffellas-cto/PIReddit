//
//  PIRedditNetworkingTests.m
//  RedditClient
//
//  Created by Alex G on 30.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditNetworking_Private.h"

@interface PIRedditNetworkingTests : XCTestCase

@end

@implementation PIRedditNetworkingTests {
    PIRedditNetworking *networking;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)setupNetworkingWithUserAgent:(NSString *)userAgent
                         redirectURI:(NSString *)redirectURI
                          clientName:(NSString *)clientName
                         accessToken:(NSString *)accessToken
                       encryptionKey:(NSString *)encryptionKey
{
    networking = [PIRedditNetworking new];
    networking.userAgent = userAgent;
    networking.redirectURI = redirectURI;
    networking.clientName = clientName;
    networking.accessToken = accessToken;
    networking.encryptionKey = encryptionKey;
}

- (void)properSetup {
    [self setupNetworkingWithUserAgent:@"RedditClientTestiOS"
                           redirectURI:@"testredditclient://apiredirect"
                            clientName:@"nhFJDb_f9RYThw"
                           accessToken:@"45906542-4SEAI3f6JfQ2fKQtZB-bQf2mC0I"
                         encryptionKey:@"q-nv2-tnt-v3t-q53-qt474-t"];
}

- (void)testUserAgentInvariant {
    NSString *s = @"userAgent";
    networking = [PIRedditNetworking new];
    networking.userAgent = @"userAgent";
    XCTAssertEqualObjects(s, networking.userAgent);
}

- (void)testRedirectURIInvariant {
    NSString *s = @"redirectURI";
    networking = [PIRedditNetworking new];
    networking.redirectURI = @"redirectURI";
    XCTAssertEqualObjects(s, networking.redirectURI);
}

- (void)testClientNameInvariant {
    NSString *s = @"clientName";
    networking = [PIRedditNetworking new];
    networking.clientName = @"clientName";
    XCTAssertEqualObjects(s, networking.clientName);
}

- (void)testAccessTokenInvariant {
    NSString *s = @"accessToken";
    networking = [PIRedditNetworking new];
    networking.accessToken = @"accessToken";
    XCTAssertEqualObjects(s, networking.accessToken);
}

- (void)testEncryptionKeyInvariant {
    NSString *s = @"encryptionKey";
    networking = [PIRedditNetworking new];
    networking.encryptionKey = @"encryptionKey";
    XCTAssertEqualObjects(s, networking.encryptionKey);
}

- (void)testSearch {
    [self properSetup];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    [networking searchFor:@"games" limit:1 completion:^(NSError *error, id responseObject) {
        XCTAssertNil(error);
        XCTAssertNotNil(responseObject);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

@end
