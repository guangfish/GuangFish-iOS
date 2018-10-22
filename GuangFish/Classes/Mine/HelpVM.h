//
//  HelpVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "HelpInfoWithImageVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpVM : GLViewModel

- (HelpInfoWithImageVM*)getTbsyVM;
- (HelpInfoWithImageVM*)getJdsyVM;

@end

NS_ASSUME_NONNULL_END
