//
//  HotSearchVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/27.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "GoodsListVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HotSearchVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestGetHotWordSignal;
@property (nonatomic, strong) NSArray *hotWordArray;
@property (nonatomic, strong) NSString *searchStr;

- (void)getHotWord;
- (GoodsListVM*)getGoodsListVM;

@end

NS_ASSUME_NONNULL_END
