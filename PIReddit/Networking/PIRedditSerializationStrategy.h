//
//  PIRedditSerializationStrategy.h
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PIRedditSerializationStrategyType) {
    PIRedditSerializationStrategyJSON,
    PIRedditSerializationStrategyPlainText,
    PIRedditSerializationStrategyNone
};

/**
 Class used to convert (serialize) input raw data represented by `NSData` objects into one of the foundation basic objects.
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
