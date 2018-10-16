//
//  HotSellHomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellHomeVM.h"

@implementation HotSellHomeVM

- (void)initializeData {
    
}

#pragma mark - public methods

- (void)getHotSellingVMs {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HotSellingKeys" ofType:@"plist"];
    NSArray *keys= [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSString *key in keys) {
        HotSellingVM *hotSellingVM = [[HotSellingVM alloc] init];
        hotSellingVM.key = key;
        [self.hotSellingVMList addObject:hotSellingVM];
    }
}

- (NSMutableArray*)hotSellingVMList {
    if (_hotSellingVMList == nil) {
        self.hotSellingVMList = [[NSMutableArray alloc] init];
    }
    return _hotSellingVMList;
}

@end
