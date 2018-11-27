//
//  LoginChooseVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/11/14.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "LoginChooseVM.h"

@implementation LoginChooseVM

- (void)initializeData {
    
}

- (BOOL)shouldShowRegisterViewController {
    NSString *code = [UIPasteboard generalPasteboard].string;
    if ([self isInviteCode:code]) {
        return YES;
    }
    return NO;
}

- (BOOL)isInviteCode:(NSString*)str {
    NSString *resultStr = [self subStringComponentsSeparatedByStrContent:str strPoint:@"Ʊ" firstFlag:1 secondFlag:2];
    if (resultStr.length > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)subStringComponentsSeparatedByStrContent:(NSString *)strContent strPoint:(NSString *)strPoint firstFlag:(int)firstFlag secondFlag:(int)secondFlag {
    NSInteger scount = [[strContent mutableCopy] replaceOccurrencesOfString:@"Ʊ" // 要查询的字符串中的某个字符
                                                                 withString:@"Ʊ"
                                                                    options:NSLiteralSearch
                                                                      range:NSMakeRange(0, [strContent length])];
    
    if (scount != 2) {
        return @"";
    }
    
    // 初始化一个起始位置和结束位置
    NSRange startRange = NSMakeRange(0, 1);
    NSRange endRange = NSMakeRange(0, 1);
    
    // 获取传入的字符串的长度
    NSInteger strLength = [strContent length];
    // 初始化一个临时字符串变量
    NSString *temp = nil;
    // 标记一下找到的同一个字符的次数
    int count = 0;
    // 开始循环遍历传入的字符串，找寻和传入的 strPoint 一样的字符
    for(int i = 0; i < strLength; i++)
    {
        // 截取字符串中的每一个字符,赋值给临时变量字符串
        temp = [strContent substringWithRange:NSMakeRange(i, 1)];
        // 判断临时字符串和传入的参数字符串是否一样
        if ([temp isEqualToString:strPoint]) {
            // 遍历到的相同字符引用计数+1
            count++;
            if (firstFlag == count)
            {
                // 遍历字符串，第一次遍历到和传入的字符一样的字符
                // 将第一次遍历到的相同字符的位置，赋值给起始截取的位置
                startRange = NSMakeRange(i, 1);
            }
            else if (secondFlag == count)
            {
                // 遍历字符串，第二次遍历到和传入的字符一样的字符
                // 将第二次遍历到的相同字符的位置，赋值给结束截取的位置
                endRange = NSMakeRange(i, i);
            }
        }
    }
    // 根据起始位置和结束位置，截取相同字符之间的字符串的范围
    NSRange rangeMessage = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    // 根据得到的截取范围，截取想要的字符串，赋值给结果字符串
    NSString *result = [strContent substringWithRange:rangeMessage];
    // 打印一下截取到的字符串，看看是否是想要的结果
    // 最后将结果返回出去
    return result;
}

@end
