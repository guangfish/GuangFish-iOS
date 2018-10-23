//
//  HelpVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "HelpInfoWithImageVM.h"
#import "HelpInfoVM.h"
#import "HelpInfoWithTitleVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpVM : GLViewModel

- (HelpInfoWithImageVM*)getTbsyVM;
- (HelpInfoWithImageVM*)getJdsyVM;
- (HelpInfoVM*)getTxxzVM;
- (HelpInfoWithTitleVM*)getCjwtVM;

@end

NS_ASSUME_NONNULL_END
