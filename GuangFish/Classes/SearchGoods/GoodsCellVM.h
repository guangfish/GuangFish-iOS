//
//  GoodsCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface GoodsCellVM : GLViewModel

@property (nonatomic, strong) RACSubject *openTaobaoSignal;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImageUrlStr;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *sellNum;
@property (nonatomic, strong) NSString *labelStr1;
@property (nonatomic, strong) NSString *labelStr2;

- (id)initWithResponseDic:(NSDictionary*)dic;
- (void)openTaobao;
- (void)openSafari;

@end
