//
//  HelpInfoWithImageCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpInfoWithImageCellVM : GLViewModel

@property (nonatomic, strong) UIImage *infoImage;
@property (nonatomic, strong) NSString *title;

- (id)initWithResponseDic:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
