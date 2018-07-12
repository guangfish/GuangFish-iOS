//
//  TuituikeNetworking.h
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishAPIUrlConfigManager.h"

typedef NS_ENUM (NSUInteger, GuangfishNetworkingErrorType){
    GuangfishNetworkingErrorTypeRequestFailed,               //接口返回错误
    GuangfishNetworkingErrorTypeNetFailed                    //网络问题引起的错误
};

typedef void (^NetworkingSuccessBlock) (id responseObject);
typedef void (^NetworkingErrorBlock) (GuangfishNetworkingErrorType errorType, NSString *errorMsg);

@interface GuangfishNetworking : NSObject

@property (nonatomic, strong) NSString *userId;                                       //用户id

+ (GuangfishNetworking*)sharedManager;


/**
 发起POST请求

 @param apiName 接口名称
 @param userUserId 是否使用UserId
 @param parameters 接口参数
 @param postSuccessBlock 接口调用成功的Block
 @param postErrorBlock 接口调用失败的Block
 @return 该POST请求的task
 */
- (NSURLSessionDataTask*)sendPostRequestWithApiName:(NSString*)apiName useUserId:(BOOL)userUserId withParameters:(NSDictionary*)parameters withPostSuccessBlock:(NetworkingSuccessBlock)postSuccessBlock withPostErrorBlock:(NetworkingErrorBlock)postErrorBlock;

- (void)cleanUserId;

@end
