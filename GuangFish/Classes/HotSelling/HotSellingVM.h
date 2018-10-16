//
//  HotSellingVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface HotSellingVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestGetProductSearchSignal;
@property (nonatomic, strong) NSMutableArray *hotSellingCellVMList;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSNumber *haveMore;

- (void)reloadHotSellingList;
- (void)loadNextPageHotSellingList;

@end
