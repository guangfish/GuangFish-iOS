//
//  FriendsListVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendsListVM.h"
#import "GuangfishFriendlistAPIManager.h"

@interface FriendsListVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishFriendlistAPIManager *friendlistAPIManager;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FriendsListVM

- (void)initializeData {
    self.requestGetFriendsSignal = [RACSubject subject];
    self.page = 1;
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.friendlistAPIManager) {
        params = @{
                   kFriendlistAPIManagerParamsKeyPageNo: [NSString stringWithFormat:@"%ld", (long)self.page],
                   kFriendlistAPIManagerParamsKeyStatus: [NSString stringWithFormat:@"%ld", (long)self.friendType]
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.friendlistAPIManager) {
        self.page ++;
        NSLog(@"%@", [manager fetchDataWithReformer:nil]);
//        NSDictionary *resultDic = [manager fetchDataWithReformer:self.searchGoodsReformer];
//        if ([[resultDic objectForKey:kSearchGoodsDataKeyPage] isEqualToNumber:@1]) {
//            [self.goodsListCellVMList removeAllObjects];
//        }
//        [self.goodsListCellVMList addObjectsFromArray:[resultDic objectForKey:kSearchGoodsDataKeyGoodsCellVMList]];
//        self.haveMore = [resultDic objectForKey:kSearchGoodsDataKeyHaveMorePage];
//        self.isTaobao = [[resultDic objectForKey:kSearchGoodsDataKeyMall] isEqualToString:@"taobao"] ? YES : NO;
        [self.requestGetFriendsSignal sendNext:@""];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.friendlistAPIManager) {
        [self.requestGetFriendsSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)reloadFriendsList {
    self.page = 1;
    [self loadNextPageFriendsList];
}

- (void)loadNextPageFriendsList {
    [self.friendlistAPIManager loadData];
}

#pragma mark - getters and setters

- (GuangfishFriendlistAPIManager*)friendlistAPIManager {
    if (_friendlistAPIManager == nil) {
        self.friendlistAPIManager = [[GuangfishFriendlistAPIManager alloc] init];
        self.friendlistAPIManager.delegate = self;
        self.friendlistAPIManager.paramSource = self;
    }
    return _friendlistAPIManager;
}

@end
