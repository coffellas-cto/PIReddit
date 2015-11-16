//
//  PIRedditComment.m
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

#import "PIRedditComment.h"
#import "PIRedditListing.h"

NSString * const kPIRedditKindValueComment = @"t1";

@implementation PIRedditComment

@synthesize body = _body, author = _author, linkFullName = _linkFullName, replies = _replies, createdUTC = _createdUTC;

- (NSString *)author {
    return [_author ?: (_author = GDDynamicCast(self.allFields[@"author"], NSString)) copy];
}

- (NSString *)linkFullName {
    return [_linkFullName ?: (_linkFullName = GDDynamicCast(self.allFields[@"link_id"], NSString)) copy];
}

- (NSString *)body {
    return [_body ?: (_body = GDDynamicCast(self.allFields[@"body"], NSString)) copy];
}

- (NSDate *)createdUTC {
    if (!_createdUTC) {
        NSTimeInterval createdTimeinterval = [GDDynamicCast(self.allFields[@"created_utc"], NSNumber) doubleValue];
        if (createdTimeinterval) {
            _createdUTC = [NSDate dateWithTimeIntervalSince1970:createdTimeinterval];
        }
    }
    
    return _createdUTC;
}

- (PIRedditListing *)replies {
    return _replies ?: (_replies = [[PIRedditListing alloc] initWithDictionary:self.allFields[@"replies"]]);
}

- (NSString *)kind {
    return kPIRedditKindValueComment;
}

@end
