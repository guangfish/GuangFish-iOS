//
//  TtkLoginAPIManager.m
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import "GuangfishLoginAPIManager.h"

NSString * const kLoginAPIManagerParamsKeyApp = @"app";
NSString * const kLoginAPIManagerParamsKeyMobile = @"mobile";
NSString * const kLoginAPIManagerParamsKeyCode = @"code";

@implementation GuangfishLoginAPIManager

- (NSString*)methodName {
    return API_LoginUrl;
}

- (BOOL)useCode {
    return NO;
}

@end
