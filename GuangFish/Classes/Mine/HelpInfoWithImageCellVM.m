//
//  HelpInfoWithImageCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoWithImageCellVM.h"

@interface HelpInfoWithImageCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation HelpInfoWithImageCellVM

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

#pragma mark - private methods

- (void)getData {
    self.infoImage = [UIImage imageNamed:[self.dataDic objectForKey:@"image"]];
    self.title = [self.dataDic objectForKey:@"title"];
}

@end
