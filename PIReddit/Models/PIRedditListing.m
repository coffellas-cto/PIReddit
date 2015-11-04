//
//  PIRedditListing.m
//  RedditClient

/*
 The MIT License (MIT)
 
 Copyright © 2015 Alexey Gordiyenko. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

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
                                        PIRedditKind *kindChild = [PIRedditKind redditKindWithDictionary:childDic];
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
