//
//  OrderRewardCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface OrderRewardCellVM : GLViewModel

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *orderReward;
@property (nonatomic, strong) NSString *commission;
@property (nonatomic, strong) NSString *orderRewardRate;

- (id)initWithResponseDic:(NSDictionary*)dic;

@end
