//
//  HelpVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpVM.h"

@implementation HelpVM

- (void)initializeData {
    
}

#pragma mark - public methods

- (HelpInfoWithImageVM*)getTbsyVM {
    HelpInfoWithImageVM *helpInfoWithImageVM = [[HelpInfoWithImageVM alloc] init];
    helpInfoWithImageVM.infoPlistName = @"TbsyHelpInfo";
    return helpInfoWithImageVM;
}

- (HelpInfoWithImageVM*)getJdsyVM {
    HelpInfoWithImageVM *helpInfoWithImageVM = [[HelpInfoWithImageVM alloc] init];
    helpInfoWithImageVM.infoPlistName = @"JdsyHelpInfo";
    return helpInfoWithImageVM;
}

- (HelpInfoVM*)getTxxzVM {
    HelpInfoVM *helpInfoVM = [[HelpInfoVM alloc] init];
    helpInfoVM.infoPlistName = @"TxxzHelpInfo";
    return helpInfoVM;
}

@end
