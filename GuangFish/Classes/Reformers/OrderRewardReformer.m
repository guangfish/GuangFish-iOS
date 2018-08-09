//
//  OrderRewardReformer.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderRewardReformer.h"

NSString * const kOrderRewardListDataKeyHaveMorePage = @"have_more";
NSString * const kOrderRewardListDataKeyPage = @"page";
NSString * const kOrderRewardListDataKeyOrderRewardCellVMList = @"OrderRewardCellVMList";

@implementation OrderRewardReformer

- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    NSDictionary *dic = [data objectForKey:@"data"];
    if ([manager isKindOfClass:[GuangfishOrderrewardlistAPIManager class]]) {
        NSNumber *page = dic[@"curPage"];
        NSNumber *ifHasNextPage = dic[@"hasNext"];
        NSMutableArray *orderRewardCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
        
        for (NSDictionary *itemDic in dic[@"items"]) {
            OrderRewardCellVM *orderRewardCellVM = [[OrderRewardCellVM alloc] initWithResponseDic:itemDic];
            if ([dic[@"items"] indexOfObject:itemDic] % 2 == 0) {
                orderRewardCellVM.bgColor = [UIColor colorWithRed:1.00 green:0.96 blue:0.98 alpha:1.00];
            } else {
                orderRewardCellVM.bgColor = [UIColor whiteColor];
            }
            [orderRewardCellVMList addObject:orderRewardCellVM];
        }
        
        resultData = @{
                       kOrderRewardListDataKeyHaveMorePage: ifHasNextPage,
                       kOrderRewardListDataKeyOrderRewardCellVMList: orderRewardCellVMList,
                       kOrderRewardListDataKeyPage: page
                       };
    }
    
    return resultData;
}

@end
