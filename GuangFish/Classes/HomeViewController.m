//
//  HomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/11.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderReusableView.h"
#import "HomeMenuCell.h"
#import "WebViewController.h"
#import "MineViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

static NSString * const reuseIdentifier = @"HomeMenuCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    [self initialzieModel];
    
    [self.viewModel getHomeMenu];
    [self.viewModel getBanner];
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

#pragma mark <UICollectionViewDataSource>

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
    return CGSizeMake((self.view.frame.size.width) / 3.0, (self.view.frame.size.width) / 3.0);
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HomeHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @"HomeHeaderReusableView" forIndexPath :indexPath];
        headerView.viewModel = self.viewModel.homeHeaderReusableVM;
        reusableview = headerView;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *cellArray = [self.viewModel.menuSectionsList objectAtIndex:indexPath.section];
    HomeMenuCellVM *menuCellVM = [cellArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:menuCellVM.segueId sender:menuCellVM];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

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

#pragma mark - getters and setters

- (HomeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [HomeVM new];
    }
    return _viewModel;
}

@end
