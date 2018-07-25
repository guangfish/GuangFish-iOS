//
//  GoodsListVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface GoodsListVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestGetGoodsListSignal;
@property (nonatomic, strong) NSMutableArray *goodsListCellVMList;
@property (nonatomic, strong) NSNumber *haveMore;
@property (nonatomic, strong) NSString *searchStr;

- (void)reloadGoodsList;
- (void)loadNextPageGoodsList;

@end
