//
//  OrderRewardVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderRewardVM.h"
#import "GuangfishFriendlistAPIManager.h"
#import "OrderRewardReformer.h"

@interface OrderRewardVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishFriendlistAPIManager *friendlistAPIManager;
@property (nonatomic, strong) OrderRewardReformer *orderRewardReformer;
@property (nonatomic, assign) NSInteger page;

@end

@implementation OrderRewardVM

- (void)initializeData {
    self.requestGetOrderRewardSignal = [RACSubject subject];
    self.page = 1;
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.friendlistAPIManager) {
        params = @{
                   kFriendlistAPIManagerParamsKeyPageNo: [NSString stringWithFormat:@"%ld", (long)self.page],
                   kFriendlistAPIManagerParamsKeyStatus: @"3"
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.friendlistAPIManager) {
        self.page ++;
        NSDictionary *resultDic = [manager fetchDataWithReformer:self.orderRewardReformer];
        if ([[resultDic objectForKey:kOrderRewardListDataKeyPage] isEqualToNumber:@1]) {
            [self.orderRewardCellVMList removeAllObjects];
        }
        [self.orderRewardCellVMList addObjectsFromArray:[resultDic objectForKey:kOrderRewardListDataKeyOrderRewardCellVMList]];
        self.haveMore = [resultDic objectForKey:kOrderRewardListDataKeyHaveMorePage];
        [self.requestGetOrderRewardSignal sendNext:@""];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.friendlistAPIManager) {
        [self.requestGetOrderRewardSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)reloadOrderRewardList {
    self.page = 1;
    [self loadNextPageOrderRewardList];
}

- (void)loadNextPageOrderRewardList {
    [self.friendlistAPIManager loadData];
}

#pragma mark - getters and setters

- (NSMutableArray*)orderRewardCellVMList {
    if (_orderRewardCellVMList == nil) {
        self.orderRewardCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _orderRewardCellVMList;
}

- (GuangfishFriendlistAPIManager*)friendlistAPIManager {
    if (_friendlistAPIManager == nil) {
        self.friendlistAPIManager = [[GuangfishFriendlistAPIManager alloc] init];
        self.friendlistAPIManager.delegate = self;
        self.friendlistAPIManager.paramSource = self;
    }
    return _friendlistAPIManager;
}

- (OrderRewardReformer*)orderRewardReformer {
    if (_orderRewardReformer == nil) {
        self.orderRewardReformer = [[OrderRewardReformer alloc] init];
    }
    return _orderRewardReformer;
}

@end
