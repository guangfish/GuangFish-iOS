//
//  NavMenuView.h
//  NavMenuTest
//
//  Created by 顾越超 on 2018/11/29.
//  Copyright © 2018 gulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavMenuViewDelegate <NSObject>

- (void)navMenuViewSelected:(NSString*)name;

@end

@interface NavMenuView : UIView

@property (nonatomic, weak) id<NavMenuViewDelegate> delegate;

@end
