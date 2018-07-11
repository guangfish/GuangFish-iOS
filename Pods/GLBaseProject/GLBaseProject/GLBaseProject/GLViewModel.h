//
//  ViewModel.h
//  csfk
//
//  Created by Tendency on 16/2/25.
//  Copyright © 2016年 Tendency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface GLViewModel : NSObject

@property (nonatomic, strong) NSNumber *isShowNodataView;
@property (nonatomic, strong) NSNumber *isShowWirelessView;
@property (nonatomic, strong) NSNumber *isHiddenEmptyView;

- (void)showNodataView;
- (void)showWirelessView;
- (void)hiddenEmptyView;

@end
