//
//  HelpInfoCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoCellVM.h"

@interface HelpInfoCellVM()

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation HelpInfoCellVM

- (id)initWithResponseDic:(NSDictionary *)dic {
    if ((self = [super init])) {
        self.dataDic = dic;
        [self getData];
    }
    return self;
}

#pragma mark - private methods

- (void)getData {
    self.content = [self.dataDic objectForKey:@"content"];
    NSString *redRangeListStr = [self.dataDic objectForKey:@"redtext"];
    for (NSString *str in [redRangeListStr componentsSeparatedByString:@";"]) {
        [self.redRangeStrList addObject:str];
    }
}

#pragma mark - setters and getters

- (NSMutableArray*)redRangeStrList {
    if (_redRangeStrList == nil) {
        self.redRangeStrList = [[NSMutableArray alloc] init];
    }
    return _redRangeStrList;
}

@end
