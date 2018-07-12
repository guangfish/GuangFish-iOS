//
//  TtkNetworkingManager.m
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/6/8.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import "GuangfishNetworkingManager.h"
#import "GuangfishAPIUrlConfigManager.h"
#import "GuangfishNetworking.h"

@implementation GuangfishNetworkingManager

NSString * const GuangfisNetworkingManagerNotificationSholdLoginAgain = @"GuangfisNetworkingManagerNotificationSholdLoginAgain";
static GuangfishNetworkingManager *sharedManager = nil;

+ (GuangfishNetworkingManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (BOOL)isLogin {
    if ([GuangfishNetworking sharedManager].userId == nil || [GuangfishNetworking sharedManager].userId.length == 0) {
        return NO;
    }
    return YES;
}

- (void)setApiUrlIsDev:(BOOL)isDev {
    [GuangfishAPIUrlConfigManager sharedManager].isDev = isDev;
}

- (void)logout {
    [self clearUserCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:GuangfisNetworkingManagerNotificationSholdLoginAgain object:nil];
}

- (NSString*)getUserCode {
    return [GuangfishNetworking sharedManager].userId;
}

#pragma mark - private methods

- (void)clearUserCode {
    [[GuangfishNetworking sharedManager] cleanUserId];
}

@end
