//
//  GoodsCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GoodsCellVM.h"
#import "WebVm.h"
#import "GuangfishGetTklAPIManager.h"

@interface GoodsCellVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) GuangfishGetTklAPIManager *getTklAPIManager;

@end

@implementation GoodsCellVM

- (void)initializeData {
    self.openTaobaoSignal = [RACSubject subject];
}

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

- (void)getData {
    self.productName = [self.dataDic objectForKey:@"productName"];
    self.productImageUrlStr = [self.dataDic objectForKey:@"imgUrl"];
    self.shopName = [NSString stringWithFormat:@"店名:%@", [self.dataDic objectForKey:@"shopName"]];
    self.price = [NSString stringWithFormat:@"价格:¥%@", [self.dataDic objectForKey:@"price"]];
    self.sellNum = [NSString stringWithFormat:@"月销量(件):%@", [self.dataDic objectForKey:@"sellNum"]];
    if ([[self.dataDic allKeys] containsObject:@"quanMianzhi"] && ((NSString*)[self.dataDic objectForKey:@"quanMianzhi"]).length > 0) {
        self.labelStr1 = [NSString stringWithFormat:@"领劵省:¥%@", [self.dataDic objectForKey:@"quanMianzhi"]];
        self.labelStr2 = [NSString stringWithFormat:@"预估返现:¥%@", [self.dataDic objectForKey:@"commission"]];
    } else {
        self.labelStr1 = [NSString stringWithFormat:@"预估返现:¥%@", [self.dataDic objectForKey:@"commission"]];
        self.labelStr2 = @"";
    }
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    
    if (manager == self.getTklAPIManager) {
        params = @{
                   kGetTklAPIManagerParamsKeyProductId: [self.dataDic objectForKey:@"productId"],
                   kGetTklAPIManagerParamsKeyTkUrl: [self.dataDic objectForKey:@"tkUrl"],
                   kGetTklAPIManagerParamsKeyProductName: [self.dataDic objectForKey:@"productName"],
                   kGetTklAPIManagerParamsKeyImgUrl: [self.dataDic objectForKey:@"imgUrl"]
                   };
    }
    
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.getTklAPIManager) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSURL *url = [NSURL URLWithString:@"taobao://item.taobao.com/item.htm"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [dataDic objectForKey:@"tkl"];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    [self.openTaobaoSignal sendError:[NSError errorWithDomain:@"获取淘口令失败" code:1 userInfo:nil]];
}

- (void)openTaobao {
    NSURL *url = [NSURL URLWithString:@"taobao://item.taobao.com/item.htm"];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        WebVM *webVM = [[WebVM alloc] init];
        webVM.urlStr = [self.dataDic objectForKey:@"tkUrl"];
        [self.openTaobaoSignal sendNext:[NSError errorWithDomain:@"打开淘宝失败" code:1 userInfo:@{@"webVM": webVM}]];
    } else {
        [self.getTklAPIManager loadData];
    }
}

- (void)openSafari {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.dataDic objectForKey:@"tkl"]] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.dataDic objectForKey:@"tkl"]]];
    }
}

#pragma mark - getters and setters

- (GuangfishGetTklAPIManager*)getTklAPIManager {
    if (_getTklAPIManager == nil) {
        self.getTklAPIManager = [[GuangfishGetTklAPIManager alloc] init];
        self.getTklAPIManager.paramSource = self;
        self.getTklAPIManager.delegate = self;
    }
    return _getTklAPIManager;
}

@end
