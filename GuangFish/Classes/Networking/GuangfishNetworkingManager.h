//
//  TtkNetworkingManager.h
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/6/8.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const GuangfisNetworkingManagerNotificationSholdLoginAgain;

@interface GuangfishNetworkingManager : NSObject

+ (GuangfishNetworkingManager*)sharedManager;

- (BOOL)isLogin;
- (void)setApiUrlIsDev:(BOOL)isDev;
- (NSString*)getUserCode;
- (void)logout;

@end
