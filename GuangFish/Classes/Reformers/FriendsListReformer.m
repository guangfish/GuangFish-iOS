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
        
        for (NSDictionary *itemDic in dic[@"items"]) {
            FriendCellVM *friendCellVM = [[FriendCellVM alloc] initWithResponseDic:itemDic];
            [friendsCellVMList addObject:friendCellVM];
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
