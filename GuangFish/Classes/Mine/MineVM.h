//
//  MineVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/23.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "WebVM.h"

@interface MineVM : GLViewModel

@property (nonatomic, strong) RACSubject *inviteCodeSignal;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *totalBuySave;

- (void)logout;
- (void)getUserData;
- (WebVM*)getHelpWebVM;
- (WebVM*)getInviteWebVM;
- (WebVM*)getKeFuWebVM;
- (WebVM*)getAboutUsWebVM;

@end
