//
//  GuangfishFriendlistAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishFriendlistAPIManager.h"

NSString * const kFriendlistAPIManagerParamsKeyStatus = @"status";
NSString * const kFriendlistAPIManagerParamsKeyPageNo = @"pageNo";
NSString * const kFriendlistAPIManagerParamsKeySize = @"size";

@implementation GuangfishFriendlistAPIManager

- (NSString*)methodName {
    return API_FriendlistUrl;
}

@end
