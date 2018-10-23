//
//  HelpInfoWithTitleCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/23.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoWithTitleCellVM.h"

@interface HelpInfoWithTitleCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation HelpInfoWithTitleCellVM

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

#pragma mark - private methods

- (void)getData {
    self.question = [self.dataDic objectForKey:@"question"];
    self.answer = [self.dataDic objectForKey:@"answer"];
}

@end
