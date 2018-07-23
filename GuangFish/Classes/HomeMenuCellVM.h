//
//  HomeMenuCellVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/18.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "WebVM.h"

@interface HomeMenuCellVM : GLViewModel

@property (nonatomic, strong) NSString *menuImgName;
@property (nonatomic, strong) NSString *menuTitle;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *segueId;

- (WebVM*)getWebVM;

@end
