//
//  HotSellHomeViewController.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "HotSellingVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HotSellHomeVM : GLViewModel

@property (nonatomic, strong) NSMutableArray *hotSellingVMList;

- (void)getHotSellingVMs;

@end

NS_ASSUME_NONNULL_END
