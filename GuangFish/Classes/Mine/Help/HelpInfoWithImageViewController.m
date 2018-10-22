//
//  HelpInfoWithImageViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoWithImageViewController.h"
#import "HelpInfoWithImageCell.h"

@interface HelpInfoWithImageViewController ()

@end

@implementation HelpInfoWithImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
    
    [self.viewModel getInfo];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.infoCellVMList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpInfoWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpInfoWithImageCell" forIndexPath:indexPath];
    
    HelpInfoWithImageCellVM *helpInfoWithImageCellVM = [self.viewModel.infoCellVMList objectAtIndex:indexPath.row];
    cell.viewModel = helpInfoWithImageCellVM;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self);
    [self.viewModel.getInfoListSignal subscribeNext:^(id _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - setters and getters

- (HelpInfoWithImageVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HelpInfoWithImageVM alloc] init];
    }
    return _viewModel;
}

@end
