//
//  TuituikeNetworking.m
//  TuituikeNetworking
//
//  Created by 顾越超 on 2018/4/3.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import "GuangfishNetworking.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

#define USERID @"USERID"
#import <sys/utsname.h>

@interface GuangfishNetworking()

@property (nonatomic, strong) GuangfishAPIUrlConfigManager *guangfishAPIUrlConfigManager;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation GuangfishNetworking

static GuangfishNetworking *sharedManager = nil;

+ (GuangfishNetworking*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
        sharedManager.manager = [AFHTTPSessionManager manager];
        sharedManager.manager.requestSerializer.timeoutInterval = 15.f;
        sharedManager.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedManager.guangfishAPIUrlConfigManager = [GuangfishAPIUrlConfigManager sharedManager];
    });
    return sharedManager;
}

- (NSURLSessionDataTask*)sendPostRequestWithApiName:(NSString*)apiName useUserId:(BOOL)userId withParameters:(NSDictionary*)parameters withPostSuccessBlock:(NetworkingSuccessBlock)postSuccessBlock withPostErrorBlock:(NetworkingErrorBlock)postErrorBlock {
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc] init];
    [paraDict addEntriesFromDictionary:parameters];
    if (userId && ![parameters objectForKey:@"userId"]) {
        [paraDict setObject:self.userId forKey:@"userId"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", self.guangfishAPIUrlConfigManager.apiUrl, apiName];
    
    __weak __typeof(self) weakself = self;
    NSURLSessionDataTask *task = [self.manager POST:urlStr parameters:paraDict progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof(self) strongself = weakself;
        NSDictionary *responseDic = [responseObject objectForKey:@"response"];
        NSLog(@"%@", responseDic);
        if ([responseDic[@"status"] isEqualToString:@"0"]) {
            if ([apiName isEqualToString:API_LoginUrl]) {
                [strongself getUserIdFromResponse:responseDic[@"data"]];
            }
            postSuccessBlock(responseDic);
        } else {
            NSLog(@"error\n url:%@", urlStr);
            NSString *msgStr = [responseDic objectForKey:@"desc"];
            postErrorBlock(GuangfishNetworkingErrorTypeRequestFailed, msgStr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != -999) {   //-999错误码是取消请求
            postErrorBlock(GuangfishNetworkingErrorTypeNetFailed, @"网络不给力啊！");
        }
    }];
    return task;
}

- (void)cleanUserId {
    [self saveUserId:@""];
}

#pragma mark - private methods

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)saveUserId:(NSString*)userId {
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.userId = [[NSUserDefaults standardUserDefaults] valueForKey:USERID];
}

- (void)getUserIdFromResponse:(NSDictionary*)dic {
    if (dic) {
        for (NSString *key in dic) {
            if ([dic[key] isKindOfClass:[NSDictionary class]]) {
                [self getUserIdFromResponse:dic[key]];
            } else if ([key isEqualToString:@"userId"]) {
                [self saveUserId:dic[key]];
            }
        }
    }
}

#pragma mark - getters and setters

- (NSString *)userId {
    if (_userId == nil) {
        _userId = [[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        if (_userId == nil) {
            _userId = @"";
        }
    }
    return _userId;
}

@end
