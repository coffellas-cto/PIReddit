//
//  PIRedditLink.m
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

#import "PIRedditLink.h"
#import "PIRedditCommon.h"

NSString * const kPIRedditKindValueLink = @"t3";

@implementation PIRedditLink

- (NSString *)kind {
    return kPIRedditKindValueLink;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        _subreddit = GDDynamicCast(dictionary[@"subreddit"], NSString);
        _text = GDDynamicCast(dictionary[@"selftext"], NSString);
        _author = GDDynamicCast(dictionary[@"author"], NSString);
        _subredditID = GDDynamicCast(dictionary[@"subreddit_id"], NSString);
        _permalink = GDDynamicCast(dictionary[@"permalink"], NSString);
        _url = GDDynamicCast(dictionary[@"url"], NSString);
        _title = GDDynamicCast(dictionary[@"title"], NSString);
        NSTimeInterval createdTimeinterval = [GDDynamicCast(dictionary[@"created_utc"], NSNumber) doubleValue];
        if (createdTimeinterval) {
            _createdUTC = [NSDate dateWithTimeIntervalSince1970:createdTimeinterval];
        }
    }
    
    return self;
}

@end
