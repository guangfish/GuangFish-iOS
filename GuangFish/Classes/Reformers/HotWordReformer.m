//
//  HotWordReformer.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/27.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotWordReformer.h"

NSString * const kHotWordDataKeyArray = @"key_array";

@implementation HotWordReformer

- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    NSDictionary *dic = [data objectForKey:@"data"];
    if ([manager isKindOfClass:[GuangfishHotWordAPIManager class]]) {
        NSMutableArray *hotKeyList = [[NSMutableArray alloc] initWithCapacity:30];
        
        for (NSDictionary *itemDic in dic[@"items"]) {
            [hotKeyList addObject:[itemDic objectForKey:@"word"]];
        }
        
        resultData = @{
                       kHotWordDataKeyArray: hotKeyList
                       };
    }
    
    return resultData;
}

@end
