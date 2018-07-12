//
//  GuangfishRegisterAPIManager.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishAPIBaseManager.h"

extern NSString * const kRegisterAPIManagerParamsKeyInviteCode;                 //邀请码
extern NSString * const kRegisterAPIManagerParamsKeyCode;                       //短信验证码
extern NSString * const kRegisterAPIManagerParamsKeyInviteMobile;               //手机号
extern NSString * const kRegisterAPIManagerParamsKeyInviteAlipay;               //支付宝账号
extern NSString * const kRegisterAPIManagerParamsKeyInviteWeixin;               //微信账号

@interface GuangfishRegisterAPIManager : GuangfishAPIBaseManager<GuangfishAPIManager>

@end
