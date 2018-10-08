//
//  MenuButton.h
//  MenuDemo
//
//  Created by 顾越超 on 2018/10/8.
//  Copyright © 2018 gulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuButtonDelegate <NSObject>

- (void)menuButtonTouch:(NSInteger)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MenuButton : UIView

@property (nonatomic, weak) id<MenuButtonDelegate> delegate;
@property (nonatomic, strong) NSArray *buttonImageArray;

@end

NS_ASSUME_NONNULL_END
