//
//  TtkAPIUrlConfigManager.m
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#define API_URL_DEV @"https://sou.guangfish.com"
#define API_URL @"https://sou.guangfish.com"

#import "GuangfishAPIUrlConfigManager.h"

@implementation GuangfishAPIUrlConfigManager

static GuangfishAPIUrlConfigManager *sharedManager = nil;

+ (GuangfishAPIUrlConfigManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
        sharedManager.isDev = NO;
    });
    return sharedManager;
}

- (NSString*)apiUrl {
    if (self.isDev) {
        return API_URL_DEV;
    } else {
        return API_URL;
    }
}

@end
