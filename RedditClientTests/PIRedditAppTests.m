//
//  PIRedditAppTests.m
//  RedditClient
//
//  Created by Alex G on 11.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditApp_Private.h"

@interface PIRedditAppTests : XCTestCase

@end

@implementation PIRedditAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUserAgentInvariant {
    NSString *s = @"userAgent";
    PIRedditApp *app = [PIRedditApp new];
    app.userAgent = @"userAgent";
    XCTAssertEqualObjects(s, app.userAgent);
}

- (void)testRedirectURIInvariant {
    NSString *s = @"redirectURI";
    PIRedditApp *app = [PIRedditApp new];
    app.redirectURI = @"redirectURI";
    XCTAssertEqualObjects(s, app.redirectURI);
}

- (void)testClientNameInvariant {
    NSString *s = @"clientName";
    PIRedditApp *app = [PIRedditApp new];
    app.clientName = @"clientName";
    XCTAssertEqualObjects(s, app.clientName);
}

- (void)testAccessTokenInvariant {
    NSString *s = @"accessToken";
    PIRedditApp *app = [PIRedditApp new];
    app.accessToken = @"accessToken";
    XCTAssertEqualObjects(s, app.accessToken);
}

- (void)testRefreshTokenInvariant {
    NSString *s = @"refreshToken";
    PIRedditApp *app = [PIRedditApp new];
    app.refreshToken = @"refreshToken";
    XCTAssertEqualObjects(s, app.refreshToken);
}

- (void)testConstructorsAndEquality {
    PIRedditApp *app1 = [[PIRedditApp alloc] initWithUserAgent:@"userAgent" redirectURI:@"redirectURI" clientName:@"clientName"];
    XCTAssertFalse(app1.authorized);
    PIRedditApp *app2 = app1;
    XCTAssertTrue([app1 isEqual:app2]);
    app2 = [PIRedditApp appWithUserAgent:@"userAgent" redirectURI:@"redirectURI" clientName:@"clientName"];
    XCTAssertEqualObjects(app1, app2);
    
    app1 = [[PIRedditApp alloc] initWithUserAgent:@"userAgent1" redirectURI:@"redirectURI" clientName:@"clientName"];
    app2 = [PIRedditApp appWithUserAgent:@"userAgent2" redirectURI:@"redirectURI" clientName:@"clientName"];
    XCTAssertNotEqualObjects(app1, app2);
    
    XCTAssertNotEqualObjects(app1, @"userAgent1redirectURIclientName");
}

@end
