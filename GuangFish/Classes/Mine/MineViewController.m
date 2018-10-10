//
//  MineViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/23.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "MineViewController.h"
#import "WebViewController.h"

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBuySaveLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:0.95 green:0.00 blue:0.33 alpha:1.00].CGColor;
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.cornerRadius = 8.0f;
    
    [self initialzieModel];
    
    [self.viewModel getUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3) {
        [self performSegueWithIdentifier:@"ShowWebViewControllerSegue" sender:[self.viewModel getHelpWebVM]];
    } else if (indexPath.section == 0 && indexPath.row == 4) {
        [self performSegueWithIdentifier:@"ShowWebViewControllerSegue" sender:[self.viewModel getInviteWebVM]];
    } else if (indexPath.section == 0 && indexPath.row == 5) {
        [self performSegueWithIdentifier:@"ShowWebViewControllerSegue" sender:[self.viewModel getKeFuWebVM]];
    } else if (indexPath.section == 0 && indexPath.row == 7) {
        [self performSegueWithIdentifier:@"ShowWebViewControllerSegue" sender:[self.viewModel getAboutUsWebVM]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowWebViewControllerSegue"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.viewModel = sender;
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    RAC(self.typeLabel, text) = RACObserve(self.viewModel, typeStr);
    RAC(self.mobileLabel, text) = RACObserve(self.viewModel, mobile);
    RAC(self.totalBuySaveLabel, text) = RACObserve(self.viewModel, totalBuySave);
    
    @weakify(self);
    [self.viewModel.inviteCodeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if (![x isKindOfClass:[NSError class]]) {
            [self showTextHud:x];
        }
    }];
    
    self.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel logout];
        
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController *loginNavigationController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginNavigationController;
        
        return [RACSignal empty];
    }];
}

#pragma mark - getters and setters

- (MineVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [MineVM new];
    }
    return _viewModel;
}

@end
