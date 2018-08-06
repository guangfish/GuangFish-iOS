//
//  HomeHeaderReusableVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/18.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeHeaderReusableVM.h"
#import "UIKit+AFNetworking.h"

@implementation HomeHeaderReusableVM

- (void)initializeData {
    self.downloadImageSignal = [RACSubject subject];
    self.codeCopySignal = [RACSubject subject];
    self.imageArray = [[NSMutableArray alloc] init];
    self.totalMoney = @"0.0";
    self.inviteReward = @"0.0";
    self.orderMoney = @"0.0";
    self.friendNum = @"0";
    self.drawBtnEnable = [NSNumber numberWithBool:NO];
}

#pragma mark - public methods

- (void)codeCopy {
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDic"];
    NSString *inviteCodeShort = [userDic objectForKey:@"inviteCode"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = inviteCodeShort;
    [self.codeCopySignal sendNext:@"邀请码已复制"];
}

#pragma mark - private methods

#pragma mark - getters and setters

- (void)setBannerDicArray:(NSMutableArray *)bannerDicArray {
    if (_bannerDicArray != bannerDicArray) {
        _bannerDicArray = bannerDicArray;
    }
    
    for (NSDictionary *dic in self.bannerDicArray) {
        [self.imageArray addObject:[dic objectForKey:@"imgUrl"]];
    }
    [self.downloadImageSignal sendNext:@""];
}

- (void)setDrawStatsDic:(NSDictionary *)drawStatsDic {
    if (_drawStatsDic != drawStatsDic) {
        _drawStatsDic = drawStatsDic;
    }
    
    self.totalMoney = [self.drawStatsDic objectForKey:@"totalMoney"];
    self.inviteReward = [self.drawStatsDic objectForKey:@"inviteReward"];
    self.orderMoney = [self.drawStatsDic objectForKey:@"orderMoney"];
    self.friendNum = [self.drawStatsDic objectForKey:@"friendNum"];
    self.drawBtnEnable = [self.drawStatsDic objectForKey:@"canDraw"];
    self.reason = [self.drawStatsDic objectForKey:@"reason"];
    self.hongbao = [self.drawStatsDic objectForKey:@"hongbao"];
}

@end
