//
//  PIRedditRESTController.m
//  RedditClient
//
//  Created by Alex G on 24.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRedditRESTController.h"
#import "PIRedditOperation.h"

@implementation PIRedditRESTController

@synthesize timeoutInterval = _timeoutInterval;

#pragma mark - Accessors

- (NSTimeInterval)timeoutInterval {
    NSTimeInterval retVal;
    @synchronized(self) {
        retVal = _timeoutInterval ?: 30.0;
    }
    
    return retVal;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    @synchronized(self) {
        _timeoutInterval = timeoutInterval;
    }
}

#pragma mark - Public Methods

- (NSOperation *)requestOperationWithMethod:(NSString *)HTTPMethod
                                     atPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 completion:(void (^)(NSError *error, id responseObject))completion
{
    NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
    PIRedditOperation *op = [PIRedditOperation operationWithRequest:[request copy] session:self.session completion:^(NSHTTPURLResponse *response, NSError *error, NSData *responseData) {
        if (completion) {
            id responseObject = nil;
            if (!error && responseData) {
                // TODO: todo
            }
            
            completion(error, responseObject);
        }
    }];
    
    return op;
}

- (instancetype)initWithSession:(NSURLSession *)session baseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _session = session;
        _baseURL = baseURL;
    }
    return self;
}

- (instancetype)init {
    return [self initWithSession:nil baseURL:nil];
}

@end
