//
//  GuangfishGetSmsCodeAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishGetSmsCodeAPIManager.h"

NSString * const kGetSmsCodeAPIManagerParamsKeyMobile = @"mobile";

@implementation GuangfishGetSmsCodeAPIManager

- (NSString*)methodName {
    return API_GetSmsCodeUrl;
}

- (BOOL)useCode {
    return NO;
}

@end
