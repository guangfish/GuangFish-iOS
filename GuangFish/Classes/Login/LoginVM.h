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

- (void)doLogin;

@end
