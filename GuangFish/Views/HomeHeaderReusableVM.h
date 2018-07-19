//
//  HomeHeaderReusableVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/18.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface HomeHeaderReusableVM : GLViewModel

@property (nonatomic, strong) RACSubject *downloadImageSignal;
@property (nonatomic, strong) NSMutableArray *bannerDicArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end
