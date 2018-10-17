//
//  DrawRecordReformer.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/17.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "DrawRecordReformer.h"

NSString * const kDrawRecordDataKeyHaveMorePage = @"have_more";
NSString * const kDrawRecordDataKeyPage = @"page";
NSString * const kDrawRecordDataKeyDrawRecordCellVMList = @"DrawRecordCellVMList";

@implementation DrawRecordReformer

- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    NSDictionary *dic = [data objectForKey:@"data"];
    if ((NSNull *)dic != [NSNull null]) {
        if ([manager isKindOfClass:[GuangfishDrawRecordAPIManager class]]) {
            NSNumber *page = dic[@"curPage"];
            NSNumber *ifHasNextPage = dic[@"hasNext"];
            NSMutableArray *drawRecordCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
            
            int i = 0;
            for (NSDictionary *itemDic in dic[@"items"]) {
                i ++;
                DrawRecordCellVM *drawRecordCellVM = [[DrawRecordCellVM alloc] initWithResponseDic:itemDic];
                if (i % 2 == 0) {
                    drawRecordCellVM.bgColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
                } else {
                    drawRecordCellVM.bgColor = [UIColor whiteColor];
                }
                [drawRecordCellVMList addObject:drawRecordCellVM];
            }
            
            resultData = @{
                           kDrawRecordDataKeyHaveMorePage: ifHasNextPage,
                           kDrawRecordDataKeyDrawRecordCellVMList: drawRecordCellVMList,
                           kDrawRecordDataKeyPage: page
                           };
        }
    } else {
        resultData = @{
                       kDrawRecordDataKeyHaveMorePage: @0,
                       kDrawRecordDataKeyDrawRecordCellVMList: [[NSMutableArray alloc] init],
                       kDrawRecordDataKeyPage: @1
                       };
    }
    
    return resultData;
}

@end
