//
//  OrderListReformer.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderListReformer.h"

NSString * const kOrderListDataKeyHaveMorePage = @"have_more";
NSString * const kOrderListDataKeyPage = @"page";
NSString * const kOrderListDataKeyOrderListCellVMList = @"OrderListCellVMList";

@implementation OrderListReformer

- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    NSDictionary *dic = [data objectForKey:@"data"];
    if ([manager isKindOfClass:[GuangfishOrderlistAPIManager class]]) {
        NSNumber *page = dic[@"curPage"];
        NSNumber *ifHasNextPage = dic[@"hasNext"];
        NSMutableArray *orderListCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
        
        for (NSDictionary *itemDic in dic[@"items"]) {
            OrderCellVM *orderCellVM = [[OrderCellVM alloc] initWithResponseDic:itemDic];
            [orderListCellVMList addObject:orderCellVM];
        }
        
        resultData = @{
                       kOrderListDataKeyHaveMorePage: ifHasNextPage,
                       kOrderListDataKeyOrderListCellVMList: orderListCellVMList,
                       kOrderListDataKeyPage: page
                       };
    }
    
    return resultData;
}

@end
