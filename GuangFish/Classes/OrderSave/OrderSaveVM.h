//
//  OrderSaveVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/23.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface OrderSaveVM : GLViewModel

@property (nonatomic, strong) RACSubject *saveOrderSignal;
@property (nonatomic, strong) NSString *orderId;

- (BOOL)isValidInput;
- (void)saveOrderID;

@end
