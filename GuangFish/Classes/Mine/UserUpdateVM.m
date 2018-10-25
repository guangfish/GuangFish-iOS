//
//  UserUpdateVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/8/7.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "UserUpdateVM.h"
#import "GuangfishUserUpdateAPIManager.h"

@interface UserUpdateVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishUserUpdateAPIManager *userUpdateAPIManager;

@end

@implementation UserUpdateVM

- (void)initializeData {
    self.requestUserUpdateSignal = [RACSubject subject];
    self.alipay = @"";
    self.weixin = @"";
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.userUpdateAPIManager) {
        params = @{
                   kUserUpdateAPIManagerParamsKeyAlipay: self.alipay,
                   kUserUpdateAPIManagerParamsKeyWeixin: self.weixin
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.userUpdateAPIManager) {
        [self.requestUserUpdateSignal sendNext:@"绑定成功"];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.userUpdateAPIManager) {
        [self.requestUserUpdateSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (BOOL)isValidInput {
    if (self.alipay.length == 0) {
        [self.requestUserUpdateSignal sendNext:[NSError errorWithDomain:@"请输入支付宝账号" code:1 userInfo:nil]];
        return NO;
    } else if (self.weixin.length == 0) {
        [self.requestUserUpdateSignal sendNext:[NSError errorWithDomain:@"请输入微信号" code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)doUserUpdate {
    [self.userUpdateAPIManager loadData];
}

#pragma mark - getters and setters

- (GuangfishUserUpdateAPIManager*)userUpdateAPIManager {
    if (_userUpdateAPIManager == nil) {
        self.userUpdateAPIManager = [[GuangfishUserUpdateAPIManager alloc] init];
        self.userUpdateAPIManager.delegate = self;
        self.userUpdateAPIManager.paramSource = self;
    }
    return _userUpdateAPIManager;
}

- (void)setAlipay:(NSString *)alipay {
    _alipay = alipay;
    if (self.alipay.length > 0 && self.weixin.length > 0) {
        self.updateBtnEnable = [NSNumber numberWithBool:YES];
    } else {
        self.updateBtnEnable = [NSNumber numberWithBool:NO];
    }
}

- (void)setWeixin:(NSString *)weixin {
    _weixin = weixin;
    if (self.alipay.length > 0 && self.weixin.length > 0) {
        self.updateBtnEnable = [NSNumber numberWithBool:YES];
    } else {
        self.updateBtnEnable = [NSNumber numberWithBool:NO];
    }
}

@end
