//
//  OrderSaveVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/23.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderSaveVM.h"
#import "GuangfishOrdersaveAPIManager.h"

@interface OrderSaveVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) GuangfishOrdersaveAPIManager *orderSaveAPIManager;

@end

@implementation OrderSaveVM

- (void)initializeData {
    self.saveOrderSignal = [RACSubject subject];
    self.orderId = @"";
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.orderSaveAPIManager) {
        params = @{
                   kOrdersaveAPIManagerParamsKeyOrderId: self.orderId
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.orderSaveAPIManager) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        [self.saveOrderSignal sendNext:[dic objectForKey:@"desc"]];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.orderSaveAPIManager) {
        [self.saveOrderSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (BOOL)isValidInput {
    if (self.orderId.length == 0) {
        [self.saveOrderSignal sendNext:[NSError errorWithDomain:@"请输入订单号" code:1 userInfo:nil]];
        return NO;
    } else {
        return YES;
    }
}

- (void)saveOrderID {
    [self.orderSaveAPIManager loadData];
}

- (NSString*)getOrderIdFromPasteboard {
    NSString *order = [UIPasteboard generalPasteboard].string;
    if ([self isOrderNum:order]) {
        self.orderId = order;
        [UIPasteboard generalPasteboard].string = @"";
        return self.orderId;
    }
    return @"";
}

#pragma mark - private methods

- (BOOL)isOrderNum:(NSString*)str {
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str] && (str.length == 11 || str.length == 18)) {
        return YES;
    }
    return NO;
}

#pragma mark - getters and setters

- (GuangfishOrdersaveAPIManager*)orderSaveAPIManager {
    if (_orderSaveAPIManager == nil) {
        self.orderSaveAPIManager = [[GuangfishOrdersaveAPIManager alloc] init];
        self.orderSaveAPIManager.delegate = self;
        self.orderSaveAPIManager.paramSource = self;
    }
    return _orderSaveAPIManager;
}

- (void)setOrderId:(NSString *)orderId{
    _orderId = orderId;
    if (orderId.length > 0) {
        self.doneBtnEnable = [NSNumber numberWithBool:YES];
    } else {
        self.doneBtnEnable = [NSNumber numberWithBool:NO];
    }
}

@end
