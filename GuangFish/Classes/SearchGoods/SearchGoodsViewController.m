//
//  SearchGoodsViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "GoodsListViewController.h"

@interface SearchGoodsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SearchGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [self initialzieModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowGoodsListSegue"]) {
        GoodsListViewController *goodsListViewController = segue.destinationViewController;
        goodsListViewController.viewModel = [self.viewModel getGoodsListVM];
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.viewModel, searchStr) = self.searchTextField.rac_textSignal;
    
    @weakify(self);
    self.searchButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self performSegueWithIdentifier:@"ShowGoodsListSegue" sender:nil];
        }
        return [RACSignal empty];
    }];
    
    [self.viewModel.searchGoodsSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            
        }
    }];
}

#pragma mark - getters and setters

- (SearchGoodsVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [SearchGoodsVM new];
    }
    return _viewModel;
}

@end
