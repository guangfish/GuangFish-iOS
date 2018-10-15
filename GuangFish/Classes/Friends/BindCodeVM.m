//
//  BindCodeVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/9.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "BindCodeVM.h"
#import "GuangfishUserInviteUpdateAPIManager.h"

@interface BindCodeVM()<GuangfishAPIManagerCallBackDelegate, GuangfishAPIManagerParamSource>

@property (nonatomic ,strong) GuangfishUserInviteUpdateAPIManager *userInviteUpdateAPIManager;

@end

@implementation BindCodeVM

- (void)initializeData {
    self.doneBtnEnable = [NSNumber numberWithBool:NO];
    self.requestBindCodeSignal = [RACSubject subject];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.userInviteUpdateAPIManager) {
        params = @{
                   kUserInviteUpdateAPIManagerParamsKeyInviteCode: self.code
                   };
    }
    return params;
}

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.userInviteUpdateAPIManager) {
        [self.requestBindCodeSignal sendNext:@"绑定成功"];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.userInviteUpdateAPIManager) {
        [self.requestBindCodeSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (BOOL)isValidInput {
    if (self.code.length == 0) {
        [self.requestBindCodeSignal sendNext:[NSError errorWithDomain:@"请输入邀请码" code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)doBindCode {
    [self.userInviteUpdateAPIManager loadData];
}

#pragma mark - setters and getters

- (void)setCode:(NSString *)code {
    _code = code;
    if (code.length > 0) {
        self.doneBtnEnable = [NSNumber numberWithBool:YES];
    } else {
        self.doneBtnEnable = [NSNumber numberWithBool:NO];
    }
}

- (GuangfishUserInviteUpdateAPIManager*)userInviteUpdateAPIManager {
    if (_userInviteUpdateAPIManager == nil) {
        self.userInviteUpdateAPIManager = [[GuangfishUserInviteUpdateAPIManager alloc] init];
        self.userInviteUpdateAPIManager.delegate = self;
        self.userInviteUpdateAPIManager.paramSource = self;
    }
    return _userInviteUpdateAPIManager;
}

@end
