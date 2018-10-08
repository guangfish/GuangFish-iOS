//
//  FriendsListReformer.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendsListReformer.h"

NSString * const kFriendsListDataKeyHaveMorePage = @"have_more";
NSString * const kFriendsListDataKeyPage = @"page";
NSString * const kFriendsListDataKeyFriendCellVMList = @"FriendCellVMList";

@implementation FriendsListReformer

- (id)manager:(GuangfishAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *resultData = nil;
    NSDictionary *dic = [data objectForKey:@"data"];
    if ([manager isKindOfClass:[GuangfishFriendlistAPIManager class]]) {
        NSNumber *page = dic[@"curPage"];
        NSNumber *ifHasNextPage = dic[@"hasNext"];
        NSMutableArray *friendsCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
        
        int i = 1;
        for (NSDictionary *itemDic in dic[@"items"]) {
            FriendCellVM *friendCellVM = [[FriendCellVM alloc] initWithResponseDic:itemDic];
            if (i % 2 == 0) {
                friendCellVM.backgroundColor = [UIColor colorWithRed:1.00 green:0.98 blue:0.99 alpha:1.00];
            } else {
                friendCellVM.backgroundColor = [UIColor whiteColor];
            }
            [friendsCellVMList addObject:friendCellVM];
            i ++;
        }
        
        resultData = @{
                       kFriendsListDataKeyHaveMorePage: ifHasNextPage,
                       kFriendsListDataKeyFriendCellVMList: friendsCellVMList,
                       kFriendsListDataKeyPage: page
                       };
    }
    
    return resultData;
}

@end
