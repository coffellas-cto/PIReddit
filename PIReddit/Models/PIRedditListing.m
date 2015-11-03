//
//  PIRedditListing.m
//  RedditClient
//
//  Created by Alex G on 03.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRedditListing.h"
#import "PIRedditCommon.h"
#import "PIRedditKind.h"

@implementation PIRedditListing

+ (NSArray *)emptyArray {
    static NSArray *emptyArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emptyArray = [NSArray new];
    });
    
    return emptyArray;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        BOOL valid;
        if ([GDDynamicCast(dictionary[@"kind"], NSString) isEqualToString:@"Listing"]) {
            NSDictionary *dataDictionary = GDDynamicCast(dictionary[@"data"], NSDictionary);
            if (dataDictionary) {
                _beforeID = GDDynamicCast(dataDictionary[@"before"], NSString);
                _afterID = GDDynamicCast(dataDictionary[@"after"], NSString);
                if (_beforeID || _afterID) {
                    valid = YES;
                    NSArray *children = dataDictionary[@"children"];
                    if (children) {
                        if ([children isKindOfClass:[NSArray class]]) {
                            if (children.count == 0) {
                                _children = [[self class] emptyArray];
                            } else {
                                NSMutableArray *mutableKindChildren = [NSMutableArray arrayWithCapacity:children.count];
                                for (id child in children) {
                                    NSDictionary *childDic = GDDynamicCast(child, NSDictionary);
                                    if (childDic) {
                                        PIRedditKind *kindChild = [[PIRedditKind alloc] initWithDictionary:childDic];
                                        if (kindChild) {
                                            [mutableKindChildren addObject:kindChild];
                                        }
                                    }
                                }
                                _children = [mutableKindChildren copy];
                            }
                        } else {
                            valid = NO;
                        }
                    } else {
                        _children = [[self class] emptyArray];
                    }
                }
            }
        }
        
        if (!valid) {
            return nil;
        }
    }
    return self;
}

@end
