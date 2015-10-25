//
//  PIRedditSerializationStrategy.m
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRedditSerializationStrategy.h"

@implementation PIRedditSerializationStrategy

#pragma mark - Public Methods

- (id)serializeData:(NSData *)data error:(NSError *__autoreleasing *)error {
    id retVal = nil;
    switch (self.strategyType) {
        case PIRedditSerializationStrategyJSON:
            retVal = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
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
