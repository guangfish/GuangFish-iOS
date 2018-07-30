//
//  SmartSearchManager.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartSearchManager : NSObject

+ (SmartSearchManager*)sharedManager;

- (void)beginSearch;

@end
