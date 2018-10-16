//
//  ProductSearchReformer.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "ProductSearchReformer.h"

NSString * const kProductSearchDataKeyHaveMorePage = @"have_more";
NSString * const kProductSearchDataKeyPage = @"page";
NSString * const kProductSearchDataKeyHotSellingCellVMList = @"HotSellingCellVMList";

@implementation ProductSearchReformer

- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    NSDictionary *dic = [data objectForKey:@"data"];
    if ((NSNull *)dic != [NSNull null]) {
        if ([manager isKindOfClass:[GuangfishProductSearchAPIManager class]]) {
            NSNumber *page = dic[@"curPage"];
            NSNumber *ifHasNextPage = dic[@"hasNext"];
            NSMutableArray *hotSellingCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
            
            for (NSDictionary *itemDic in dic[@"items"]) {
                HotSellingCellVM *hotSellingCellVM = [[HotSellingCellVM alloc] initWithResponseDic:itemDic];
                [hotSellingCellVMList addObject:hotSellingCellVM];
            }
            
            resultData = @{
                           kProductSearchDataKeyHaveMorePage: ifHasNextPage,
                           kProductSearchDataKeyHotSellingCellVMList: hotSellingCellVMList,
                           kProductSearchDataKeyPage: page
                           };
        }
    } else {
        resultData = @{
                       kProductSearchDataKeyHaveMorePage: @0,
                       kProductSearchDataKeyHotSellingCellVMList: [[NSMutableArray alloc] init],
                       kProductSearchDataKeyPage: @1
                       };
    }
    
    return resultData;
}

@end
