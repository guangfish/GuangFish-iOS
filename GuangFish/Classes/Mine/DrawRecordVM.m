//
//  DrawRecordVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/17.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "DrawRecordVM.h"
#import "GuangfishDrawRecordAPIManager.h"
#import "DrawRecordReformer.h"

@interface DrawRecordVM()<GuangfishAPIManagerCallBackDelegate, GuangfishAPIManagerParamSource>

@property (nonatomic, strong) GuangfishDrawRecordAPIManager *drawRecordAPIManager;
@property (nonatomic, strong) DrawRecordReformer *drawRecordReformer;
@property (nonatomic, assign) NSInteger page;

@end

@implementation DrawRecordVM

- (void)initializeData {
    self.requestGetDrawRecordSignal = [RACSubject subject];
    self.page = 1;
}

#pragma mark - GuangfishAPIManagerParamSource

- (NSDictionary*)paramsForApi:(GuangfishAPIBaseManager *)manager {
    NSDictionary *params = @{};
    if (self.drawRecordAPIManager == manager) {
        params = @{
                   kDrawRecordAPIManagerParamsKeyPageNo: [NSNumber numberWithInteger:self.page],
                   kDrawRecordAPIManagerParamsKeySize: @30
                   };
    }
    return params;
}

#pragma mark - GuangfishAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(GuangfishAPIBaseManager *)manager {
    if (manager == self.drawRecordAPIManager) {
        self.page ++;
        NSDictionary *resultDic = [manager fetchDataWithReformer:self.drawRecordReformer];
        if ([[resultDic objectForKey:kDrawRecordDataKeyPage] isEqualToNumber:@1]) {
            [self.drawRecordCellVMList removeAllObjects];
        }
        [self.drawRecordCellVMList addObjectsFromArray:[resultDic objectForKey:kDrawRecordDataKeyDrawRecordCellVMList]];
        self.haveMore = [resultDic objectForKey:kDrawRecordDataKeyHaveMorePage];
        [self.requestGetDrawRecordSignal sendNext:@""];
    }
}

- (void)managerCallAPIDidFailed:(GuangfishAPIBaseManager *)manager {
    if (manager == self.drawRecordAPIManager) {
        [self.requestGetDrawRecordSignal sendNext:manager.managerError];
    }
}

#pragma mark - public methods

- (void)reloadDrawRecordList {
    self.page = 1;
    [self loadNextPageDrawRecordList];
}

- (void)loadNextPageDrawRecordList {
    [self.drawRecordAPIManager loadData];
}

#pragma mark - setters and getters

- (GuangfishDrawRecordAPIManager*)drawRecordAPIManager {
    if (_drawRecordAPIManager == nil) {
        self.drawRecordAPIManager = [[GuangfishDrawRecordAPIManager alloc] init];
        self.drawRecordAPIManager.delegate = self;
        self.drawRecordAPIManager.paramSource = self;
    }
    return _drawRecordAPIManager;
}

- (DrawRecordReformer*)drawRecordReformer {
    if (_drawRecordReformer == nil) {
        self.drawRecordReformer = [[DrawRecordReformer alloc] init];
    }
    return _drawRecordReformer;
}

- (NSMutableArray*)drawRecordCellVMList {
    if (_drawRecordCellVMList == nil) {
        self.drawRecordCellVMList = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _drawRecordCellVMList;
}

@end
