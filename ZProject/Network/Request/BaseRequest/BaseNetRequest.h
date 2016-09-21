//
//  BaseNetRequest.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetRequest : NSObject

#pragma mark - 检查网络状态

+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma mark - 请求数据

/**
 *  @brief 请求网络数据
 *
 *  @param method       调用请求方法
 *  @param strUrl       地址字符串
 *  @param parameters   参数
 *  @param returnBlock  返回结果
 *  @param failureBlock 返回错误
 */
+ (void)requestWithHttpMethod:(ZHttpRequestMethod)method
                       strUrl:(NSString *)strUrl
                   parameters:(id)parameters
             returnValueBlock:(ReturnBlock)returnBlock
                 failureBlock:(FailureBlock)failureBlock;

@end
