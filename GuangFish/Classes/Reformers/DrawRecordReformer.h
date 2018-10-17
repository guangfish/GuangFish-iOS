//
//  DrawRecordReformer.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/17.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishDrawRecordAPIManager.h"
#import "DrawRecordCellVM.h"

extern NSString * const kDrawRecordDataKeyHaveMorePage;
extern NSString * const kDrawRecordDataKeyPage;
extern NSString * const kDrawRecordDataKeyDrawRecordCellVMList;

@interface DrawRecordReformer : NSObject<GuangfishAPIManagerDataReformer>

@end
