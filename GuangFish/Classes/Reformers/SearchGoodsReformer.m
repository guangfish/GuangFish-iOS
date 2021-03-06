//
//  SearchGoodsReformer.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "SearchGoodsReformer.h"

NSString * const kSearchGoodsDataKeyHaveMorePage = @"have_more";
NSString * const kSearchGoodsDataKeyIfJump = @"ifJump";
NSString * const kSearchGoodsDataKeyPage = @"page";
NSString * const kSearchGoodsDataKeyGoodsCellVMList = @"GoodsCellVMList";
NSString * const kSearchGoodsDataKeyMall = @"mall";

@implementation SearchGoodsReformer

- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    NSDictionary *dic = [data objectForKey:@"data"];
    if ((NSNull *)dic != [NSNull null]) {
        if ([manager isKindOfClass:[GuangfishProductInfoAPIManager class]]) {
            NSNumber *page = dic[@"curPage"];
            NSNumber *ifHasNextPage = dic[@"hasNext"];
            NSNumber *ifJump = [dic[@"ifJump"] isEqualToString:@"no"] ? @0 : @1;
            NSMutableArray *goodsCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
            
            for (NSDictionary *itemDic in dic[@"items"]) {
                GoodsCellVM *goodsCellVM = [[GoodsCellVM alloc] initWithResponseDic:itemDic];
                [goodsCellVMList addObject:goodsCellVM];
            }
            
            resultData = @{
                           kSearchGoodsDataKeyHaveMorePage: ifHasNextPage,
                           kSearchGoodsDataKeyIfJump: ifJump,
                           kSearchGoodsDataKeyGoodsCellVMList: goodsCellVMList,
                           kSearchGoodsDataKeyPage: page,
                           kSearchGoodsDataKeyMall: dic[@"mall"]
                           };
        }
    } else {
        resultData = @{
                       kSearchGoodsDataKeyHaveMorePage: @0,
                       kSearchGoodsDataKeyIfJump: @0,
                       kSearchGoodsDataKeyGoodsCellVMList: [[NSMutableArray alloc] init],
                       kSearchGoodsDataKeyPage: @1,
                       kSearchGoodsDataKeyMall: @""
                       };
    }
    
    return resultData;
}

@end
