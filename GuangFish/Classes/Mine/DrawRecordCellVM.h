//
//  DrawRecordCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/17.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface DrawRecordCellVM : GLViewModel

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *bgColor;

- (id)initWithResponseDic:(NSDictionary*)dic;

@end
