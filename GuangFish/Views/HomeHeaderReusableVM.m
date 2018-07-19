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
    self.imageArray = [[NSMutableArray alloc] init];
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

@end
