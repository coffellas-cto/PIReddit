//
//  PIRedditSerializationStrategy.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PIRedditSerializationStrategyType) {
    PIRedditSerializationStrategyJSON,
    PIRedditSerializationStrategyPlainText,
    PIRedditSerializationStrategyNone
};

/**
 Class used to convert (serialize) raw input data represented by `NSData` object into one of the foundation basic objects.
 */
@interface PIRedditSerializationStrategy : NSObject

/**
 Strategy used to serialize data.
 */
@property (assign, readwrite, nonatomic) PIRedditSerializationStrategyType strategyType;

/**
 Encoding used to convert response data to string when using `PIRedditSerializationStrategyPlainText` value of `strategyType` property.
 Default is `NSUTF8StringEncoding`.
 */
@property (assign, readwrite, nonatomic) NSStringEncoding plainTextEncoding;

/**
 Serializes `NSData` object into other foundation objects according to one of the strategies of `PIRedditSerializationStrategyType` type.
 @param data Input data object to serialize.
 @param error If an error occurs, upon return contains an NSError object that describes the problem.
 @return A newly deserialized object or `nil` if error has occured.
 */
- (id)serializeData:(NSData *)data error:(NSError **)error;

/**
 Initializes and returns a newly allocated serialization strategy object with the specified strategy type.
 This is the designated initializer.
 @param strategyType One of the serialization strategy types.
 @return Newly allocated serialization strategy object.
 */
- (instancetype)initWithStrategyType:(PIRedditSerializationStrategyType)strategyType NS_DESIGNATED_INITIALIZER;

@end
