//
//  MineHomeVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/11/11.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "MineHomeVM.h"
#import "GuangfishNetworkingManager.h"
#import "GuangfishDrawstatsAPIManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MineHomeVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishDrawstatsAPIManager *drawstatsAPIManager;

@property (nonatomic, strong) NSString *inviteCode;

@end

@implementation MineHomeVM

- (void)initializeData {
    self.inviteCodeSignal = [RACSubject subject];
    self.requestGetBannerSignal = [RACSubject subject];
    self.requestGetdrawStatsSignal = [RACSubject subject];
    self.cleanMemorySignal = [RACSubject subject];
    self.mobile = @"";
    self.totalMoney = @"¥0.00";
    self.paltformReward = @"¥0.00";
    self.orderMoney = @"¥0.00";
    self.totalBuySave = @"¥0.00";
    self.drawBtnEnable = [NSNumber numberWithBool:NO];
    self.imageArray = [[NSMutableArray alloc] init];
    
    self.version = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.drawstatsAPIManager) {
        params = @{};
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.drawstatsAPIManager) {
        NSDictionary *responseDic = [manager fetchDataWithReformer:nil];
        NSDictionary *drawStatsDic = [responseDic objectForKey:@"data"];
        self.totalMoney = [NSString stringWithFormat:@"¥%@", [drawStatsDic objectForKey:@"totalMoney"]];
        self.orderMoney = [NSString stringWithFormat:@"¥%@", [drawStatsDic objectForKey:@"orderMoney"]];
        self.paltformReward = [NSString stringWithFormat:@"¥%@", [drawStatsDic objectForKey:@"platformReward"]];
        self.hasBindAccount = [drawStatsDic objectForKey:@"hasBindAccount"];
        self.drawBtnEnable = [drawStatsDic objectForKey:@"canDraw"];
        self.reason = [drawStatsDic objectForKey:@"reason"];
        self.totalBuySave = [NSString stringWithFormat:@"¥%@", [[responseDic objectForKey:@"data"] objectForKey:@"totalBuySave"]];
        [self.requestGetdrawStatsSignal sendNext:@"返利信息获取成功"];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.drawstatsAPIManager) {
        [self.requestGetdrawStatsSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)logout {
    [[GuangfishNetworkingManager sharedManager] logout];
}

- (void)getUserData {
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDic"];
    self.mobile = [userDic objectForKey:@"mobile"];
    self.inviteCode = [userDic objectForKey:@"inviteCode"];
}

- (void)inviteCodeCopy {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteCode;
    [self.inviteCodeSignal sendNext:@"邀请码复制成功，分享给朋友获得多重奖励金"];
}

- (void)getDrawStats {
    [self.drawstatsAPIManager loadData];
}

- (MineVM*)getMineVM {
    MineVM *mineVM = [[MineVM alloc] init];
    mineVM.totalBuySave = [NSString stringWithFormat:@"¥%@", self.totalBuySave];
    return mineVM;
}

- (void)cleanMemory {
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
    [self.cleanMemorySignal sendNext:@"已成功清除缓存"];
}

#pragma mark - getters and setters

- (GuangfishDrawstatsAPIManager*)drawstatsAPIManager {
    if (_drawstatsAPIManager == nil) {
        self.drawstatsAPIManager = [[GuangfishDrawstatsAPIManager alloc] init];
        self.drawstatsAPIManager.delegate = self;
        self.drawstatsAPIManager.paramSource = self;
    }
    return _drawstatsAPIManager;
}

@end
