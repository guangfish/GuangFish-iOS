//
//  TtkAPIUrlConfigManager.h
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import <Foundation/Foundation.h>

//登录接口
#define API_LoginUrl                        @"/app/api/login"

@interface GuangfishAPIUrlConfigManager : NSObject

@property (nonatomic, assign) BOOL isDev;

+ (GuangfishAPIUrlConfigManager*)sharedManager;

- (NSString*)apiUrl;

@end
