//
//  HotSellingCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellingCellVM.h"

@interface HotSellingCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation HotSellingCellVM

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

- (void)getData {
    self.productName = [self.dataDic objectForKey:@"productName"];
    self.imageURLStr = [self.dataDic objectForKey:@"imgUrl"];
    self.shopName = [NSString stringWithFormat:@"店名:%@", [self.dataDic objectForKey:@"shopName"]];
    self.price = [NSString stringWithFormat:@"价格:¥%@", [self.dataDic objectForKey:@"price"]];
    self.sellNum = [NSString stringWithFormat:@"月销量(件):%@", [self.dataDic objectForKey:@"sellNum"]];
    self.commission = [NSString stringWithFormat:@"预估返现:¥%@", [self.dataDic objectForKey:@"commission"]];
    if ([self.dataDic objectForKey:@"quanMianzhi"] != nil && ![[self.dataDic objectForKey:@"quanMianzhi"] isEqualToString:@""]) {
        self.quanMianZhi = [NSString stringWithFormat:@"领劵省:¥%@", [self.dataDic objectForKey:@"quanMianzhi"]];
    } else {
        self.quanMianZhi = @"";
    }
}

#pragma mark - public methods

- (void)openTaobao {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.dataDic objectForKey:@"tkl"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://item.taobao.com/item.htm"] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://item.taobao.com/item.htm"]];
    }
}

@end
