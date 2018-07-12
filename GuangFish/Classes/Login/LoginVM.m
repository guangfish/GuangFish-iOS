//
//  LoginVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "LoginVM.h"
#import "GuangfishLoginAPIManager.h"

@interface LoginVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishLoginAPIManager *loginAPIManager;

@end

@implementation LoginVM

- (void)initializeData {
    self.requestLoginSignal = [RACSubject subject];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.loginAPIManager) {
        params = @{
                   };
    }
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.loginAPIManager) {
        [self hiddenEmptyView];
        NSLog(@"%@", [manager fetchDataWithReformer:nil]);
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.loginAPIManager) {
        [self.requestLoginSignal sendNext:manager.managerError];
        if (manager.managerError.code == GuangfishNetworkingErrorTypeNetFailed) {
            [self showWirelessView];
        }
    }
}

#pragma mark - public methods

- (void)doLogin {
    [self.loginAPIManager loadData];
}

#pragma mark - getters and setters

- (GuangfishLoginAPIManager*)loginAPIManager {
    if (_loginAPIManager == nil) {
        self.loginAPIManager = [[GuangfishLoginAPIManager alloc] init];
        self.loginAPIManager.delegate = self;
        self.loginAPIManager.paramSource = self;
    }
    return _loginAPIManager;
}

@end
