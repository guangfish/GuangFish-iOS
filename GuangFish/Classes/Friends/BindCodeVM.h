//
//  BindCodeVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/9.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindCodeVM : GLViewModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *doneBtnEnable;

@end

NS_ASSUME_NONNULL_END
