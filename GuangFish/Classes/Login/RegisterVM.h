//
//  RegisterVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/17.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface RegisterVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestRegisterSignal;
@property (nonatomic, strong) RACSubject *requestSendCodeSignal;
@property (nonatomic, strong) NSString *sendCodeButtonTitleStr;
@property (nonatomic, strong) NSNumber *sendCodeButtonEnable;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *inviteCode;
@property (nonatomic, strong) NSString *alipay;
@property (nonatomic, strong) NSString *weixin;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *code;

- (void)doSendCode;
- (void)doRegister;
- (BOOL)isValidSendCodeInput;
- (BOOL)isValidInput;

@end