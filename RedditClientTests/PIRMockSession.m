//
//  PIRMockSession.m
//  RedditClient
//
//  Created by Alex G on 26.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "PIRMockSession.h"

@interface PIRMockSessionDataTask : NSURLSessionDataTask {
    NSURLRequest *_request;
    void (^_completionHandler)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);
    NSURLSessionTaskState _state;
}

@end

@implementation PIRMockSessionDataTask

- (NSDictionary *)paramsFromString:(NSString *)paramsString {
    NSArray *paramPairs = [paramsString componentsSeparatedByString:@"&"];
    NSMutableDictionary *retVal = [NSMutableDictionary dictionaryWithCapacity:paramPairs.count];
    for (NSString *string in paramPairs) {
        NSArray *pair = [string componentsSeparatedByString:@"="];
        if (pair.count == 2) {
            id key = [pair[0] stringByRemovingPercentEncoding];
            id value = [pair[1] stringByRemovingPercentEncoding];
            if (key && value) {
                retVal[key] = value;
            }
        }
    }
    
    return [retVal copy];
}

- (NSURLSessionTaskState)state {
    return _state;
}

- (void)resume {
    dispatch_async(dispatch_queue_create("mocktaskqueue", DISPATCH_QUEUE_CONCURRENT), ^{
        NSMutableDictionary *responseObject = [NSMutableDictionary new];
        
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:_request.URL resolvingAgainstBaseURL:NO];
        NSError *error = [NSError errorWithDomain:@"dummy" code:-1000 userInfo:nil];
        if ([components.host isEqualToString:@"reddit.mock"]) {
            NSDictionary *paramsDic = [self paramsFromString:_request.HTTPBody ? [[NSString alloc] initWithData:_request.HTTPBody encoding:NSUTF8StringEncoding] : components.query];
            
            if ([components.path isEqualToString:@"/mockapi/v1/me"]) {
                if ([_request.HTTPMethod isEqualToString:@"GET"]) {
                    error = nil;
                    responseObject[@"mock"] = @"duck";
                    if ([paramsDic[@"showMockDummyResponse"] boolValue]) {
                        responseObject[@"mockDummyResponse"] = @(100);
                    } else {
                        responseObject[@"newResponse"] = @(11.111);
                    }
                }
            } else if ([components.path isEqualToString:@"/mockapi/v1/dummy"]) {
                if ([_request.HTTPMethod isEqualToString:@"POST"]) {
                    if (paramsDic[@"name"]) {
                        responseObject[@"name"] = paramsDic[@"name"];
                        error = nil;
                    }
                }
            } else if ([components.path isEqualToString:@"/mockapi/v1/echo"]) {
                if ([_request.HTTPMethod isEqualToString:@"POST"]) {
                    if ([paramsDic isKindOfClass:[NSDictionary class]]) {
                        [responseObject addEntriesFromDictionary:paramsDic];
                        error = nil;
                    }
                }
            }
        }
        
        NSData *data = nil;
        if (responseObject.count) {
            data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:&error];
        }
        _completionHandler(data, nil, error);
    });
    _state = NSURLSessionTaskStateCompleted;
}

- (instancetype)initWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    self = [super init];
    if (self) {
        _request = request;
        _completionHandler = completionHandler;
        _state = NSURLSessionTaskStateSuspended;
    }
    return self;
}

@end

@implementation PIRMockSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    PIRMockSessionDataTask *dataTask = [[PIRMockSessionDataTask alloc] initWithRequest:request completionHandler:completionHandler];
    return dataTask;
}

@end
