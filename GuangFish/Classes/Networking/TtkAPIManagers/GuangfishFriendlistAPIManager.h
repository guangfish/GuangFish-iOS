//
//  GuangfishFriendlistAPIManager.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishAPIBaseManager.h"

extern NSString * const kFriendlistAPIManagerParamsKeyStatus;                  //1:未激活 2：已激活未领取 3：已激活已领取
extern NSString * const kFriendlistAPIManagerParamsKeyPageNo;
extern NSString * const kFriendlistAPIManagerParamsKeySize;

@interface GuangfishFriendlistAPIManager : GuangfishAPIBaseManager<GuangfishAPIManager>

@end
