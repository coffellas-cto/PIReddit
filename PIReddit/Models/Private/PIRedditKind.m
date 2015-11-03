//
//  PIRedditKind.m
//  RedditClient
//
//  Created by Alex G on 03.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRedditKind.h"
#import "PIRedditCommon.h"
#import "PIRedditLink.h"

@implementation PIRedditKind

+ (Class)classForKind:(NSString *)kind {
    if ([kind isEqualToString:@"t3"]) {
        return [PIRedditLink class];
    }
    // TODO: Implement.
    return [self class];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (!self) {
        return nil;
    }
    
    NSString *kind = GDDynamicCast(dictionary[@"kind"], NSString);
    if (kind) {
        Class class = [[self class] classForKind:kind];
        if (class && class != [self class]) {
            return [[class alloc] initWithDictionary:dictionary[@"data"]];
        }
    }
    
    return nil;
}

@end
