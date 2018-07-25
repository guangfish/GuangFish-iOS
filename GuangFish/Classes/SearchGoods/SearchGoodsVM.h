//
//  SearchGoodsVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "GoodsListVM.h"

@interface SearchGoodsVM : GLViewModel

@property (nonatomic, strong) RACSubject *searchGoodsSignal;
@property (nonatomic, strong) NSString *searchStr;

- (BOOL)isValidInput;
- (GoodsListVM*)getGoodsListVM;

@end
