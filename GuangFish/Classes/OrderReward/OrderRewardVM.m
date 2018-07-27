//
//  OrderRewardVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderRewardVM.h"
#import "GuangfishOrderrewardlistAPIManager.h"
#import "OrderRewardReformer.h"

@interface OrderRewardVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishOrderrewardlistAPIManager *orderrewardlistAPIManager;
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
    
    if (manager == self.orderrewardlistAPIManager) {
        params = @{
                   kOrderrewardlistAPIManagerParamsKeyPageNo: [NSString stringWithFormat:@"%ld", (long)self.page]
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.orderrewardlistAPIManager) {
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
    if (manager == self.orderrewardlistAPIManager) {
        [self.requestGetOrderRewardSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)reloadOrderRewardList {
    self.page = 1;
    [self loadNextPageOrderRewardList];
}

- (void)loadNextPageOrderRewardList {
    [self.orderrewardlistAPIManager loadData];
}

#pragma mark - getters and setters

- (NSMutableArray*)orderRewardCellVMList {
    if (_orderRewardCellVMList == nil) {
        self.orderRewardCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _orderRewardCellVMList;
}

- (GuangfishOrderrewardlistAPIManager*)orderrewardlistAPIManager {
    if (_orderrewardlistAPIManager == nil) {
        self.orderrewardlistAPIManager = [[GuangfishOrderrewardlistAPIManager alloc] init];
        self.orderrewardlistAPIManager.delegate = self;
        self.orderrewardlistAPIManager.paramSource = self;
    }
    return _orderrewardlistAPIManager;
}

- (OrderRewardReformer*)orderRewardReformer {
    if (_orderRewardReformer == nil) {
        self.orderRewardReformer = [[OrderRewardReformer alloc] init];
    }
    return _orderRewardReformer;
}

@end
