//
//  MenuButton.m
//  MenuDemo
//
//  Created by 顾越超 on 2018/10/8.
//  Copyright © 2018 gulu. All rights reserved.
//

#import "MenuButton.h"

@interface MenuButton()

@property (nonatomic, assign) CGRect closeFrame;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation MenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.closeFrame = frame;
        [self initialzieView];
    }
    return self;
}

#pragma mark - actions

- (void)buttonAction:(id)sender {
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        [self.button setImage:[UIImage imageNamed:@"img_close"] forState:(UIControlStateNormal)];
        [self open];
    } else {
        [self.button setImage:[UIImage imageNamed:@"img_add"] forState:(UIControlStateNormal)];
        [self close];
    }
}

- (void)menuButtonTouchAction:(id)sender {
    UIButton *button = sender;
    [self.delegate menuButtonTouch:button.tag];
}

#pragma mark - private methods

- (void)initialzieView {
    [self addSubview:self.button];
}

- (void)open {
    self.frame = CGRectMake(self.closeFrame.origin.x, self.closeFrame.origin.y, [[UIScreen mainScreen] bounds].size.width - self.closeFrame.origin.x - 50, self.closeFrame.size.height);
    
    for (UIButton *button in self.buttonArray) {
        button.hidden = NO;
    }
}

- (void)close {
    self.frame = self.closeFrame;
    
    for (UIButton *button in self.buttonArray) {
        button.hidden = YES;
    }
}

- (void)initialzieButtons {
    [self removeAllButtons];
    [self addButtons];
}

- (void)removeAllButtons {
    for (UIButton *button in self.buttonArray) {
        [button removeFromSuperview];
    }
    
    [self.buttonArray removeAllObjects];
}

- (void)addButtons {
    CGFloat m = ([[UIScreen mainScreen] bounds].size.width - self.closeFrame.origin.x - 50 - (self.closeFrame.size.width * (self.buttonImageArray.count + 1))) / self.buttonImageArray.count;
    
    int i = 1;
    for (UIImage *image in self.buttonImageArray) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.closeFrame.size.width + m) * i, 0, self.closeFrame.size.width, self.closeFrame.size.height)];
        button.tag = i;
        [button addTarget:self action:@selector(menuButtonTouchAction:) forControlEvents:(UIControlEventTouchUpInside)];
        i ++;
        [button setImage:image forState:(UIControlStateNormal)];
        [self addSubview:button];
        button.hidden = YES;
        [self.buttonArray addObject:button];
    }
}

#pragma mark - setters and getters

- (UIButton*)button {
    if (_button == nil) {
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.closeFrame.size.width, self.closeFrame.size.height)];
        [self.button setImage:[UIImage imageNamed:@"img_add"] forState:(UIControlStateNormal)];
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (void)setButtonImageArray:(NSArray *)buttonImageArray {
    if (self.buttonImageArray != buttonImageArray) {
        _buttonImageArray = buttonImageArray;
        [self initialzieButtons];
        [self buttonAction:nil];
    }
}

- (NSMutableArray*)buttonArray {
    if (_buttonArray == nil) {
        self.buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

@end
