//
//  GuangfishUserUpdateAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/8/7.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishUserUpdateAPIManager.h"

NSString * const kUserUpdateAPIManagerParamsKeyAlipay = @"alipay";
NSString * const kUserUpdateAPIManagerParamsKeyWeixin = @"weixin";

@implementation GuangfishUserUpdateAPIManager

- (NSString*)methodName {
    return API_UserUpdateUrl;
}

@end
