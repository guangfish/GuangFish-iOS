//
//  HelpInfoWithTitleCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/23.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpInfoWithTitleCellVM : GLViewModel

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;

- (id)initWithResponseDic:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
