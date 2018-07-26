//
//  DrawVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface DrawVM : GLViewModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *sendCodeButtonTitleStr;
@property (nonatomic, strong) NSNumber *sendCodeButtonEnable;
@property (nonatomic, strong) RACSubject *requestSendCodeSignal;
@property (nonatomic, strong) RACSubject *requestDrawSignal;

- (void)doSendCode;
- (BOOL)isValidInput;
- (void)doDraw;

@end
