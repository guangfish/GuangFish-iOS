//
//  MineHomeVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/11/11.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "MineVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineHomeVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestGetBannerSignal;
@property (nonatomic, strong) RACSubject *requestGetdrawStatsSignal;
@property (nonatomic, strong) RACSubject *cleanMemorySignal;
@property (nonatomic, strong) RACSubject *inviteCodeSignal;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *orderMoney;
@property (nonatomic, strong) NSString *paltformReward;
@property (nonatomic, strong) NSNumber *hasBindAccount;
@property (nonatomic, strong) NSNumber *drawBtnEnable;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *totalBuySave;
@property (nonatomic, strong) NSMutableArray *bannerDicArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

- (void)logout;
- (void)getUserData;
- (void)inviteCodeCopy;
- (void)getDrawStats;
- (MineVM*)getMineVM;
- (void)cleanMemory;

@end

NS_ASSUME_NONNULL_END
