//
//  PIRedditLink.h
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

/**
 Class which represents Reddit "link kind".
 */
@interface PIRedditLink : PIRedditKind

/**
 Subreddit the link belongs to.
 */
@property (readonly, copy, nonatomic) NSString *subreddit;
/**
 Link post's full text.
 */
@property (readonly, copy, nonatomic) NSString *text;
/**
 Link unique identifier.
 */
@property (readonly, copy, nonatomic) NSString *ID;
/**
 Link's author.
 */
@property (readonly, copy, nonatomic) NSString *author;
/**
 ID of a subreddit the link belongs to.
 */
@property (readonly, copy, nonatomic) NSString *subredditID;
/**
 Permalink of a link.
 */
@property (readonly, copy, nonatomic) NSString *permalink;
/**
 String that represents link's URL.
 */
@property (readonly, copy, nonatomic) NSString *url;
/**
 Links title.
 */
@property (readonly, copy, nonatomic) NSString *title;
/**
 A date the link was created in UTC.
 */
@property (readonly, copy, nonatomic) NSDate *createdUTC;

@end
