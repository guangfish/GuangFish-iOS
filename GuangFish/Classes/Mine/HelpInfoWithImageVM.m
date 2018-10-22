//
//  HelpInfoWithImageVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoWithImageVM.h"

@implementation HelpInfoWithImageVM

- (void)initializeData {
    self.getInfoListSignal = [RACSubject subject];
}

#pragma mark - public methods

- (void)getInfo {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.infoPlistName ofType:@"plist"];
    NSArray *infoArray= [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *dic in infoArray) {
        NSLog(@"%@", [dic objectForKey:@"title"]);
        HelpInfoWithImageCellVM *helpInfoWithImageCellVM = [[HelpInfoWithImageCellVM alloc] initWithResponseDic:dic];
        [self.infoCellVMList addObject:helpInfoWithImageCellVM];
    }
    [self.getInfoListSignal sendNext:@""];
}

- (NSMutableArray*)infoCellVMList {
    if (_infoCellVMList == nil) {
        self.infoCellVMList = [[NSMutableArray alloc] init];
    }
    return _infoCellVMList;
}

@end
