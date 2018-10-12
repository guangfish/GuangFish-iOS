//
//  DrawRecordAPIManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/12.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "DrawRecordAPIManager.h"

NSString * const kDrawRecordAPIManagerParamsKeyPageNo = @"pageNo";
NSString * const kDrawRecordAPIManagerParamsKeySize = @"size";

@implementation DrawRecordAPIManager

- (NSString*)methodName {
    return API_DrawRecordUrl;
}

@end
