//
//  PIRedditModel.h
//  RedditClient
//
//  Created by Alex G on 03.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Base class for all PIReddit Models.
 */
@interface PIRedditModel : NSObject

/**
 Initializes and returns a new model object from provided dictionary.
 @param dictionary Dictionary to initialize an object with. Cannot be `nil`.
 @return A newly initialized model object or `nil` if malformed dictionary is provided.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
