//
//  BaseNetRequest.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "BaseNetRequest.h"
#import "ZNetworkRequest.h"

@interface BaseNetRequest ()

@end

@implementation BaseNetRequest

- (NSString *)encodeToPercentEscapeString:(NSString *)string
{
    NSString
    *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( NULL,
    /* allocator */(__bridge CFStringRef)string, NULL, /* charactersToLeaveUnescaped */ (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return  outputStr;
}

- (NSString *)toJSONStringWithArray:(NSArray *)array {
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    
    if (data == nil) { return nil; }
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

@end
