//
//  PIRedditSerializationStrategy.m
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

#import "PIRedditSerializationStrategy.h"
#import "PIRedditCommon.h"

@implementation PIRedditSerializationStrategy

#pragma mark - Public Methods

- (id)serializeData:(NSData *)data error:(NSError *__autoreleasing *)error {
    id retVal = nil;
    switch (self.strategyType) {
        case PIRedditSerializationStrategyJSON:
        {
            if (data) {
                NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                XLog(@"%@", JSONString);
            }
            retVal = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
        }
            break;
        case PIRedditSerializationStrategyPlainText:
            retVal = [[NSString alloc] initWithData:data encoding:self.plainTextEncoding];
            break;
            
        default:
            retVal = data;
            break;
    }
    return retVal;
}

#pragma mark - Life Cycle

- (instancetype)initWithStrategyType:(PIRedditSerializationStrategyType)strategyType {
    self = [super init];
    if (self) {
        _strategyType = strategyType;
        _plainTextEncoding = NSUTF8StringEncoding;
    }
    return self;
}

- (instancetype)init {
    return [self initWithStrategyType:PIRedditSerializationStrategyJSON];
}

@end
