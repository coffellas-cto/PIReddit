//
//  PIRedditCommon.h
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#ifndef PIRedditCommon_h
#define PIRedditCommon_h

#import "PIRedditConstants.h"

#ifndef GDDynamicCast
// Dynamic casting. Use object only if it's of specified class.
#define GDDynamicCast(x, c) ((c *)([x isKindOfClass:[c class]] ? x : nil))
#endif

#endif /* PIRedditCommon_h */
