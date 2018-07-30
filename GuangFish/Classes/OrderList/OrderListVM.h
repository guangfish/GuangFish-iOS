//
//  OrderListVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

typedef enum {
    OrderTypeJS = 1,
    OrderTypeFK,
    OrderTypeSX
} OrderType;

@interface OrderListVM : GLViewModel

@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, strong) RACSubject *requestGetOrderListSignal;
@property (nonatomic, strong) NSMutableArray *orderCellVMList;
@property (nonatomic, strong) NSNumber *haveMore;

- (void)reloadOrderList;
- (void)loadNextPageOrderList;

@end
