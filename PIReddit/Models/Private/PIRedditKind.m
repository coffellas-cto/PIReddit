//
//  PIRedditKind.m
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

#import "PIRedditKind.h"
#import "PIRedditCommon.h"
#import "PIRedditLink.h"
#import "PIRedditComment.h"

@implementation PIRedditKind
@synthesize ID = _ID;

// TODO: When all kind subclasses are gathered check their common fields.

- (NSString *)fullName {
    return self.ID ? [NSString stringWithFormat:@"%@_%@", self.kind, self.ID] : nil;
}

- (NSString *)ID {
    return _ID ?: (_ID = GDDynamicCast(self.allFields[@"id"], NSString));
}

+ (Class)classForKind:(NSString *)kind {
    if ([kind isEqualToString:kPIRedditKindValueComment]) {
        return [PIRedditComment class];
    }
    
    if ([kind isEqualToString:kPIRedditKindValueLink]) {
        return [PIRedditLink class];
    }
    
    // TODO: Implement.
    return [self class];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (dictionary.count == 0) {
        return nil;
    }
    
    self = [super initWithDictionary:dictionary];
    if (self) {
        _allFields = dictionary;
    }
    
    return self;
}

+ (instancetype)redditKindWithDictionary:(NSDictionary *)dictionary {
    NSString *kind = GDDynamicCast(dictionary[@"kind"], NSString);
    if (kind) {
        Class class = [[self class] classForKind:kind];
        if (class && class != [self class]) {
            return [[class alloc] initWithDictionary:dictionary[@"data"]];
        }
    }
    
    return nil;
}

- (NSString *)description {
    return [self.allFields description];
}

@end
