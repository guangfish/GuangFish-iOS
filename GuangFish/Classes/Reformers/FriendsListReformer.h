//
//  FriendsListReformer.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishFriendlistAPIManager.h"
#import "FriendCellVM.h"

extern NSString * const kFriendsListDataKeyHaveMorePage;
extern NSString * const kFriendsListDataKeyPage;
extern NSString * const kFriendsListDataKeyFriendCellVMList;

@interface FriendsListReformer : NSObject<GuangfishAPIManagerDataReformer>

@end
