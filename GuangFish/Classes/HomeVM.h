//
//  HomeVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/13.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "HomeHeaderReusableVM.h"

@interface HomeVM : GLViewModel

@property (nonatomic, strong) NSMutableArray *menuSectionsList;
@property (nonatomic, strong) RACSubject *requestGetBannerSignal;
@property (nonatomic, strong) RACSubject *requestGetdrawStatsSignal;
@property (nonatomic, strong) HomeHeaderReusableVM *homeHeaderReusableVM;

- (void)getBanner;
- (void)getDrawStats;
- (void)getHomeMenu;

@end
