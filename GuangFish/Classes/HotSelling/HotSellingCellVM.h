//
//  HotSellingCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface HotSellingCellVM : GLViewModel

@property (nonatomic, strong) RACSubject *openTaobaoSignal;
@property (nonatomic, strong) NSString *imageURLStr;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *sellNum;
@property (nonatomic, strong) NSString *commission;
@property (nonatomic, strong) NSString *quanMianZhi;

- (id)initWithResponseDic:(NSDictionary*)dic;
- (void)openTaobao;

@end
