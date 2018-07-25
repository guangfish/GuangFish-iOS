//
//  GuangfishProductInfoAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GuangfishProductInfoAPIManager.h"

NSString * const kProductInfoAPIManagerParamsKeyProductUrl = @"productUrl";
NSString * const kProductInfoAPIManagerParamsKeyPageNo = @"pageNo";
NSString * const kProductInfoAPIManagerParamsKeySize = @"size";

@implementation GuangfishProductInfoAPIManager

- (NSString*)methodName {
    return API_ProductInfoUrl;
}

@end
