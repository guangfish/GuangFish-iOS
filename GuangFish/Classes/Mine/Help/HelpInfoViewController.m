//
//  HelpInfoViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoViewController.h"
#import "HelpInfoCell.h"

@interface HelpInfoViewController ()

@end

@implementation HelpInfoViewController

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
    HelpInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpInfoCell" forIndexPath:indexPath];
    
    HelpInfoCellVM *helpInfoCellVM = [self.viewModel.infoCellVMList objectAtIndex:indexPath.row];
    cell.viewModel = helpInfoCellVM;
    
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

- (HelpInfoVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HelpInfoVM alloc] init];
    }
    return _viewModel;
}

@end
