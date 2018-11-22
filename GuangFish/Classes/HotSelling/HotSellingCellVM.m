//
//  HotSellingCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellingCellVM.h"
#import "WebVm.h"
#import "GuangfishGetTklAPIManager.h"

@interface HotSellingCellVM()<GuangfishAPIManagerParamSource, GuangfishAPIManagerCallBackDelegate>

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) GuangfishGetTklAPIManager *getTklAPIManager;

@end

@implementation HotSellingCellVM

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
    self.productName = [NSString stringWithFormat:@"      %@", [self.dataDic objectForKey:@"productName"]];
    self.imageURLStr = [self.dataDic objectForKey:@"imgUrl"];
    self.shopName = [NSString stringWithFormat:@"店名:%@", [self.dataDic objectForKey:@"shopName"]];
    self.price = [NSString stringWithFormat:@"¥%@", [self.dataDic objectForKey:@"price"]];
    self.reservePrice = [NSString stringWithFormat:@"原价:¥%@", [self.dataDic objectForKey:@"reservePrice"]];
    self.sellNum = [NSString stringWithFormat:@"月销量(件):%@", [self.dataDic objectForKey:@"sellNum"]];
    self.commission = [NSString stringWithFormat:@"预估返:¥%@", [self.dataDic objectForKey:@"commission"]];
    if ([self.dataDic objectForKey:@"quanMianzhi"] != nil && ![[self.dataDic objectForKey:@"quanMianzhi"] isEqualToString:@""]) {
        self.quanMianZhi = [NSString stringWithFormat:@"领劵省:¥%@", [self.dataDic objectForKey:@"quanMianzhi"]];
    } else {
        self.quanMianZhi = @"";
    }
    if ([[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"shopType"]] isEqualToString:@"0"]) {
        self.shopTypeImage = [UIImage imageNamed:@"img_taobao"];
    } else {
        self.shopTypeImage = [UIImage imageNamed:@"img_tianmao"];
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

#pragma mark - public methods

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
