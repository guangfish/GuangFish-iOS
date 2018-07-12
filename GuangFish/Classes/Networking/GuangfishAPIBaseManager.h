//
//  TtkAPIBaseManager.h
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishNetworking.h"

@class GuangfishAPIBaseManager;

#pragma mark - api回调
@protocol GuangfishAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager;
@end

#pragma mark - GuangfishAPIManagerParamSourceDelegate
//让manager能够获取调用API所需要的数据
@protocol GuangfishAPIManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(GuangfishAPIBaseManager *)manager;
@end

typedef NS_ENUM (NSUInteger, GuangfishAPIManagerRequestType){
    GuangfishAPIManagerRequestTypeGet,                         //GET方式调用
    GuangfishAPIManagerRequestTypePost,                        //POST方式调用
};

#pragma mark - GuangfishAPIManagerDataReformer
@protocol GuangfishAPIManagerDataReformer <NSObject>
@required
- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data;
@end

#pragma mark - CTAPIManager
@protocol GuangfishAPIManager <NSObject>

@required

/**
 接口名称

 @return 接口名称
 */
- (NSString *)methodName;

@optional

//在调用api之前，可以往调用参数里面添加参数，如分页参数
- (void)reformParams:(NSMutableDictionary *)params;

- (void)afterPerformSuccessWithResponse:(id)response;


/**
 设置接口调用方式，如果子类不写该方法，默认使用TtkAPIManagerRequestTypePost方式调用

 @return 该接口要使用接口调用方式
 */
- (GuangfishAPIManagerRequestType)requestType;

/**
 接口是否需要使用userId，如果子类不写该方法，默认使用userId

 @return yes:使用userId，no:不使用userId
 */
- (BOOL)useUserId;

/**
 当再次发起请求之前先取消之前的请求，如果子类不写该方法，默认是会取消之前的请求

 @return YES:取消之前的请求;NO:不取消之前的请求
 */
- (BOOL)cancelOldRequestBeforeNewRequest;

@end

@interface GuangfishAPIBaseManager : NSObject

@property (nonatomic, weak) id<GuangfishAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<GuangfishAPIManagerParamSource> paramSource;
@property (nonatomic, weak) NSObject<GuangfishAPIManager> *child;
@property (nonatomic, strong, readonly) NSError *managerError;


/**
 发起网络请求
 */
- (void)loadData;

- (id)fetchDataWithReformer:(id<GuangfishAPIManagerDataReformer>)reformer;

/**
 取消该接口请求
 */
- (void)cancelApiRequest;

@end
