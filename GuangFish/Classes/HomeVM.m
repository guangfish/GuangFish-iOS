//
//  HomeVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/13.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeVM.h"
#import "HomeMenuCellVM.h"

@implementation HomeVM

- (void)initializeData {
    self.menuSectionsList = [[NSMutableArray alloc] init];
}

#pragma mark - public methods

- (void)getBanner {
    
}

- (void)getHomeMenu {
    //从HomeMenu.plist文件获取菜单项
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HomeMenu" ofType:@"plist"];
    NSMutableArray *sections = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSArray *array in sections) {
        NSMutableArray *menuCellVMList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            HomeMenuCellVM *homeMenuCellVM = [[HomeMenuCellVM alloc] init];
            homeMenuCellVM.menuImgName = [dic objectForKey:@"imgName"];
            homeMenuCellVM.menuTitle = [dic objectForKey:@"title"];
            [menuCellVMList addObject:homeMenuCellVM];
        }
        [self.menuSectionsList addObject:menuCellVMList];
    }
}

@end
