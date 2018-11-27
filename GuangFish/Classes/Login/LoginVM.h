//
//  LoginVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface LoginVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestLoginSignal;
@property (nonatomic, strong) RACSubject *requestSendCodeSignal;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *sendCodeButtonTitleStr;
@property (nonatomic, strong) NSNumber *sendCodeButtonEnable;
@property (nonatomic, strong) NSString *version;

- (void)doSendCode;
- (void)doLogin;
- (BOOL)isValidSendCodeInput;
- (BOOL)isValidInput;

@end
