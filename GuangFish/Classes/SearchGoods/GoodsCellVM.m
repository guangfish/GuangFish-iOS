//
//  GoodsCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GoodsCellVM.h"

@interface GoodsCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation GoodsCellVM

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
    if ([[self.dataDic allKeys] containsObject:@"quanMianzhi"]) {
        self.labelStr1 = [NSString stringWithFormat:@"领劵省:¥%@", [self.dataDic objectForKey:@"quanMianzhi"]];
        self.labelStr2 = [NSString stringWithFormat:@"再返现:¥%@", [self.dataDic objectForKey:@"commission"]];
    } else {
        self.labelStr1 = [NSString stringWithFormat:@"返现:¥%@", [self.dataDic objectForKey:@"commission"]];
        self.labelStr2 = @"";
    }
}

@end