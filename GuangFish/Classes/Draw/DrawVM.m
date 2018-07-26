//
//  DrawVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "DrawVM.h"
#import "GuangfishGetSmsCodeAPIManager.h"
#import "GuangfishDrawAPIManager.h"

@interface DrawVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishGetSmsCodeAPIManager *getSmsCodeAPIManager;
@property (nonatomic, strong) GuangfishDrawAPIManager *drawAPIManager;

@end

@implementation DrawVM

- (void)initializeData {
    self.requestSendCodeSignal = [RACSubject subject];
    self.requestDrawSignal = [RACSubject subject];
    self.sendCodeButtonTitleStr = @"获取验证码";
    self.sendCodeButtonEnable = [NSNumber numberWithBool:YES];
    
    [self startTimer];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.getSmsCodeAPIManager) {
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDic"];
        NSString *mobile = [userDic objectForKey:@"mobile"];
        params = @{
                   kGetSmsCodeAPIManagerParamsKeyMobile: mobile
                   };
    } else if (manager == self.drawAPIManager) {
        params = @{
                   kDrawAPIManagerParamsKeyCode: self.code
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.getSmsCodeAPIManager) {
        [self saveGetVerificationCodeTime];
        [self startTimer];
        [self.requestSendCodeSignal sendNext:@"发送成功"];
    } else if (manager == self.drawAPIManager) {
        [self.requestDrawSignal sendNext:@"提现申请成功"];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.getSmsCodeAPIManager) {
        [self.requestSendCodeSignal sendNext:manager.managerError];
    } else if (manager == self.drawAPIManager) {
        [self.requestDrawSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (BOOL)isValidInput {
    if (self.code.length == 0) {
        [self.requestDrawSignal sendNext:[NSError errorWithDomain:@"请输入验证码" code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)doSendCode {
    [self.getSmsCodeAPIManager loadData];
}

- (void)doDraw {
    [self.drawAPIManager loadData];
}

#pragma mark - private methods

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

- (GuangfishGetSmsCodeAPIManager*)getSmsCodeAPIManager {
    if (_getSmsCodeAPIManager == nil) {
        self.getSmsCodeAPIManager = [[GuangfishGetSmsCodeAPIManager alloc] init];
        self.getSmsCodeAPIManager.delegate = self;
        self.getSmsCodeAPIManager.paramSource = self;
    }
    return _getSmsCodeAPIManager;
}

- (GuangfishDrawAPIManager*)drawAPIManager {
    if (_drawAPIManager == nil) {
        self.drawAPIManager = [[GuangfishDrawAPIManager alloc] init];
        self.drawAPIManager.delegate = self;
        self.drawAPIManager.paramSource = self;
    }
    return _drawAPIManager;
}

@end
