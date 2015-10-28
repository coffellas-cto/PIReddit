//
//  PIRedditNetworking_Private.h
//  RedditClient
//
//  Created by Alex G on 28.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRedditNetworking.h"

@interface PIRedditNetworking ()

/**
 Initial access token to be inserted explicitly.
 */
@property (readwrite, copy, atomic) NSString *initialAccessToken;

@end
