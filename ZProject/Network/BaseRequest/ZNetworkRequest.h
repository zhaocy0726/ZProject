//
//  ZNetworkReuest.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 数据服务器 */
static NSString * const AppServerBaseURL  = @"";

@interface ZNetworkRequest : NSObject

+ (instancetype)shareInstance;

#pragma mark - 检查网络状态

/** 通过外网链接 */
+ (BOOL)socketReachability;
/** 通过 AFN 获取本机联网状态 */
+ (BOOL)netWorkReachabilityWithURLString:(NSString *)strUrl;

#pragma mark - 请求数据

/**
 @brief 请求网络数据(GET)
 
 @param url 链接
 @param parameters 参数
 @param completeBlock 回调
 */
- (void)getWithUrl:(NSString *)url
        parameters:(id)parameters
     completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;

/**
 *  @brief 请求网络数据(POST)
 *
 *  @param url         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
- (void)postWithUrl:(NSString *)url
         parameters:(id)parameters
      completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;

/**
 *  @brief 请求网络数据(DELETE)
 *
 *  @param url         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
- (void)deleteWithUrl:(NSString *)url
           parameters:(id)parameters
        completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;

/**
 *  @brief 请求网络数据(PUT)
 *
 *  @param url         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
- (void)putWithUrl:(NSString *)url
        parameters:(id)parameters
     completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;

/**
 *  @brief 请求网络数据
 *
 *  @param method         调用请求方法
 *  @param url            地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
- (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                          url:(NSString *)url
                   parameters:(id)parameters
                completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;


/**
 *  @brief 请求网络数据(带header)
 *
 *  @param method         调用请求方法
 *  @param url            地址字符串
 *  @param parameters     参数
 *  @param header         请求头
 *  @param completeBlock  返回结果
 */
- (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                          url:(NSString *)url
                   parameters:(id)parameters
                       header:(NSDictionary *)header
                completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;

/**
 *  @brief 请求网络数据(带header/uploadProgress/downloadProgress)
 *
 *  @param method                调用请求方法
 *  @param url                   地址字符串
 *  @param parameters            参数
 *  @param header                请求头
 *  @param uploadProgressBlock   上传进度
 *  @param downloadProgressBlock 下载进度
 *  @param completeBlock         返回结果
 */
- (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                          url:(NSString *)url
                   parameters:(id)parameters
                       header:(NSDictionary *)header
               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;


#pragma mark - 上传图片

/**
 上传文件到服务器(AF)
 
 @param file 文件数据
 @param type 文件存放的存储桶，只能选择已确定的枚举值代表的存储桶
 @param fileType 文件类型，nil 默认 image/jpeg 格式
 @param completeBlock 回调
 */
- (void)uploadFileWithFile:(NSData *)file
                  fileName:(NSString *)fileName
                      type:(ENUM_UploadFileType)type
                  fileType:(NSString *)fileType
             completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;

- (NSURLSessionDataTask *)taskUploadFileWithFile:(NSData *)file
                                        fileName:(NSString *)fileName
                                            type:(ENUM_UploadFileType)type
                                        fileType:(NSString *)fileType
                                   completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;
/** 多文件上传 */
- (NSURLSessionDataTask *)uploadBarchObjectWithArray:(NSArray *)array
                                                type:(ENUM_UploadFileType)type
                                            fileType:(NSString *)fileType
                                       completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock;

@end
