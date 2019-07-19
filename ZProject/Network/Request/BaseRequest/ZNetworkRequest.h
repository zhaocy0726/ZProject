//
//  ZNetworkReuest.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNetworkRequest : NSObject

+ (instancetype)shareInstance;

#pragma mark - 检查网络状态

+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma mark - 请求数据

/**
 *  @brief 请求网络数据
 *
 *  @param method         调用请求方法
 *  @param strUrl         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
+ (void)requestWithHttpMethod:(ZHttpRequestMethod)method
                       strUrl:(NSString *)strUrl
                   parameters:(id)parameters
    completeBlock:(void (^)(id responseObject, NSError *error))completeBlock;

@end
