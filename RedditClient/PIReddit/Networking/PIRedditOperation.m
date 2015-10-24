//
//  PIRedditOperation.m
//  RedditClient
//
//  Created by Alex G on 23.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRedditOperation.h"
#import "PIRedditCommon.h"

@interface PIRedditOperation ()

@property NSURLSessionDataTask *task;
@property NSURLSession *session;

@end

@implementation PIRedditOperation

#pragma mark - Accessors

- (void)setCompletion:(void (^)(NSHTTPURLResponse *response, NSError *error, NSData *responseData))completion {
    if ([self isExecuting]) {
        return;
    }
    
    _completion = [completion copy];
}

#pragma mark - 

- (void)callCompletionWithResponse:(NSURLResponse *)response error:(NSError *)error data:(NSData *)data {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    
    if (self.completion) {
        static dispatch_group_t group = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            group = dispatch_group_create();
        });
        
        dispatch_group_async(group, dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *HTTPResponse = GDDynamicCast(response, NSHTTPURLResponse);
            self.completion(HTTPResponse, error, data);
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            self.completion = nil;
            [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
            [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
        });
    } else if (!self.cancelled) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
        [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    }
}

#pragma mark - Overrides

- (void)start {
    @synchronized(self) {
        if ([self isCancelled]) {
            [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
            [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
            [self callCompletionWithResponse:nil error:[NSError errorWithDomain:@"com.pireddit" code:NSURLErrorCancelled userInfo:@{NSLocalizedDescriptionKey: @"Cancelled by user"}] data:nil];
            return;
        }
        
        __weak typeof (self) weakSelf = self;
        self.task = [self.session dataTaskWithRequest:self.request
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                     {
                         __strong typeof (weakSelf) strongSelf = weakSelf;
                         [strongSelf callCompletionWithResponse:response error:error data:data];
                     }];
        [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
        [self.task resume];
        [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    }
}

- (void)cancel {
    @synchronized(self) {
        [super cancel];
        [self.task cancel];
    }
}

- (BOOL)isFinished {
    return [self isCancelled] || self.task.state == NSURLSessionTaskStateCompleted;
}

- (BOOL)isExecuting {
    BOOL retVal = NO;
    @synchronized(self) {
        if (self.task) {
            NSURLSessionTaskState state = self.task.state;
            switch (state) {
                case NSURLSessionTaskStateRunning:
                case NSURLSessionTaskStateCanceling:
                    retVal = YES;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return retVal;
}

- (BOOL)isAsynchronous {
    return YES;
}

#pragma mark - Life Cycle

+ (PIRedditOperation *)operationWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session completion:(void (^)(NSHTTPURLResponse *response, NSError *error, NSData *responseData))completion {
    PIRedditOperation *retVal = [[self alloc] initWithRequest:urlRequest session:session];
    retVal.completion = completion;
    return retVal;
}

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session {
    self = [super init];
    if (self) {
        _request = [[NSURLRequest alloc] initWithURL:urlRequest.URL cachePolicy:urlRequest.cachePolicy timeoutInterval:urlRequest.timeoutInterval];
        _session = session;
    }
    return self;
}

- (instancetype)init {
    return [self initWithRequest:nil session:nil];
}

- (void)dealloc {
    XLog(@"");
}

@end
