//
//  PIRedditListing.h
//  RedditClient
//
//  Created by Alex G on 03.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//


#import "PIRedditModel.h"

@class PIRedditKind;

/**
 Class that represents PIReddit listing.
 */
@interface PIRedditListing : PIRedditModel

/**
 ID of a listing before current.
 */
@property (readonly, copy, nonatomic) NSString *beforeID;

/**
 ID of a listing after current.
 */
@property (readonly, copy, nonatomic) NSString *afterID;

/**
 Array containing children of generic type. Returns empty array if no children are present.
 */
@property (readonly, strong, nonatomic) NSArray<PIRedditKind *> *children;

@end
