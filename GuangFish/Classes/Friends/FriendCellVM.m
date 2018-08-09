//
//  FriendCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendCellVM.h"

@interface FriendCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation FriendCellVM

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

#pragma mark - private methods

- (void)getData {
    self.mobile = [self.dataDic objectForKey:@"mobile"];
    self.inviteTime = [self.dataDic objectForKey:@"inviteTime"];
    self.rewardMoney = [self.dataDic objectForKey:@"rewardMoney"];
    self.ifreward = [self.dataDic objectForKey:@"ifreward"];
    self.status = [self.dataDic objectForKey:@"status"];
    if ([self.status isEqualToString:@"已激活"]) {
        self.statusColor = [UIColor colorWithRed:0.93 green:0.06 blue:0.32 alpha:1.00];
    } else {
        self.statusColor = [UIColor lightGrayColor];
    }
    if ([self.ifreward isEqualToString:@"已领取"]) {
        self.ifrewardColor = [UIColor colorWithRed:0.93 green:0.06 blue:0.32 alpha:1.00];
    } else {
        self.ifrewardColor = [UIColor lightGrayColor];
    }
}

@end
