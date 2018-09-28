//
//  HomeMenuCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/18.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeMenuCell.h"

@interface HomeMenuCell()

@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HomeMenuCell

- (void)initialzieModel {
    @weakify(self)
    [RACObserve(self.viewModel, menuImgName) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.menuImageView.image = [UIImage imageNamed:x];
    }];
    
    [RACObserve(self.viewModel, menuTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.nameLabel.text = x;
    }];
}

#pragma mark - getters and setters

- (void)setViewModel:(HomeMenuCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

@end
