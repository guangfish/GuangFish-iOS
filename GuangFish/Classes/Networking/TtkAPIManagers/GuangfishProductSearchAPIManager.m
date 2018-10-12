//
//  GuangfishProductSearchAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/12.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GuangfishProductSearchAPIManager.h"

NSString * const kGuangfishProductSearchAPIManagerParamsKeyKey = @"key";
NSString * const kGuangfishProductSearchAPIManagerParamsKeyPageNo = @"pageNo";
NSString * const kGuangfishProductSearchAPIManagerParamsKeySize = @"size";

@implementation GuangfishProductSearchAPIManager

- (NSString*)methodName {
    return API_ProductSearchUrl;
}

@end
