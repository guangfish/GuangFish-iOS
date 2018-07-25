//
//  SearchGoodsVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "SearchGoodsVM.h"

@implementation SearchGoodsVM

- (void)initializeData {
    self.searchGoodsSignal = [RACSubject subject];
}

#pragma mark - public methods

- (BOOL)isValidInput {
    if (self.searchStr.length == 0) {
        [self.searchGoodsSignal sendNext:[NSError errorWithDomain:@"请输入搜索内容" code:1 userInfo:nil]];
        return NO;
    } else {
        return YES;
    }
}

- (GoodsListVM*)getGoodsListVM {
    GoodsListVM *goodsListVM = [[GoodsListVM alloc] init];
    goodsListVM.searchStr = self.searchStr;
    [goodsListVM reloadGoodsList];
    return goodsListVM;
}

@end
