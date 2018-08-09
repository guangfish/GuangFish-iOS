//
//  FriendCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface FriendCellVM : GLViewModel

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *inviteTime;
@property (nonatomic, strong) NSString *rewardMoney;
@property (nonatomic, strong) NSString *ifreward;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) UIColor *statusColor;
@property (nonatomic, strong) UIColor *ifrewardColor;

- (id)initWithResponseDic:(NSDictionary*)dic;

@end
