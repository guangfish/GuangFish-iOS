//
//  HomeMenuCellVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/18.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeMenuCellVM.h"

@implementation HomeMenuCellVM

- (WebVM*)getWebVM {
    WebVM *webVM = [[WebVM alloc] init];
    webVM.urlStr = self.urlStr;
    return webVM;
}

@end
