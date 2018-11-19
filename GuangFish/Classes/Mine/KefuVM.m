//
//  KefuVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/24.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "KefuVM.h"

@implementation KefuVM

- (void)initializeData {
    self.wxNameCopySignal = [RACSubject subject];
}

- (void)copyWxName {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"ruth0520";
    [self.wxNameCopySignal sendNext:@"ruth0520微信号已复制到剪贴板"];
}

@end
