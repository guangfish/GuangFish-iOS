//
//  OrderCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface OrderCellVM : GLViewModel

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *commission;

- (id)initWithResponseDic:(NSDictionary*)dic;

@end
