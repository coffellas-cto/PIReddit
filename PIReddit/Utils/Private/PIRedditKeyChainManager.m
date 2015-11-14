//
//  PIRedditKeyChainManager.m
//  RedditClient

#import "PIRedditKeyChainManager.h"

const NSStringEncoding kPIRedditKeyChainManagerEncoding = NSUTF8StringEncoding;

@implementation PIRedditKeyChainManager

+ (NSString *)stringForIdentifier:(NSString *)identifier {
    NSString *retVal;
    NSData *data = [self searchKeychainCopyMatching:identifier];
    if (data) {
        retVal = [[NSString alloc] initWithData:data encoding:kPIRedditKeyChainManagerEncoding];
    }
    
    return retVal.length ? retVal : nil;
}

+ (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [NSMutableDictionary new];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding: kPIRedditKeyChainManagerEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = NSStringFromClass(self.class);
    
    searchDictionary[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    searchDictionary[(__bridge id)kSecReturnData] = @YES;
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
}

+ (BOOL)deletePasswordForIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [NSMutableDictionary new];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:kPIRedditKeyChainManagerEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = NSStringFromClass(self.class);
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
    return status == errSecSuccess;
}

+ (BOOL)savePassword:(NSString *)password forIdentifier:(NSString *)identifier {
    [self deletePasswordForIdentifier:identifier];
    
    NSMutableDictionary *searchDictionary = [NSMutableDictionary new];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:kPIRedditKeyChainManagerEncoding];
    NSData *encodedPassword = [password dataUsingEncoding:kPIRedditKeyChainManagerEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = NSStringFromClass(self.class);
    searchDictionary[(__bridge id)kSecValueData] = encodedPassword;
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)searchDictionary, NULL);
    return status == errSecSuccess;
}

@end
