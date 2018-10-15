//
//  UserInviteUpdateAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/12.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GuangfishUserInviteUpdateAPIManager.h"

NSString * const kUserInviteUpdateAPIManagerParamsKeyInviteCode = @"inviteCode";

@implementation GuangfishUserInviteUpdateAPIManager

- (NSString*)methodName {
    return API_UserInviteUpdateUrl;
}

@end
