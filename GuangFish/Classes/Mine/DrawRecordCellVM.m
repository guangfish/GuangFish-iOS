//
//  DrawRecordCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/17.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "DrawRecordCellVM.h"

@interface DrawRecordCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation DrawRecordCellVM

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

- (void)getData {
    self.time = [self.dataDic objectForKey:@"drawTime"];
    self.money = [NSString stringWithFormat:@"¥%@", [self.dataDic objectForKey:@"drawMoney"]];
}

@end
