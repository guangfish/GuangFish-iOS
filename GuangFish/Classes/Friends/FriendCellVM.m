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
}

@end
