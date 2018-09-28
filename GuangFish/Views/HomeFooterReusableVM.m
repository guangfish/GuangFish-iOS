//
//  HomeFooterReusableVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/9/28.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HomeFooterReusableVM.h"
#import "GuangfishNetworkingManager.h"

@implementation HomeFooterReusableVM

- (void)initializeData {
    
}

- (void)logout {
    [[GuangfishNetworkingManager sharedManager] logout];
}

@end
