//
//  PIRedditKeyChainManager.m
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

#import "PIRedditKeyChainManager.h"

@implementation PIRedditKeyChainManager

+ (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [NSMutableDictionary new];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding: NSUTF8StringEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = NSStringFromClass(self.class);
    
    searchDictionary[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    searchDictionary[(__bridge id)kSecReturnPersistentRef] = @YES;
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
}

+ (BOOL)deletePasswordForIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [NSMutableDictionary new];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
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
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodedPassword = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = NSStringFromClass(self.class);
    searchDictionary[(__bridge id)kSecValueData] = encodedPassword;
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)searchDictionary, NULL);
    return status == errSecSuccess;
}

@end
