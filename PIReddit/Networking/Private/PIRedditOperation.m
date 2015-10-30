//
//  PIRedditOperation.m
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

#import "PIRedditOperation.h"
#import "PIRedditCommon.h"
#import "PIRedditSerializationStrategy.h"

@interface PIRedditOperation ()

@property NSURLSessionDataTask *task;
@property NSURLSession *session;

@end

@implementation PIRedditOperation

@synthesize completion =_completion, serializationStrategy = _serializationStrategy;

#pragma mark - Accessors

- (void)setCompletion:(void (^)(NSHTTPURLResponse *response, NSError *error, id responseObject))completion {
    @synchronized(self) {
        if ([self isExecuting]) {
            return;
        }
        
        _completion = [completion copy];
    }
}

- (void (^)(NSHTTPURLResponse *, NSError *, id))completion {
    @synchronized(self) {
        return _completion;
    }
}

- (PIRedditSerializationStrategy *)serializationStrategy {
    @synchronized(self) {
        if (!_serializationStrategy) {
            _serializationStrategy = [[PIRedditSerializationStrategy alloc] initWithStrategyType:PIRedditSerializationStrategyJSON];
        }
    }
    
    return _serializationStrategy;
}

- (void)setSerializationStrategy:(PIRedditSerializationStrategy *)serializationStrategy {
    @synchronized(self) {
        _serializationStrategy = serializationStrategy;
    }
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
        
        // TODO: serialize not on main queue
        dispatch_group_async(group, dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *HTTPResponse = GDDynamicCast(response, NSHTTPURLResponse);
            id responseObject = nil;
            NSError *completionError = error;
            if (!completionError && data) {
                NSError *serializationError = nil;
                responseObject = [self.serializationStrategy serializeData:data error:&serializationError];
                if (serializationError) {
                    completionError = serializationError;
                }
            }
            self.completion(HTTPResponse, completionError, responseObject);
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
            [self callCompletionWithResponse:nil error:[NSError errorWithDomain:PIRedditErrorDomain code:NSURLErrorCancelled userInfo:@{NSLocalizedDescriptionKey: @"Cancelled by user"}] data:nil];
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

+ (PIRedditOperation *)operationWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session completion:(void (^)(NSHTTPURLResponse *response, NSError *error, id responseObject))completion {
    PIRedditOperation *retVal = [[self alloc] initWithRequest:urlRequest session:session];
    retVal.completion = completion;
    return retVal;
}

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest session:(NSURLSession *)session {
    self = [super init];
    if (self) {
        _request = urlRequest;
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
