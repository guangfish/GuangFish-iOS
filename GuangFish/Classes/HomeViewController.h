//
//  HomeViewController.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/11.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVM.h"

@interface HomeViewController : UICollectionViewController

@property (nonatomic, strong) HomeVM *viewModel;

@end
