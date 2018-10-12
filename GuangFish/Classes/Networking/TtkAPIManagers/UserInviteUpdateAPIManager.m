//
//  UserInviteUpdateAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/12.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "UserInviteUpdateAPIManager.h"

NSString * const kUserInviteUpdateAPIManagerParamsKeyInviteCode = @"inviteCode";

@implementation UserInviteUpdateAPIManager

- (NSString*)methodName {
    return API_UserInviteUpdateUrl;
}

@end
