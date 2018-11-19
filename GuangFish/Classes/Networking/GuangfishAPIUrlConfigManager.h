//
//  TtkAPIUrlConfigManager.h
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import <Foundation/Foundation.h>

//登录接口
#define API_LoginUrl                             @"/app/api/login"
//获取短信验证码接口
#define API_GetSmsCodeUrl                        @"/app/api/getSmsCode"
//注册接口
#define API_RegisterUrl                          @"/app/api/register"
//返利信息获取接口
#define API_DrawstatsUrl                         @"/app/api/drawstats"
//商品信息查询接口
#define API_ProductInfoUrl                       @"/app/api/productInfo"
//订单录入接口
#define API_OrdersaveUrl                         @"/app/api/ordersave"
//好友列表接口
#define API_FriendlistUrl                        @"/app/api/friendlistNew"
//订单列表接口
#define API_OrderlistUrl                         @"/app/api/orderlist"
//订单奖励列表接口
#define API_OrderrewardlistUrl                   @"/app/api/orderrewardlist"
//banner接口
#define API_BannerUrl                            @"/app/api/banner"
//提现接口
#define API_DrawUrl                              @"/app/api/draw"
//用户信息更新接口
#define API_UserUpdateUrl                        @"/app/api/userUpdate"
//热卖商品查询接口
#define API_ProductSearchUrl                     @"/app/api/productSearch"
//邀请码更新接口
#define API_UserInviteUpdateUrl                  @"/app/api/userInviteUpdate"
//提现记录查询接口
#define API_DrawRecordUrl                        @"/app/api/drawRecord"
//热词查询接口
#define API_HotWordUrl                           @"/app/api/hotword"
//获取淘口令接口
#define API_GetTklUrl                            @"/app/api/getTkl"

@interface GuangfishAPIUrlConfigManager : NSObject

@property (nonatomic, assign) BOOL isDev;

+ (GuangfishAPIUrlConfigManager*)sharedManager;

- (NSString*)apiUrl;

@end
