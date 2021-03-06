//
//  GuangfishRegisterAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishRegisterAPIManager.h"

NSString * const kRegisterAPIManagerParamsKeyApp = @"app";
NSString * const kRegisterAPIManagerParamsKeySex = @"sex";
NSString * const kRegisterAPIManagerParamsKeyInviteCode = @"inviteCode";
NSString * const kRegisterAPIManagerParamsKeyCode = @"code";
NSString * const kRegisterAPIManagerParamsKeyMobile = @"mobile";
NSString * const kRegisterAPIManagerParamsKeyAlipay = @"alipay";
NSString * const kRegisterAPIManagerParamsKeyWeixin = @"weixin";

@implementation GuangfishRegisterAPIManager

- (NSString*)methodName {
    return API_RegisterUrl;
}

@end
