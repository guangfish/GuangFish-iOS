//
//  HotSellingVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellingVM.h"
#import "GuangfishProductSearchAPIManager.h"
#import "ProductSearchReformer.h"

@interface HotSellingVM()<GuangfishAPIManagerCallBackDelegate, GuangfishAPIManagerParamSource>

@property (nonatomic, strong) GuangfishProductSearchAPIManager *productSearchAPIManager;
@property (nonatomic, strong) ProductSearchReformer *productSearchReformer;
@property (nonatomic, assign) NSInteger page;

@end

@implementation HotSellingVM

- (void)initializeData {
    self.requestGetProductSearchSignal = [RACSubject subject];
    self.page = 1;
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (self.productSearchAPIManager == manager) {
        params = @{
                   kGuangfishProductSearchAPIManagerParamsKeyKey: [self.key isEqualToString:@"全部"] ? @"": self.key,
                   kGuangfishProductSearchAPIManagerParamsKeyPageNo: [NSNumber numberWithInteger:self.page],
                   kGuangfishProductSearchAPIManagerParamsKeySize: @30
                   };
    }
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.productSearchAPIManager) {
        self.page ++;
        NSDictionary *resultDic = [manager fetchDataWithReformer:self.productSearchReformer];
        if ([[resultDic objectForKey:kProductSearchDataKeyPage] isEqualToNumber:@1]) {
            [self.hotSellingCellVMList removeAllObjects];
        }
        [self.hotSellingCellVMList addObjectsFromArray:[resultDic objectForKey:kProductSearchDataKeyHotSellingCellVMList]];
        self.haveMore = [resultDic objectForKey:kProductSearchDataKeyHaveMorePage];
        [self.requestGetProductSearchSignal sendNext:@""];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.productSearchAPIManager) {
        [self.requestGetProductSearchSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)reloadHotSellingList {
    self.page = 1;
    [self loadNextPageHotSellingList];
}

- (void)loadNextPageHotSellingList {
    [self.productSearchAPIManager loadData];
}

#pragma mark - setters and getters

- (GuangfishProductSearchAPIManager*)productSearchAPIManager {
    if (_productSearchAPIManager == nil) {
        self.productSearchAPIManager = [[GuangfishProductSearchAPIManager alloc] init];
        self.productSearchAPIManager.delegate = self;
        self.productSearchAPIManager.paramSource = self;
    }
    return _productSearchAPIManager;
}

- (ProductSearchReformer*)productSearchReformer {
    if (_productSearchReformer == nil) {
        self.productSearchReformer = [[ProductSearchReformer alloc] init];
    }
    return _productSearchReformer;
}

- (NSMutableArray*)hotSellingCellVMList {
    if (_hotSellingCellVMList == nil) {
        self.hotSellingCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _hotSellingCellVMList;
}

@end
