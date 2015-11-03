//
//  PIRedditModel.m
//  RedditClient
//
//  Created by Alex G on 03.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRedditModel.h"
#import "PIRedditCommon.h"

@implementation PIRedditModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    NSParameterAssert(dictionary);
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [super init];
}

- (instancetype)init {
    return [super init];
}

@end
