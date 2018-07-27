//
//  FriendsListVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendsListVM.h"
#import "GuangfishFriendlistAPIManager.h"
#import "FriendsListReformer.h"

@interface FriendsListVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishFriendlistAPIManager *friendlistAPIManager;
@property (nonatomic, strong) FriendsListReformer *friendsListReformer;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FriendsListVM

- (void)initializeData {
    self.requestGetFriendsSignal = [RACSubject subject];
    self.page = 1;
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.friendlistAPIManager) {
        params = @{
                   kFriendlistAPIManagerParamsKeyPageNo: [NSString stringWithFormat:@"%ld", (long)self.page],
                   kFriendlistAPIManagerParamsKeyStatus: [NSString stringWithFormat:@"%ld", (long)self.friendType]
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.friendlistAPIManager) {
        self.page ++;
        NSDictionary *resultDic = [manager fetchDataWithReformer:self.friendsListReformer];
        if ([[resultDic objectForKey:kFriendsListDataKeyPage] isEqualToNumber:@1]) {
            [self.friendCellVMList removeAllObjects];
        }
        [self.friendCellVMList addObjectsFromArray:[resultDic objectForKey:kFriendsListDataKeyFriendCellVMList]];
        self.haveMore = [resultDic objectForKey:kFriendsListDataKeyHaveMorePage];
        [self.requestGetFriendsSignal sendNext:@""];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.friendlistAPIManager) {
        [self.requestGetFriendsSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)reloadFriendsList {
    self.page = 1;
    [self loadNextPageFriendsList];
}

- (void)loadNextPageFriendsList {
    [self.friendlistAPIManager loadData];
}

#pragma mark - getters and setters

- (NSMutableArray*)friendCellVMList {
    if (_friendCellVMList == nil) {
        self.friendCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _friendCellVMList;
}

- (GuangfishFriendlistAPIManager*)friendlistAPIManager {
    if (_friendlistAPIManager == nil) {
        self.friendlistAPIManager = [[GuangfishFriendlistAPIManager alloc] init];
        self.friendlistAPIManager.delegate = self;
        self.friendlistAPIManager.paramSource = self;
    }
    return _friendlistAPIManager;
}

- (FriendsListReformer*)friendsListReformer {
    if (_friendsListReformer == nil) {
        self.friendsListReformer = [[FriendsListReformer alloc] init];
    }
    return _friendsListReformer;
}

@end
