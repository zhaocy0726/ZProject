//
//  BaseNetRequest.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "BaseNetRequest.h"

/**
 将 ZHttpRequestMethod 转换成 AFURLRequestSerialization 类中
 方法 - (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing *)error
 参数 method 用到的 string 类型参数
 */
NSString *ZHttpRequestMethodString (ZHttpRequestMethod method)
{
    NSString *strMethod = @"";
    switch (method) {
        case ZHttpRequestMethodGet: {
            strMethod = @"GET";
            break;
        }
        case ZHttpRequestMethodPost: {
            strMethod = @"POST";
            break;
        }
        case ZHttpRequestMethodPut: {
            strMethod = @"PUT";
            break;
        }
        case ZHttpRequestMethodPatch: {
            strMethod = @"PATCH";
            break;
        }
        case ZHttpRequestMethodDelete: {
            strMethod = @"DELETE";
            break;
        }
    }
    return strMethod;
}

@interface BaseNetRequest ()

@end

@implementation BaseNetRequest

#pragma mark - 检查网络状态

+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL networkState = NO;
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO]; // 回复队列
                networkState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkState = NO;
            default:
                [operationQueue setSuspended:YES]; // 暂停队列
                break;
        }
        DDLog(@"networkReachabilityStatus: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    return networkState;
}

#pragma mark - 请求数据

+ (void)requestWithHttpMethod:(ZHttpRequestMethod)method
                       strUrl:(NSString *)strUrl
                   parameters:(id)parameters
             returnValueBlock:(ReturnBlock)returnBlock
                 failureBlock:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc] init];
    // 如果没有baseUrl 直接使用绝对地址
    NSMutableURLRequest *request = [httpSessionManager.requestSerializer requestWithMethod:ZHttpRequestMethodString(method) URLString:strUrl parameters:parameters error:nil];
    NSLog(@"接口地址:%@,\n 接口方法:%@,\n 接口参数:%@", strUrl, ZHttpRequestMethodString(method), parameters);
    NSURLSessionDataTask *dataTask = [httpSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failureBlock(error);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                returnBlock(responseObject);
            });
        }
    }];
    [dataTask resume];
}

@end
