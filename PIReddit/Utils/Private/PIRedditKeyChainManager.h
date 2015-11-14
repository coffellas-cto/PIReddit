//
//  PIRedditKeyChainManager.h
//  RedditClient

#import <Foundation/Foundation.h>

@interface PIRedditKeyChainManager : NSObject

+ (NSString *)stringForIdentifier:(NSString *)identifier;
+ (NSData *)searchKeychainCopyMatching:(NSString *)identifier;
+ (BOOL)deletePasswordForIdentifier:(NSString *)identifier;
+ (BOOL)savePassword:(NSString *)password forIdentifier:(NSString *)identifier;

@end
