//
//  ViewModel.m
//  csfk
//
//  Created by Tendency on 16/2/25.
//  Copyright © 2016年 Tendency. All rights reserved.
//

#import "GLViewModel.h"

@implementation GLViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeData];
        [self hiddenEmptyView];
    }
    return self;
}

- (void)initializeData {}

- (void)showNodataView {
    self.isShowNodataView = [NSNumber numberWithBool:YES];
    self.isShowWirelessView = [NSNumber numberWithBool:NO];
}

- (void)showWirelessView {
    self.isShowNodataView = [NSNumber numberWithBool:NO];
    self.isShowWirelessView = [NSNumber numberWithBool:YES];
}

- (void)hiddenEmptyView {
    self.isShowNodataView = [NSNumber numberWithBool:NO];
    self.isShowWirelessView = [NSNumber numberWithBool:NO];
    self.isHiddenEmptyView = [NSNumber numberWithBool:YES];
}

@end
