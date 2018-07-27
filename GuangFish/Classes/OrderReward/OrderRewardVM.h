//
//  OrderRewardVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface OrderRewardVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestGetOrderRewardSignal;
@property (nonatomic, strong) NSMutableArray *orderRewardCellVMList;
@property (nonatomic, strong) NSNumber *haveMore;

- (void)reloadOrderRewardList;
- (void)loadNextPageOrderRewardList;

@end
