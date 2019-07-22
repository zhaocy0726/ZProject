//
//  ZNetworkReuest.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "ZNetworkRequest.h"

#import <arpa/inet.h> // 检查网络状态

/** 将 ZHttpRequestMethod 转换成 AFURLRequestSerialization 类中参数 method 用到的 string 类型参数 */
NSString *ZHttpRequestMethodString (ENUM_ZHttpRequestMethod method)
{
    NSString *strMethod = @"";
    switch (method) {
        case ENUM_ZHttpRequestMethodGet: {
            strMethod = @"GET";
            break;
        }
        case ENUM_ZHttpRequestMethodPost: {
            strMethod = @"POST";
            break;
        }
        case ENUM_ZHttpRequestMethodPut: {
            strMethod = @"PUT";
            break;
        }
        case ENUM_ZHttpRequestMethodDelete: {
            strMethod = @"DELETE";
            break;
        }
    }
    return strMethod;
}

@interface ZNetworkRequest ()<NSURLSessionDelegate>

@property (strong,nonatomic) AFHTTPSessionManager *manager;

@end

@implementation ZNetworkRequest

+ (instancetype)shareInstance
{
    static ZNetworkRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[ZNetworkRequest alloc] init];
    });
    
    return request;
}

#pragma mark - 检查网络状态

+ (BOOL)netWorkReachabilityWithURLString:(NSString *) strUrl
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

/// 服务器可达返回true (https://www.jianshu.com/p/e96bfde21313)
+ (BOOL)socketReachability {
    // 客户端 AF_INET:ipv4  SOCK_STREAM:TCP链接
    int socketNumber = socket(AF_INET, SOCK_STREAM, 0);
    // 配置服务器端套接字
    struct sockaddr_in serverAddress;
    // 设置服务器ipv4
    serverAddress.sin_family = AF_INET;
    // 百度的ip
    serverAddress.sin_addr.s_addr = inet_addr("202.108.22.5");
    // 设置端口号，HTTP默认80端口
    serverAddress.sin_port = htons(80);
    if (connect(socketNumber, (const struct sockaddr *)&serverAddress, sizeof(serverAddress)) == 0) {
        close(socketNumber);
        return true;
    }
    close(socketNumber);;
    return false;
}

#pragma mark - 请求数据


/**
 GET请求
 
 @param url 链接
 @param parameters 参数
 @param completeBlock 回调
 */
- (void)getWithUrl:(NSString *)url
        parameters:(id)parameters
     completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    [self requestWithHttpMethod:ENUM_ZHttpRequestMethodGet url:url parameters:parameters completeBlock:completeBlock];
}

/**
 *  @brief 请求网络数据(POST)
 *
 *  @param url         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
- (void)postWithUrl:(NSString *)url
         parameters:(id)parameters
      completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    [self requestWithHttpMethod:ENUM_ZHttpRequestMethodPost url:url parameters:parameters completeBlock:completeBlock];
}

/**
 *  @brief 请求网络数据(DELETE)
 *
 *  @param url         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
- (void)deleteWithUrl:(NSString *)url
           parameters:(id)parameters
        completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    [self requestWithHttpMethod:ENUM_ZHttpRequestMethodDelete url:url parameters:parameters completeBlock:completeBlock];
}

/**
 *  @brief 请求网络数据(PUT)
 *
 *  @param url         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
- (void)putWithUrl:(NSString *)url
        parameters:(id)parameters
     completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    [self requestWithHttpMethod:ENUM_ZHttpRequestMethodPut url:url parameters:parameters completeBlock:completeBlock];
}

- (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                          url:(NSString *)url
                   parameters:(id)parameters
                completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    [self requestWithHttpMethod:method url:url parameters:parameters header:nil completeBlock:completeBlock];
}

- (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                          url:(NSString *)url
                   parameters:(id)parameters
                       header:(NSDictionary *)header
                completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    [self requestWithHttpMethod:method url:url parameters:parameters header:header uploadProgress:nil downloadProgress:nil completeBlock:completeBlock];
}

- (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                          url:(NSString *)url
                   parameters:(id)parameters
                       header:(NSDictionary *)header
               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    // 数据加密
    //    NSString *encryptParams = [ZAES AES128EncryptStrig:parameters];
    //    NSLog(@"=====parameters %@", encryptParams);
    // 拼链接
    url = [AppServerBaseURL stringByAppendingString:[NSString stringWithFormat:@"%@",url]];
    
    if ([url isContainChinese]) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
    NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:ZHttpRequestMethodString(method) URLString:url parameters:parameters error:nil];
    
    NSLog(@"HTTPRequestHeaders: %@",self.manager.requestSerializer.HTTPRequestHeaders);
    
    if (header) {
        NSArray *arrHeaderKeyValue = [header allKeys];
        for (int i = 0; i < arrHeaderKeyValue.count; i++) {
            //根据键值处理字典中的每一项
            NSString *key = arrHeaderKeyValue[i];
            NSString *value = header[key];
            [request setValue:value forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionDataTask *dataTask = [[AFHTTPSessionManager manager] dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self errorWithError:error method:ZHttpRequestMethodString(method) object:responseObject url:url parameters:parameters completeBlock:completeBlock];
        } else {
            [self responseWithResponseObject:responseObject method:ZHttpRequestMethodString(method) url:url parameters:parameters completeBlock:completeBlock];
            
        }
    }];
    [dataTask resume];
}

/** 接口报错处理 */
- (void)errorWithError:(NSError *)error
                method:(NSString *)method
                object:(id)object
                   url:(NSString *)url
            parameters:(id)parameters
         completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    ZErrorModel *customError = [ZErrorModel new];
    customError.code = [object[@"status"] integerValue];
    if (object[@"message"] && [object[@"message"] length] > 0) {
        customError.message = object[@"message"];
    } else {
        customError.message = error.userInfo[@"NSLocalizedDescription"];
    }
    NSLog(@"接口地址:%@,\n 请求方式:%@\n 接口参数:%@,\n 接口错误:%@", url, method, parameters, customError.message);
    completeBlock(nil, customError);
}

/** 接口正常处理 */
- (void)responseWithResponseObject:(id)responseObject
                            method:(NSString *)method
                               url:(NSString *)url
                        parameters:(id)parameters
                     completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    if (responseObject == nil) { // 防止数据丢失
        ZErrorModel *customError = [ZErrorModel new];
        customError.code = 1;
        customError.message = @"网络连接失败";
        completeBlock(nil, customError);
    }
    
    NSInteger resultCode = [[responseObject objectForKey:@"status"] integerValue];
    NSString *resultMsg  = [responseObject objectForKey:@"message"];
    if (resultCode == 200) {
        NSString *returnJson = [responseObject objectForKey:@"data"];
        NSLog(@"接口地址:%@,\n 请求方式:%@\n 接口参数:%@,\n 返回结果:%@", url, method, parameters, returnJson);
        // 数据解密
        //        NSString *blockJson = [ZAES AES128DecryptString:returnJson];
        NSDictionary *returnObject = [returnJson mj_JSONObject];
        if (returnObject) {
            completeBlock(returnObject, nil);
        } else {
            completeBlock(returnJson, nil);
        }
    } else {   // 错误
        ZErrorModel *customError = [ZErrorModel new];
        customError.code = resultCode;
        customError.message = resultMsg;
        if (resultCode == 3) { // 登录异常, 踢掉账号
            NSLog(@"接口地址:%@,\n 请求方式:%@\n 接口参数:%@,\n 接口错误:%@", url, method, parameters, @"其他机器登录");
            [self fk_postNotification:kNotification_SignoutWithOtherLogin];
            completeBlock(nil, nil);
        } else {
            NSLog(@"接口地址:%@,\n 请求方式:%@\n 接口参数:%@,\n 接口错误:%@", url, method, parameters, customError.message);
            completeBlock([responseObject objectForKey:@"data"], customError);
        }
    }
}

#pragma mark - 上传图片

- (void)uploadFileWithFile:(NSData *)file fileName:(NSString *)fileName type:(ENUM_UploadFileType)type fileType:(NSString *)fileType completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock
{
    [self taskUploadFileWithFile:file fileName:fileName type:type fileType:fileType completeBlock:completeBlock];
    
}

- (NSURLSessionDataTask *)taskUploadFileWithFile:(NSData *)file fileName:(NSString *)fileName type:(ENUM_UploadFileType)type fileType:(NSString *)fileType completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock{
    
    NSString *bucketName = [self bucketNameWithType:type completeBlock:completeBlock];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:bucketName forKey:@"bucketName"];
    
    NSString *url = [AppServerBaseURL stringByAppendingString:[NSString stringWithFormat:@"%@", PATH_UPLOAD_FILE]];
    
    AFHTTPSessionManager *manager = self.manager;
    
    return [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        /// for循环内，毫秒有可能相同，无法区分，需重命名
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        
        // TODO: 修改 userId 为具体数据
        NSString *filename = [NSString stringWithFormat:@"%@_%@_%@", dateString, @"userId",fileName];
        
        /* 上传数据拼接 */
        if (fileType.length == 0) {
            [formData appendPartWithFileData:file name:@"file" fileName:filename mimeType:@"image/jpeg"];
        } else {
            [formData appendPartWithFileData:file name:@"file" fileName:filename mimeType:fileType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"task.state: %zd",task.state);
        [self responseWithResponseObject:responseObject method:@"上传图片" url:url parameters:parameter completeBlock:completeBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorWithError:error method:@"上传图片" object:nil url:url parameters:parameter completeBlock:completeBlock];
    }];
}

- (NSURLSessionDataTask *)uploadBarchObjectWithArray:(NSArray *)array type:(ENUM_UploadFileType)type fileType:(NSString *)fileType completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock{
    //    PATH_UPLOAD_BATCH_FILE
    NSString *bucketName = [self bucketNameWithType:type completeBlock:completeBlock];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:bucketName forKey:@"bucketName"];
    
    NSString *url = [AppServerBaseURL stringByAppendingString:[NSString stringWithFormat:@"%@",PATH_UPLOAD_BATCH_FILE]];
    
    AFHTTPSessionManager *manager = self.manager;
    
    if (fileType.length == 0) {
        fileType = kUploadFileTypeImageJpeg;
    }
    
    return [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSInteger imgCount = 0;
        
        for (NSData *imageData in array) {
            
            // 文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            // TODO: 修改 userId 为具体数据
            NSString *filename = [NSString stringWithFormat:@"%@_%@_%ld", dateString, @"userId", imgCount];
            
            [formData appendPartWithFileData:imageData name:@"files" fileName:filename mimeType:fileType];
            
            imgCount++;
            
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"progress_%@", uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"upload_batch: %@",responseObject);
        
        [self responseWithResponseObject:responseObject method:@"上传图片" url:url parameters:parameter completeBlock:completeBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"upload_batch_error: %@",error);
        [self errorWithError:error method:@"上传图片" object:nil url:url parameters:parameter completeBlock:completeBlock];
    }];
}


- (NSString *)bucketNameWithType:(ENUM_UploadFileType)type completeBlock:(void (^)(id responseObject, ZErrorModel *error))completeBlock{
    if (type == ENUM_UploadFileTypeImage) {
        return  @"IMAGE";
    } else if (type == ENUM_UploadFileTypeVideo) {
        return  @"VIDEO";
    } else {
        ZErrorModel *error = [ZErrorModel new];
        error.code = 400;
        error.message = @"本地报错：没有选择正确的存储桶, 先添加正确的类型并选择后再上传";
        completeBlock(nil, error);
        return nil;
    }
}

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}



@end
