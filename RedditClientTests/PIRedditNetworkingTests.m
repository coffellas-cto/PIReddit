//
//  PIRedditNetworkingTests.m
//  RedditClient
//
//  Created by Alex G on 30.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditNetworking.h"
#import "PIRedditApp_Private.h"
#import "PIRedditListing.h"
#import "PIRedditLink.h"
#import "CommonConstants.h"

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

- (void)testSingleton {
    PIRedditNetworking *networking1 = [PIRedditNetworking sharedInstance];
    XCTAssertNotNil(networking1);
    PIRedditNetworking *networking2 = [PIRedditNetworking sharedInstance];
    XCTAssertNotNil(networking2);
    XCTAssertEqual(networking1, networking2);
}

- (void)setupNetworkingWithUserAgent:(NSString *)userAgent
                         redirectURI:(NSString *)redirectURI
                          clientName:(NSString *)clientName
                         accessToken:(NSString *)accessToken
                        refreshToken:(NSString *)refreshToken
                         forceLogout:(BOOL)forceLogout
{
    networking = [PIRedditNetworking new];
    PIRedditApp *app = [PIRedditApp appWithUserAgent:userAgent redirectURI:redirectURI clientName:clientName];
    [networking setRedditApp:app];
    if (forceLogout) {
        [networking cleanSession];
        XCTAssertFalse(app.authorized);
        app.accessToken = accessToken;
        app.refreshToken = refreshToken;
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!app.authorized) {
                app.accessToken = accessToken;
                app.refreshToken = refreshToken;
            }
        });
    }
    
    XCTAssertTrue(app.authorized);
}

- (void)setupWithForceLogout:(BOOL)forceLogout {
    [self setupNetworkingWithUserAgent:kCommonUserAgent
                           redirectURI:kCommonRedirectURI
                            clientName:kCommonClientName
                           accessToken:@"45906542-4SEAI3f6JfQ2fKQtZB-bQf2mC0I"
                          refreshToken:@"45906542-yBkmMHPRtH5fXkz8nm43s2pvsSM"
                           forceLogout:forceLogout];
}

- (void)properSetup {
    [self setupWithForceLogout:NO];
}

- (void)forceLogoutSetup {
    [self setupWithForceLogout:YES];
}

- (void)testSearch {
    [self forceLogoutSetup];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    [networking searchFor:@"games" limit:2 completion:^(NSError *error, PIRedditListing *responseObject) {
        XCTAssertTrue(networking.app.authorized);
        XCTAssertNil(error);
        XCTAssertNotNil(responseObject);
        XCTAssertEqual(responseObject.children.count, 2);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

- (void)testInadequateSearch {
    [self properSetup];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    char long_random_str[514] = {0};
    for (int i = 0; i < 513; i++) {
        long_random_str[i] = arc4random_uniform(50) + 40;
    }
    
    XCTAssertEqual(strlen(long_random_str), 513);
    NSString *longString = [[NSString alloc] initWithCString:long_random_str encoding:NSASCIIStringEncoding];
    [networking searchFor:longString limit:2 completion:^(NSError *error, PIRedditListing *responseObject) {
        XCTAssertNil(error);
        XCTAssertNotNil(responseObject);
        XCTAssertEqual(responseObject.children.count, 0);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

- (void)testSubredditSearch {
    [self properSetup];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    [networking searchFor:@"lineage" limit:2 fullNameBefore:nil fullNameAfter:nil subreddit:@"games" time:PIRedditTimeAll otherParams:nil completion:^(NSError *error, PIRedditListing *listing) {
        XCTAssertNil(error);
        XCTAssertNotNil(listing);
        XCTAssertEqual(listing.children.count, 2);
        PIRedditLink *fakeAfter = (PIRedditLink *)listing.children[0];
        PIRedditLink *lastLink = (PIRedditLink *)listing.children[1];
        XCTAssertEqualObjects(listing.fullNameAfter, lastLink.fullName);
        [networking searchFor:@"lineage" limit:2 fullNameBefore:nil fullNameAfter:fakeAfter.fullName subreddit:@"games" time:PIRedditTimeAll otherParams:nil completion:^(NSError *error, PIRedditListing *listing2) {
            XCTAssertNil(error);
            XCTAssertNotNil(listing2);
            XCTAssertEqual(listing2.children.count, 2);
            XCTAssertTrue([lastLink.fullName isEqualToString:((PIRedditLink *)listing2.children[0]).fullName]);
            XCTAssertFalse([lastLink.fullName isEqualToString:((PIRedditLink *)listing2.children[1]).fullName]);
            [exp fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

- (void)testCommentsRetrieval {
    [self properSetup];
    XCTestExpectation *exp = [self expectationWithDescription:@(__PRETTY_FUNCTION__)];
    [networking commentsForLink:@"2j3c5p" depth:0 limit:1 completion:^(NSError *error, id object) {
        XCTAssertNil(error);
        XCTAssertNotNil(object);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1000 handler:nil];
}

@end
