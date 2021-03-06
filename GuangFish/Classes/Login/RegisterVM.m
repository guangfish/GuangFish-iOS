//
//  RegisterVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/17.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "RegisterVM.h"
#import "GuangfishGetSmsCodeAPIManager.h"
#import "GuangfishRegisterAPIManager.h"

@interface RegisterVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishGetSmsCodeAPIManager *getSmsCodeAPIManager;
@property (nonatomic, strong) GuangfishRegisterAPIManager *registerAPIManager;

@end

@implementation RegisterVM

- (void)initializeData {
    self.requestRegisterSignal = [RACSubject subject];
    self.requestSendCodeSignal = [RACSubject subject];
    self.sendCodeButtonTitleStr = @"获取验证码";
    self.sendCodeButtonEnable = [NSNumber numberWithBool:YES];
    
    [self startTimer];
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.registerAPIManager) {
        params = @{
                   kRegisterAPIManagerParamsKeyCode: self.code,
                   kRegisterAPIManagerParamsKeyApp: @"ios",
                   kRegisterAPIManagerParamsKeySex: [self.sex isEqualToString:@"女"] ? @"1" : @"2",
                   kRegisterAPIManagerParamsKeyMobile: self.mobile,
                   kRegisterAPIManagerParamsKeyInviteCode: self.inviteCode
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
    if (manager == self.registerAPIManager) {
        [self hiddenEmptyView];
        [self saveUserData:[[manager fetchDataWithReformer:nil] objectForKey:@"data"]];
        [self.requestRegisterSignal sendNext:@"注册成功"];
    } else if (manager == self.getSmsCodeAPIManager) {
        [self saveGetVerificationCodeTime];
        [self startTimer];
        [self.requestSendCodeSignal sendNext:@"发送成功"];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.registerAPIManager) {
        [self.requestRegisterSignal sendNext:manager.managerError];
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
        [self.requestRegisterSignal sendNext:[NSError errorWithDomain:@"请输入正确的手机号" code:1 userInfo:nil]];
        return NO;
    } else if (self.code.length == 0) {
        [self.requestRegisterSignal sendNext:[NSError errorWithDomain:@"请输入验证码" code:1 userInfo:nil]];
        return NO;
    }
    return YES;
}

- (void)doSendCode {
    [self.getSmsCodeAPIManager loadData];
}

- (void)doRegister {
    [self.registerAPIManager loadData];
}

- (NSString*)getInviteCode {
    NSString *code = [UIPasteboard generalPasteboard].string;
    if ([self isInviteCode:code]) {
        [UIPasteboard generalPasteboard].string = @"";
        NSString *resultCode = [self subStringComponentsSeparatedByStrContent:code strPoint:@"Ʊ" firstFlag:1 secondFlag:2];
        self.code = resultCode;
        return resultCode;
    }
    return @"";
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
    [userDef setInteger:time forKey:@"VerificationCodeForRegisterTime"];
    [userDef synchronize];
}

- (void)startTimer {
    __block NSInteger timeout = 59;
    
    NSInteger yzmtime = [[NSUserDefaults standardUserDefaults] integerForKey:@"VerificationCodeForRegisterTime"];
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

- (BOOL)isInviteCode:(NSString*)str {
    NSString *resultStr = [self subStringComponentsSeparatedByStrContent:str strPoint:@"Ʊ" firstFlag:1 secondFlag:2];
    if (resultStr.length > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)subStringComponentsSeparatedByStrContent:(NSString *)strContent strPoint:(NSString *)strPoint firstFlag:(int)firstFlag secondFlag:(int)secondFlag {
    NSInteger scount = [[strContent mutableCopy] replaceOccurrencesOfString:@"Ʊ" // 要查询的字符串中的某个字符
                                                                 withString:@"Ʊ"
                                                                    options:NSLiteralSearch
                                                                      range:NSMakeRange(0, [strContent length])];
    
    if (scount != 2) {
        return @"";
    }
    
    // 初始化一个起始位置和结束位置
    NSRange startRange = NSMakeRange(0, 1);
    NSRange endRange = NSMakeRange(0, 1);
    
    // 获取传入的字符串的长度
    NSInteger strLength = [strContent length];
    // 初始化一个临时字符串变量
    NSString *temp = nil;
    // 标记一下找到的同一个字符的次数
    int count = 0;
    // 开始循环遍历传入的字符串，找寻和传入的 strPoint 一样的字符
    for(int i = 0; i < strLength; i++)
    {
        // 截取字符串中的每一个字符,赋值给临时变量字符串
        temp = [strContent substringWithRange:NSMakeRange(i, 1)];
        // 判断临时字符串和传入的参数字符串是否一样
        if ([temp isEqualToString:strPoint]) {
            // 遍历到的相同字符引用计数+1
            count++;
            if (firstFlag == count)
            {
                // 遍历字符串，第一次遍历到和传入的字符一样的字符
                // 将第一次遍历到的相同字符的位置，赋值给起始截取的位置
                startRange = NSMakeRange(i, 1);
            }
            else if (secondFlag == count)
            {
                // 遍历字符串，第二次遍历到和传入的字符一样的字符
                // 将第二次遍历到的相同字符的位置，赋值给结束截取的位置
                endRange = NSMakeRange(i, i);
            }
        }
    }
    // 根据起始位置和结束位置，截取相同字符之间的字符串的范围
    NSRange rangeMessage = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    // 根据得到的截取范围，截取想要的字符串，赋值给结果字符串
    NSString *result = [strContent substringWithRange:rangeMessage];
    // 打印一下截取到的字符串，看看是否是想要的结果
    // 最后将结果返回出去
    return result;
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

- (GuangfishRegisterAPIManager*)registerAPIManager {
    if (_registerAPIManager == nil) {
        self.registerAPIManager = [[GuangfishRegisterAPIManager alloc] init];
        self.registerAPIManager.delegate = self;
        self.registerAPIManager.paramSource = self;
    }
    return _registerAPIManager;
}

@end
