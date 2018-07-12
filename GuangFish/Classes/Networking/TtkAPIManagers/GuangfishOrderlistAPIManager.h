//
//  GuangfishOrderlistAPIManager.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishAPIBaseManager.h"

extern NSString * const kOrderlistAPIManagerParamsKeyOrderStatus;           //1:订单结算 2：订单付款 3：订单失效
extern NSString * const kOrderlistAPIManagerParamsKeyPageNo;
extern NSString * const kOrderlistAPIManagerParamsKeySize;

@interface GuangfishOrderlistAPIManager : GuangfishAPIBaseManager<GuangfishAPIManager>

@end
