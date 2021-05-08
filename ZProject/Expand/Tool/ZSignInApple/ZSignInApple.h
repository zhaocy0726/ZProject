//
//  ZSignInApple.h
//  VocationalEducation_NY
//
//  Created by zhao on 2021/5/8.
//  Copyright © 2021 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(NSString *userIdentifier);
typedef void(^FailureBlock)(NSString *errorMessage);

@interface ZSignInApple : NSObject

/// 初始化单例
+ (instancetype)shareInstance;

/// 苹果登录
/// @param success 苹果登录授权成功并返回信息
/// @param failure 苹果登录授权失败
+ (void)signInAppleSuccess:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)signInAppleSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/// 检查苹果登录信息是否失效
- (void)checkSignInAppleExpired:(void(^)(BOOL expired))completion;

@end

NS_ASSUME_NONNULL_END
