//
//  GoodsListVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GoodsListVM.h"
#import "GuangfishProductInfoAPIManager.h"
#import "SearchGoodsReformer.h"

@interface GoodsListVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishProductInfoAPIManager *productInfoAPIManager;
@property (nonatomic, strong) SearchGoodsReformer *searchGoodsReformer;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL ifJump;

@end

@implementation GoodsListVM

- (void)initializeData {
    self.requestGetGoodsListSignal = [RACSubject subject];
    self.ifJump = NO;
    self.page = 1;
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.productInfoAPIManager) {
        params = @{
                   kProductInfoAPIManagerParamsKeyProductUrl: self.searchStr,
                   kProductInfoAPIManagerParamsKeyPageNo: [NSString stringWithFormat:@"%ld", (long)self.page]
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.productInfoAPIManager) {
        self.page ++;
        NSDictionary *resultDic = [manager fetchDataWithReformer:self.searchGoodsReformer];
        if ([[resultDic objectForKey:kSearchGoodsDataKeyPage] isEqualToNumber:@1]) {
            [self.goodsListCellVMList removeAllObjects];
        }
        [self.goodsListCellVMList addObjectsFromArray:[resultDic objectForKey:kSearchGoodsDataKeyGoodsCellVMList]];
        self.haveMore = [resultDic objectForKey:kSearchGoodsDataKeyHaveMorePage];
        self.isTaobao = [[resultDic objectForKey:kSearchGoodsDataKeyMall] isEqualToString:@"taobao"] ? YES : NO;
        self.ifJump = [[resultDic objectForKey:kSearchGoodsDataKeyIfJump] isEqualToNumber:@1] ? YES : NO;
        if ([[resultDic objectForKey:kSearchGoodsDataKeyPage] isEqualToNumber:@1] && self.goodsListCellVMList.count == 0) {
            [self.requestGetGoodsListSignal sendNext:[NSError errorWithDomain:@"未搜索到商品" code:0 userInfo:nil]];
        } else {
            [self.requestGetGoodsListSignal sendNext:@""];
        }
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.productInfoAPIManager) {
        [self.requestGetGoodsListSignal sendNext:[NSError errorWithDomain:@"未搜索到商品" code:0 userInfo:nil]];
    }
}


#pragma mark - public methods

- (void)reloadGoodsList {
    self.page = 1;
    [self.goodsListCellVMList removeAllObjects];
    [self.requestGetGoodsListSignal sendNext:@""];
    [self loadNextPageGoodsList];
}

- (void)loadNextPageGoodsList {
    [self.productInfoAPIManager loadData];
}

- (BOOL)needAutoShowGoods {
    if (self.ifJump) {
        return YES;
    }
    return NO;
}

- (void)autoShowGoods {
    GoodsCellVM *goodsCellVM = self.goodsListCellVMList.firstObject;
    if (self.isTaobao) {
        [goodsCellVM openTaobao];
    } else {
        [goodsCellVM openSafari];
    }
}

#pragma mark - getters and setters

- (GuangfishProductInfoAPIManager*)productInfoAPIManager {
    if (_productInfoAPIManager == nil) {
        self.productInfoAPIManager = [[GuangfishProductInfoAPIManager alloc] init];
        self.productInfoAPIManager.delegate = self;
        self.productInfoAPIManager.paramSource = self;
    }
    return _productInfoAPIManager;
}

- (NSMutableArray*)goodsListCellVMList {
    if (_goodsListCellVMList == nil) {
        self.goodsListCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _goodsListCellVMList;
}

- (SearchGoodsReformer*)searchGoodsReformer {
    if (_searchGoodsReformer == nil) {
        self.searchGoodsReformer = [[SearchGoodsReformer alloc] init];
    }
    return _searchGoodsReformer;
}

@end
