//
//  GuangfishOrderlistAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishOrderlistAPIManager.h"

NSString * const kOrderlistAPIManagerParamsKeyOrderStatus = @"orderStatus";
NSString * const kOrderlistAPIManagerParamsKeyPageNo = @"pageNo";
NSString * const kOrderlistAPIManagerParamsKeySize = @"size";

@implementation GuangfishOrderlistAPIManager

- (NSString*)methodName {
    return API_OrderlistUrl;
}

@end
