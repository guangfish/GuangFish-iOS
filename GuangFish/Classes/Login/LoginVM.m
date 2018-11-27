//
//  LoginVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "LoginVM.h"
#import "GuangfishLoginAPIManager.h"
#import "GuangfishGetSmsCodeAPIManager.h"

@interface LoginVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishLoginAPIManager *loginAPIManager;
@property (nonatomic, strong) GuangfishGetSmsCodeAPIManager *getSmsCodeAPIManager;

@end

@implementation LoginVM

- (void)initializeData {
    self.requestLoginSignal = [RACSubject subject];
    self.requestSendCodeSignal = [RACSubject subject];
    self.sendCodeButtonTitleStr = @"获取验证码";
    self.sendCodeButtonEnable = [NSNumber numberWithBool:YES];
    self.version = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    [self startTimer];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.loginAPIManager) {
        params = @{
                   kLoginAPIManagerParamsKeyMobile: self.mobile,
                   kLoginAPIManagerParamsKeyCode: self.code,
                   kLoginAPIManagerParamsKeyApp: @"ios"
                   };
    } else if (manager == self.getSmsCodeAPIManager) {
        params = @{
                   kGetSmsCodeAPIManagerParamsKeyMobile: self.mobile
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.loginAPIManager) {
        [self hiddenEmptyView];
        [self saveUserData:[[manager fetchDataWithReformer:nil] objectForKey:@"data"]];
        [self.requestLoginSignal sendNext:@"登录成功"];
    } else if (manager == self.getSmsCodeAPIManager) {
        [self saveGetVerificationCodeTime];
        [self startTimer];
        [self.requestSendCodeSignal sendNext:@"发送成功"];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.loginAPIManager) {
        [self.requestLoginSignal sendNext:manager.managerError];
    } else if (manager == self.getSmsCodeAPIManager) {
        [self.requestSendCodeSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (BOOL)isValidSendCodeInput {
    if (self.mobile.length != 11) {
        [self.requestSendCodeSignal sendNext:[NSError errorWithDomain:@"请输入正确的手机号" code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (BOOL)isValidInput {
    if (self.mobile.length != 11) {
        [self.requestLoginSignal sendNext:[NSError errorWithDomain:@"请输入正确的手机号" code:1 userInfo:nil]];
        return NO;
    } else if (self.code.length == 0) {
        [self.requestLoginSignal sendNext:[NSError errorWithDomain:@"请输入验证码" code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)doSendCode {
    [self.getSmsCodeAPIManager loadData];
}

- (void)doLogin {
    [self.loginAPIManager loadData];
}

#pragma mark - private methods

- (void)saveUserData:(NSDictionary*)userDic {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:userDic];
    [dic setValue:self.mobile forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"UserDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveGetVerificationCodeTime {
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    //保存获取验证码的时间
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setInteger:time forKey:@"VerificationCodeTime"];
    [userDef synchronize];
}

- (void)startTimer {
    __block NSInteger timeout = 59;
    
    NSInteger yzmtime = [[NSUserDefaults standardUserDefaults] integerForKey:@"VerificationCodeTime"];
    NSInteger nowtime = [[NSDate date] timeIntervalSince1970];
    if (nowtime - yzmtime > 59) {
        timeout = 0;
    } else {
        timeout = 59 - (nowtime - yzmtime);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCodeButtonEnable = [NSNumber numberWithBool:YES];
                self.sendCodeButtonTitleStr = @"获取验证码";
            });
        } else {
            int second = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCodeButtonEnable = [NSNumber numberWithBool:NO];
                self.sendCodeButtonTitleStr = [NSString stringWithFormat:@"(%d)秒", second];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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

- (GuangfishGetSmsCodeAPIManager*)getSmsCodeAPIManager {
    if (_getSmsCodeAPIManager == nil) {
        self.getSmsCodeAPIManager = [[GuangfishGetSmsCodeAPIManager alloc] init];
        self.getSmsCodeAPIManager.delegate = self;
        self.getSmsCodeAPIManager.paramSource = self;
    }
    return _getSmsCodeAPIManager;
}

@end
