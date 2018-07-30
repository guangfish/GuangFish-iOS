//
//  OrderListHomeVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderListHomeVM.h"

@implementation OrderListHomeVM

- (OrderListVM*)getJSOrderListVM {
    OrderListVM *orderListVM = [[OrderListVM alloc] init];
    orderListVM.orderType = OrderTypeJS;
    return orderListVM;
}

- (OrderListVM*)getFKOrderListVM {
    OrderListVM *orderListVM = [[OrderListVM alloc] init];
    orderListVM.orderType = OrderTypeFK;
    return orderListVM;
}

- (OrderListVM*)getSXOrderListVM {
    OrderListVM *orderListVM = [[OrderListVM alloc] init];
    orderListVM.orderType = OrderTypeSX;
    return orderListVM;
}

@end
