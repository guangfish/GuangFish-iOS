//
//  HomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/11.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderReusableView.h"
#import "HomeFooterReusableView.h"
#import "HomeMenuCell.h"
#import "WebViewController.h"
#import "MineViewController.h"
#import "MBProgressHUD.h"

@interface HomeViewController ()<HomeHeaderReusableViewDelegate>

@end

@implementation HomeViewController

static NSString * const reuseIdentifier = @"HomeMenuCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    [self initialzieModel];
    
    [self.viewModel getHomeMenu];
    [self.viewModel getBanner];
    
    self.collectionView.bounces = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel getDrawStats];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowWebViewControllerSegue"]) {
        WebViewController *webViewController = [segue destinationViewController];
        webViewController.viewModel = [((HomeMenuCellVM*)sender) getWebVM];
    } else if ([segue.identifier isEqualToString:@"ShowMineInfo"]) {
        MineViewController *mineViewController = segue.destinationViewController;
        mineViewController.viewModel = [self.viewModel getMineVM];
    }
}

#pragma mark - HomeHeaderReusableViewDelegate

- (void)canDraw:(BOOL)canDraw withErrorMsg:(NSString *)errorMsg {
    if (canDraw) {
        [self performSegueWithIdentifier:@"ShowDrawSegue" sender:nil];
    } else {
        [self showTextHud:errorMsg];
    }
}

- (void)hasNotBindAccount {
    [self performSegueWithIdentifier:@"ShowBindAccountSegue" sender:nil];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.menuSectionsList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *cellArray = [self.viewModel.menuSectionsList objectAtIndex:section];
    return cellArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSMutableArray *cellArray = [self.viewModel.menuSectionsList objectAtIndex:indexPath.section];
    cell.viewModel = [cellArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 30) / 3.0, 100);
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HomeHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @"HomeHeaderReusableView" forIndexPath :indexPath];
        headerView.viewModel = self.viewModel.homeHeaderReusableVM;
        headerView.delegate = self;
        reusableview = headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        HomeFooterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionFooter withReuseIdentifier : @"HomeFooterReusableView" forIndexPath :indexPath];
        reusableview = footerView;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *cellArray = [self.viewModel.menuSectionsList objectAtIndex:indexPath.section];
    HomeMenuCellVM *menuCellVM = [cellArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:menuCellVM.segueId sender:menuCellVM];
}

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self);
    [self.viewModel.requestGetBannerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (![x isKindOfClass:[NSError class]]) {
            [self.collectionView reloadData];
        }
    }];
}

- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark - getters and setters

- (HomeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [HomeVM new];
    }
    return _viewModel;
}

@end
