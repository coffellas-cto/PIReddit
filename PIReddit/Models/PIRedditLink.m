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

@synthesize subreddit = _subreddit, text = _text, author = _author, subredditID = _subredditID, permalink = _permalink, url = _url, title = _title, createdUTC = _createdUTC;

- (NSString *)subreddit {
    return _subreddit ?: (_subreddit = GDDynamicCast(self.allFields[@"subreddit"], NSString));
}

- (NSString *)text {
    return _text ?: (_text = GDDynamicCast(self.allFields[@"selftext"], NSString));
}

- (NSString *)author {
    return _author ?: (_author = GDDynamicCast(self.allFields[@"author"], NSString));
}

- (NSString *)subredditID {
    return _subredditID ?: (_subredditID = GDDynamicCast(self.allFields[@"subreddit_id"], NSString));
}

- (NSString *)permalink {
    return _permalink ?: (_permalink = GDDynamicCast(self.allFields[@"permalink"], NSString));
}

- (NSString *)url {
    return _url ?: (_url = GDDynamicCast(self.allFields[@"url"], NSString));
}

- (NSString *)title {
    return _title ?: (_title = GDDynamicCast(self.allFields[@"title"], NSString));
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

- (NSString *)kind {
    return kPIRedditKindValueLink;
}

@end
