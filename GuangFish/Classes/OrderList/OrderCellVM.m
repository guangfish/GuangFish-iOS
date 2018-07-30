//
//  OrderCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderCellVM.h"

@interface OrderCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation OrderCellVM

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

#pragma mark - private methods

- (void)getData {
    self.imageURL = [NSURL URLWithString:[self.dataDic objectForKey:@"imgUrl"]];
    self.productName = [self.dataDic objectForKey:@"productName"];
    self.orderTime = [self.dataDic objectForKey:@"orderTime"];
    self.orderStatus = [self.dataDic objectForKey:@"orderStatus"];
    self.commission = [self.dataDic objectForKey:@"commission"];
}

@end
