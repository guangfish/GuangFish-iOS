//
//  BindCodeVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/9.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "BindCodeVM.h"

@implementation BindCodeVM

- (void)initializeData {
    self.doneBtnEnable = [NSNumber numberWithBool:NO];
}

#pragma mark - setters and getters

- (void)setCode:(NSString *)code {
    _code = code;
    if (code.length > 0) {
        self.doneBtnEnable = [NSNumber numberWithBool:YES];
    } else {
        self.doneBtnEnable = [NSNumber numberWithBool:NO];
    }
}

@end
