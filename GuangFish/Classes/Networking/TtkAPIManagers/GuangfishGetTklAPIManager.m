//
//  GuangfishGetTklAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/11/19.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GuangfishGetTklAPIManager.h"

NSString * const kGetTklAPIManagerParamsKeyProductId = @"productId";
NSString * const kGetTklAPIManagerParamsKeyTkUrl = @"tkUrl";
NSString * const kGetTklAPIManagerParamsKeyProductName = @"productName";
NSString * const kGetTklAPIManagerParamsKeyImgUrl = @"imgUrl";

@implementation GuangfishGetTklAPIManager

- (NSString*)methodName {
    return API_GetTklUrl;
}

@end
