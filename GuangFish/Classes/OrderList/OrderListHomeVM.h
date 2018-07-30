//
//  OrderListHomeVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "OrderListVM.h"

@interface OrderListHomeVM : GLViewModel

- (OrderListVM*)getJSOrderListVM;
- (OrderListVM*)getFKOrderListVM;
- (OrderListVM*)getSXOrderListVM;

@end
