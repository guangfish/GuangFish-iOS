//
//  TtkAPIBaseManager.m
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import "GuangfishAPIBaseManager.h"

@interface GuangfishAPIBaseManager()

@property (nonatomic, strong) GuangfishNetworking *tuituikeNetwork;
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, strong, readwrite) NSError *managerError;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation GuangfishAPIBaseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _paramSource = nil;
        _fetchedRawData = nil;
        
        if ([self conformsToProtocol:@protocol(GuangfishAPIManager)]) {
            self.child = (id<GuangfishAPIManager>)self;
            self.tuituikeNetwork = [GuangfishNetworking sharedManager];
        } else {
            // 不遵守这个protocol的就让他crash，防止派生类乱来。
            NSAssert(NO, @"子类必须要实现APIManager这个protocol。");
        }
    }
    return self;
}

#pragma mark - public methods

- (id)fetchDataWithReformer:(id<GuangfishAPIManagerDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        if ([self.fetchedRawData isKindOfClass:[NSNumber class]]) {
            resultData = [self.fetchedRawData copy];
        } else {
            resultData = [self.fetchedRawData mutableCopy];
        }
    }
    return resultData;
}

- (void)cancelApiRequest {
    if (self.task != nil) {
        [self.task cancel];
    }
}

#pragma mark - calling api

- (void)loadData {
    NSDictionary *params = [self.paramSource paramsForApi:self];
    
    if (![self.child respondsToSelector:@selector(requestType)]) {
        [self loadDataWithParams:params];
    } else {
        switch (self.child.requestType) {
            case GuangfishAPIManagerRequestTypeGet:
                
                break;
            case GuangfishAPIManagerRequestTypePost:
                [self loadDataWithParams:params];
                break;
            default:
                break;
        }
    }
}

- (void)loadDataWithParams:(NSDictionary *)params {
    if ([self.child respondsToSelector:@selector(cancelOldRequestBeforeNewRequest)]) {
        if (self.child.cancelOldRequestBeforeNewRequest) {
            [self cancelApiRequest];    //在发起新请求时先取消之前的请求
        }
    } else {
        [self cancelApiRequest];
    }
    
    NSMutableDictionary *apiParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    if ([self.child respondsToSelector:@selector(reformParams:)]) {
        [self.child reformParams:apiParams];
    }
    
    BOOL useUserId = YES;
    if ([self.child respondsToSelector:@selector(useUserId)]) {
        useUserId = self.child.useUserId;
    }
    
    __weak __typeof(self) weakself = self;
    self.task = [self.tuituikeNetwork sendPostRequestWithApiName:[self.child methodName] useUserId:useUserId withParameters:apiParams withPostSuccessBlock:^(id responseObject) {
        __strong __typeof(self) strongself = weakself;
        if ([strongself.child respondsToSelector:@selector(afterPerformSuccessWithResponse:)]) {
            [strongself.child afterPerformSuccessWithResponse:responseObject];
        }
        
        strongself.fetchedRawData = [responseObject copy];
        [strongself.delegate managerCallAPIDidSuccess:strongself];
    } withPostErrorBlock:^(GuangfishNetworkingErrorType errorType, NSString *errorMsg) {
        __strong __typeof(self) strongself = weakself;
        strongself.managerError = [NSError errorWithDomain:errorMsg code:errorType userInfo:nil];
        [strongself.delegate managerCallAPIDidFailed:strongself];
    }];
}

#pragma mark - method for child

@end
