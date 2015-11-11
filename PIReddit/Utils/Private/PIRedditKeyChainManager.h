//
//  PIRedditKeyChainManager.h
//  RedditClient

#import <Foundation/Foundation.h>

@interface PIRedditKeyChainManager : NSObject

+ (NSData *)searchKeychainCopyMatching:(NSString *)identifier;
+ (BOOL)deletePasswordForIdentifier:(NSString *)identifier;
+ (BOOL)savePassword:(NSString *)password forIdentifier:(NSString *)identifier;

@end
