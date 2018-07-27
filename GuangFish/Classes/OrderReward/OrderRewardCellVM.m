//
//  OrderRewardCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderRewardCellVM.h"

@interface OrderRewardCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation OrderRewardCellVM

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
    self.commission = [self.dataDic objectForKey:@"commission"];
    self.orderReward = [self.dataDic objectForKey:@"orderReward"];
    self.orderRewardRate = [self.dataDic objectForKey:@"orderRewardRate"];
}

@end
