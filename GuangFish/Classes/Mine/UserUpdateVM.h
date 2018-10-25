//
//  UserUpdateVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/8/7.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface UserUpdateVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestUserUpdateSignal;
@property (nonatomic, strong) NSString *alipay;
@property (nonatomic, strong) NSString *weixin;
@property (nonatomic, strong) NSNumber *updateBtnEnable;

- (BOOL)isValidInput;
- (void)doUserUpdate;

@end
