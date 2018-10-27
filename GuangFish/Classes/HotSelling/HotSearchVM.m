//
//  HotSearchVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/27.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSearchVM.h"
#import "GuangfishHotWordAPIManager.h"
#import "HotWordReformer.h"

@interface HotSearchVM()<GuangfishAPIManagerCallBackDelegate, GuangfishAPIManagerParamSource>

@property (nonatomic, strong) GuangfishHotWordAPIManager *hotWordAPIManager;
@property (nonatomic, strong) HotWordReformer *hotWordReformer;

@end

@implementation HotSearchVM

- (void)initializeData {
    self.requestGetHotWordSignal = [RACSubject subject];
    self.hotWordArray = [[NSArray alloc] init];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (self.hotWordAPIManager == manager) {
        params = @{
                   
                   };
    }
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    NSDictionary *dic = [manager fetchDataWithReformer:self.hotWordReformer];
    self.hotWordArray = [dic objectForKey:kHotWordDataKeyArray];
    [self.requestGetHotWordSignal sendNext:@""];
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.hotWordAPIManager) {
        [self.requestGetHotWordSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)getHotWord {
    [self.hotWordAPIManager loadData];
}

- (GoodsListVM*)getGoodsListVM {
    GoodsListVM *goodsListVM = [[GoodsListVM alloc] init];
    goodsListVM.searchStr = self.searchStr;
    [goodsListVM reloadGoodsList];
    return goodsListVM;
}

#pragma mark - setters and getters

- (GuangfishHotWordAPIManager*)hotWordAPIManager {
    if (_hotWordAPIManager == nil) {
        self.hotWordAPIManager = [[GuangfishHotWordAPIManager alloc] init];
        self.hotWordAPIManager.delegate = self;
        self.hotWordAPIManager.paramSource = self;
    }
    return _hotWordAPIManager;
}

- (HotWordReformer*)hotWordReformer {
    if (_hotWordReformer == nil) {
        self.hotWordReformer = [[HotWordReformer alloc] init];
    }
    return _hotWordReformer;
}

@end
