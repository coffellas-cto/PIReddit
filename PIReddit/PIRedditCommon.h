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


#ifndef XLog
// Debug-only logging
#ifdef DEBUG
#define XLog(format, ...) NSLog((@"%s[%d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define XLog(...)
#endif
#endif

#endif /* PIRedditCommon_h */
