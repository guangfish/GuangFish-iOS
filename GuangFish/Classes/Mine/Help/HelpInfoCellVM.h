//
//  HelpInfoCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpInfoCellVM : GLViewModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray *redRangeStrList;

- (id)initWithResponseDic:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
