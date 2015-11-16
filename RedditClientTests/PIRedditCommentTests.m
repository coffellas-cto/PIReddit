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
        switch (i) {
            case 0:
            {
                XCTAssertEqualObjects(comment.ID, @"cqqxomy");
                XCTAssertEqualObjects(comment.fullName, @"t1_cqqxomy");
            }
                break;
                
            default:
                break;
        }
    }
}

@end
