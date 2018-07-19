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

@interface HomeVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishBannerAPIManager *bannerAPIManager;

@end

@implementation HomeVM

- (void)initializeData {
    self.requestGetBannerSignal = [RACSubject subject];
    self.menuSectionsList = [[NSMutableArray alloc] init];
    self.homeHeaderReusableVM = [[HomeHeaderReusableVM alloc] init];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.bannerAPIManager) {
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
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.bannerAPIManager) {
        [self.requestGetBannerSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)getBanner {
    [self.bannerAPIManager loadData];
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
            [menuCellVMList addObject:homeMenuCellVM];
        }
        [self.menuSectionsList addObject:menuCellVMList];
    }
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

@end
