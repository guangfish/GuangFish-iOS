//
//  NavMenuView.m
//  NavMenuTest
//
//  Created by 顾越超 on 2018/11/29.
//  Copyright © 2018 gulu. All rights reserved.
//

#define menuBtnH 55
#define lineBtnNum 5

#import "NavMenuView.h"

@interface NavMenuView()

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSArray *keyDics;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation NavMenuView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.selectedIndex = 0;
        self.buttons = [[NSMutableArray alloc] init];
        [self getHotMenuInfo];
        [self initialzieBgView];
    }
    return self;
}

#pragma mark - events

- (void)btnTouched:(UIButton*)button {
    NSInteger index = button.tag - 1000;
    self.selectedIndex = index;
    NSDictionary *dic = [self.keyDics objectAtIndex:index];
    [self.delegate navMenuViewSelected:[dic objectForKey:@"name"]];
    [self setSelectedBtnTintColor];
}

#pragma mark - private methods

- (void)initialzieBgView {
    self.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.8];
    [self addSubview:self.menuView];
    [self addButtons];
}

- (void)getHotMenuInfo {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HotSellingKeys" ofType:@"plist"];
    self.keyDics= [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void)addButtons {
    NSInteger l = 0;
    NSInteger ln = 0;
    CGFloat btnW = self.frame.size.width / lineBtnNum;
    for (NSDictionary *dic in self.keyDics) {
        NSInteger index = [self.keyDics indexOfObject:dic];
        l = index / lineBtnNum;
        ln = index % lineBtnNum;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ln * btnW, l * menuBtnH + 8, btnW, menuBtnH)];
        [btn setTitle:[dic objectForKey:@"name"] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setImage:[[UIImage imageNamed:[dic objectForKey:@"img"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:(UIControlStateNormal)];
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, (btnW - btn.imageView.image.size.width) / 2.0, 10 + 10 + 3, (btnW - btn.imageView.image.size.width) / 2.0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(35, -btn.imageView.image.size.width, 0, 0);
        btn.tag = 1000 + index;
        [btn addTarget:self action:@selector(btnTouched:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.menuView addSubview:btn];
        [self.buttons addObject:btn];
    }
    
    [self setSelectedBtnTintColor];
}

- (void)setSelectedBtnTintColor {
    for (UIButton *btn in self.buttons) {
        NSInteger index = [self.buttons indexOfObject:btn];
        if (index == self.selectedIndex) {
            [btn setTintColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00]];
            [btn setTitleColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] forState:(UIControlStateNormal)];
        } else {
            [btn setTintColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]];
            [btn setTitleColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00] forState:(UIControlStateNormal)];
        }
    }
}

#pragma mark - setters and getters

- (UIView*)menuView {
    if (_menuView == nil) {
        CGFloat h = 0;
        if (self.keyDics.count % lineBtnNum == 0) {
            h = self.keyDics.count / lineBtnNum * menuBtnH;
        } else {
            h = (self.keyDics.count / lineBtnNum + 1) * menuBtnH;
        }
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, h + 16)];
        self.menuView.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.menuView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.menuView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.menuView.layer.mask = maskLayer;
    }
    return _menuView;
}

@end
