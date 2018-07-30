//
//  OrderListReformer.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishOrderlistAPIManager.h"
#import "OrderCellVM.h"

extern NSString * const kOrderListDataKeyHaveMorePage;
extern NSString * const kOrderListDataKeyPage;
extern NSString * const kOrderListDataKeyOrderListCellVMList;

@interface OrderListReformer : NSObject<GuangfishAPIManagerDataReformer>

@end
