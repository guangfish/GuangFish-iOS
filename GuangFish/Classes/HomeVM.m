//
//  HomeVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/13.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeVM.h"
#import "HomeMenuCellVM.h"
#import "GuangfishBannerAPIManager.h"
#import "GuangfishDrawstatsAPIManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishBannerAPIManager *bannerAPIManager;
@property (nonatomic, strong) GuangfishDrawstatsAPIManager *drawstatsAPIManager;

@property (nonatomic, strong) NSString *totalBuySave;

@end

@implementation HomeVM

- (void)initializeData {
    self.requestGetBannerSignal = [RACSubject subject];
    self.requestGetdrawStatsSignal = [RACSubject subject];
    self.cleanMemorySignal = [RACSubject subject];
    self.menuSectionsList = [[NSMutableArray alloc] init];
    self.homeHeaderReusableVM = [[HomeHeaderReusableVM alloc] init];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.bannerAPIManager) {
        params = @{};
    } else if (manager == self.drawstatsAPIManager) {
        params = @{};
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.bannerAPIManager) {
        NSDictionary *responseDic = [manager fetchDataWithReformer:nil];
        self.homeHeaderReusableVM.bannerDicArray = [responseDic objectForKey:@"data"];
        [self.requestGetBannerSignal sendNext:@"banner获取成功"];
    } else if (manager == self.drawstatsAPIManager) {
        NSDictionary *responseDic = [manager fetchDataWithReformer:nil];
        self.homeHeaderReusableVM.drawStatsDic = [responseDic objectForKey:@"data"];
        self.totalBuySave = [[responseDic objectForKey:@"data"] objectForKey:@"totalBuySave"];
        [self.requestGetdrawStatsSignal sendNext:@"返利信息获取成功"];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.bannerAPIManager) {
        [self.requestGetBannerSignal sendNext:manager.managerError];
    } else if (manager == self.drawstatsAPIManager) {
        [self.requestGetdrawStatsSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)getBanner {
    [self.bannerAPIManager loadData];
}

- (void)getDrawStats {
    [self.drawstatsAPIManager loadData];
}

- (void)getHomeMenu {
    //从HomeMenu.plist文件获取菜单项
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HomeMenu" ofType:@"plist"];
    NSMutableArray *sections = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSArray *array in sections) {
        NSMutableArray *menuCellVMList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            HomeMenuCellVM *homeMenuCellVM = [[HomeMenuCellVM alloc] init];
            homeMenuCellVM.menuImgName = [dic objectForKey:@"imgName"];
            homeMenuCellVM.menuTitle = [dic objectForKey:@"title"];
            homeMenuCellVM.urlStr = [dic objectForKey:@"url"];
            homeMenuCellVM.segueId = [dic objectForKey:@"segueId"];
            [menuCellVMList addObject:homeMenuCellVM];
        }
        [self.menuSectionsList addObject:menuCellVMList];
    }
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

- (GuangfishBannerAPIManager*)bannerAPIManager {
    if (_bannerAPIManager == nil) {
        self.bannerAPIManager = [[GuangfishBannerAPIManager alloc] init];
        self.bannerAPIManager.delegate = self;
        self.bannerAPIManager.paramSource = self;
    }
    return _bannerAPIManager;
}

- (GuangfishDrawstatsAPIManager*)drawstatsAPIManager {
    if (_drawstatsAPIManager == nil) {
        self.drawstatsAPIManager = [[GuangfishDrawstatsAPIManager alloc] init];
        self.drawstatsAPIManager.delegate = self;
        self.drawstatsAPIManager.paramSource = self;
    }
    return _drawstatsAPIManager;
}

@end
