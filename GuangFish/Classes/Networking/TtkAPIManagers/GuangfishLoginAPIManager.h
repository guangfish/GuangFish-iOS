//
//  TtkLoginAPIManager.h
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import "GuangfishAPIBaseManager.h"

extern NSString * const kLoginAPIManagerParamsKeyApp;                  //客户端名称：iOS or Android
extern NSString * const kLoginAPIManagerParamsKeyMobile;
extern NSString * const kLoginAPIManagerParamsKeyCode;

@interface GuangfishLoginAPIManager : GuangfishAPIBaseManager<GuangfishAPIManager>

@end
