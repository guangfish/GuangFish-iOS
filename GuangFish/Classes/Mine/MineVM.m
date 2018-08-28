//
//  MineVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/23.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "MineVM.h"
#import "GuangfishNetworkingManager.h"

@interface MineVM()

@property (nonatomic, strong) NSString *inviteCode;

@end

@implementation MineVM

- (void)initializeData {
    self.inviteCodeSignal = [RACSubject subject];
    self.mobile = @"";
    self.inviteCode = @"";
}

#pragma mark - public methods

- (void)logout {
    [[GuangfishNetworkingManager sharedManager] logout];
}

- (void)getUserData {
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDic"];
    self.mobile = [userDic objectForKey:@"mobile"];
    if ([[userDic objectForKey:@"userType"] isEqualToString:@"1"]) {
        self.typeStr = @"普通会员";
    } else if ([[userDic objectForKey:@"userType"] isEqualToString:@"2"]) {
        self.typeStr = @"超级会员";
    }
    self.inviteCode = [userDic objectForKey:@"inviteCode"];
}

- (void)copyInviteCode {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteCode;
    [self.inviteCodeSignal sendNext:@"邀请码已复制"];
}

- (WebVM*)getHelpWebVM {
    WebVM *webVM = [[WebVM alloc] init];
    webVM.urlStr = @"https://www.guangfish.com/app/api/help";
    return webVM;
}

- (WebVM*)getInviteWebVM {
    WebVM *webVM = [[WebVM alloc] init];
    webVM.urlStr = @"https://www.guangfish.com/app/api/invite";
    return webVM;
}

- (WebVM*)getKeFuWebVM {
    WebVM *webVM = [[WebVM alloc] init];
    webVM.urlStr = @"https://www.guangfish.com/app/api/kefu";
    return webVM;
}

- (WebVM*)getAboutUsWebVM {
    WebVM *webVM = [[WebVM alloc] init];
    webVM.urlStr = @"https://www.guangfish.com/app/api/about";
    return webVM;
}

@end
