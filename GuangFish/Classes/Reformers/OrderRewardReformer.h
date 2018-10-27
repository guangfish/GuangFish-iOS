//
//  OrderRewardReformer.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishFriendlistAPIManager.h"
#import "OrderRewardCellVM.h"

extern NSString * const kOrderRewardListDataKeyHaveMorePage;
extern NSString * const kOrderRewardListDataKeyPage;
extern NSString * const kOrderRewardListDataKeyOrderRewardCellVMList;

@interface OrderRewardReformer : NSObject<GuangfishAPIManagerDataReformer>

@end
