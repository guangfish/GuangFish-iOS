//
//  HelpInfoWithImageVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "HelpInfoWithImageCellVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpInfoWithImageVM : GLViewModel

@property (nonatomic, strong) RACSubject *getInfoListSignal;
@property (nonatomic, strong) NSString *infoPlistName;
@property (nonatomic, strong) NSMutableArray *infoCellVMList;

- (void)getInfo;

@end

NS_ASSUME_NONNULL_END
