//
//  PIRedditCommentTests.m
//  RedditClient
//
//  Created by Alex G on 16.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditListing.h"
#import "PIRedditComment.h"
#import "XCTest+PIReddit.h"

@interface PIRedditCommentTests : XCTestCase

@end

@implementation PIRedditCommentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreationFromListing {
    NSDictionary *dic = [self loadJSONFromFile:@"listing_test_002" ofType:@"json"];
    PIRedditListing *listing = [[PIRedditListing alloc] initWithDictionary:dic];
    XCTAssertNotNil(listing);
    XCTAssertEqual(listing.children.count, 2);
    for (int i = 0; i < 2; i++) {
        PIRedditComment *comment = (PIRedditComment *)listing.children[i];
        XCTAssertTrue([comment isKindOfClass:[PIRedditComment class]]);
        XCTAssertEqualObjects(comment.kind, @"t1");
        XCTAssertEqualObjects(comment.linkFullName, @"t3_342rja");
        switch (i) {
            case 0:
            {
                XCTAssertEqualObjects(comment.ID, @"cqqxomy");
                XCTAssertEqualObjects(comment.fullName, @"t1_cqqxomy");
                XCTAssertEqualObjects(comment.author, @"_pigpen_");
                XCTAssertEqualObjects(comment.body, @"1066. One of William the Conqueror's attendant lords. What I find incredible is that my mother grew up within a few miles of the land granted to this nobleman by William. In other words her family had not moved in nearly a thousand years.");
                XCTAssertEqualObjects(comment.createdUTC, [NSDate dateWithTimeIntervalSince1970:1430183708.0]);
                XCTAssertNotNil(comment.replies);
            }
                break;
            case 1:
            {
                XCTAssertEqualObjects(comment.ID, @"cqr27fk");
                XCTAssertEqualObjects(comment.fullName, @"t1_cqr27fk");
                XCTAssertEqualObjects(comment.author, @"zaphodX");
                XCTAssertEqualObjects(comment.body, @"1465  \nAnd, we have been in the same house in my village in India for last 275 years (of course, house has been fixed up quite a few times to keep with times).  275 yrs ago, my ancestors moved from neighboring town 2km away to this current house. ");
                XCTAssertEqualObjects(comment.createdUTC, [NSDate dateWithTimeIntervalSince1970:1430190827.0]);
                XCTAssertNotNil(comment.replies);
            }
                break;
                
            default:
                break;
        }
    }
}

@end
