//
//  PIRedditListingTests.m
//  RedditClient
//
//  Created by Alex G on 03.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditListing.h"
#import "PIRedditLink.h"

@interface PIRedditListingTests : XCTestCase

@end

@implementation PIRedditListingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreation {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"listing_test_001" ofType:@"json"];
    NSData *listingData = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:listingData options:0 error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(dictionary);
    PIRedditListing *listing = [[PIRedditListing alloc] initWithDictionary:dictionary];
    XCTAssertNotNil(listing);
    XCTAssertNil(listing.beforeID);
    XCTAssertNotNil(listing.afterID);
    XCTAssertEqual(listing.children.count, 2);
    XCTAssertTrue([listing.children[0] isKindOfClass:[PIRedditLink class]]);
    XCTAssertTrue([listing.children[1] isKindOfClass:[PIRedditLink class]]);
}

@end
