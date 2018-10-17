//
//  DrawRecordVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/17.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "GLViewModel.h"

@interface DrawRecordVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestGetDrawRecordSignal;
@property (nonatomic, strong) NSMutableArray *drawRecordCellVMList;
@property (nonatomic, strong) NSNumber *haveMore;

- (void)reloadDrawRecordList;
- (void)loadNextPageDrawRecordList;

@end
