//
//  HomeHeaderReusableView.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHeaderReusableVM.h"

@protocol HomeHeaderReusableViewDelegate <NSObject>

- (void)canDraw:(BOOL)canDraw withErrorMsg:(NSString*)errorMsg;
- (void)hasNotBindAccount;

@end

@interface HomeHeaderReusableView : UICollectionReusableView

@property (nonatomic, strong) HomeHeaderReusableVM *viewModel;
@property (nonatomic, weak) id<HomeHeaderReusableViewDelegate> delegate;

@end
