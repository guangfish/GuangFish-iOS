//
//  OrderListVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderListVM.h"
#import "GuangfishOrderlistAPIManager.h"
#import "OrderListReformer.h"

@interface OrderListVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishOrderlistAPIManager *orderlistAPIManager;
@property (nonatomic, strong) OrderListReformer *orderListReformer;
@property (nonatomic, assign) NSInteger page;

@end

@implementation OrderListVM

- (void)initializeData {
    self.requestGetOrderListSignal = [RACSubject subject];
    self.page = 1;
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.orderlistAPIManager) {
        params = @{
                   kOrderlistAPIManagerParamsKeyPageNo: [NSString stringWithFormat:@"%ld", (long)self.page],
                   kOrderlistAPIManagerParamsKeyOrderStatus: [NSString stringWithFormat:@"%ld", (long)self.orderType]
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.orderlistAPIManager) {
        self.page ++;
        NSDictionary *resultDic = [manager fetchDataWithReformer:self.orderListReformer];
        if ([[resultDic objectForKey:kOrderListDataKeyHaveMorePage] isEqualToNumber:@1]) {
            [self.orderCellVMList removeAllObjects];
        }
        [self.orderCellVMList addObjectsFromArray:[resultDic objectForKey:kOrderListDataKeyOrderListCellVMList]];
        self.haveMore = [resultDic objectForKey:kOrderListDataKeyHaveMorePage];
        [self.requestGetOrderListSignal sendNext:@""];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.orderlistAPIManager) {
        [self.requestGetOrderListSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)reloadOrderList {
    self.page = 1;
    [self loadNextPageOrderList];
}

- (void)loadNextPageOrderList {
    [self.orderlistAPIManager loadData];
}

#pragma mark - getters and setters

- (NSMutableArray*)orderCellVMList {
    if (_orderCellVMList == nil) {
        self.orderCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _orderCellVMList;
}

- (GuangfishOrderlistAPIManager*)orderlistAPIManager {
    if (_orderlistAPIManager == nil) {
        self.orderlistAPIManager = [[GuangfishOrderlistAPIManager alloc] init];
        self.orderlistAPIManager.delegate = self;
        self.orderlistAPIManager.paramSource = self;
    }
    return _orderlistAPIManager;
}

- (OrderListReformer*)orderListReformer {
    if (_orderListReformer == nil) {
        self.orderListReformer = [[OrderListReformer alloc] init];
    }
    return _orderListReformer;
}

@end
