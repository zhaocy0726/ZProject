//
//  ZSignInApple.m
//  VocationalEducation_NY
//
//  Created by zhao on 2021/5/8.
//  Copyright © 2021 赵春阳. All rights reserved.
//

#import "ZSignInApple.h"

#import <AuthenticationServices/AuthenticationServices.h> // 苹果登录
#import <SSKeychain/SSKeychain.h>

#define kKeyChainService NSBundle.mainBundle.bundleIdentifier
#define kKeyChainAccount @"SignInAppleUserIdentifier"

API_AVAILABLE(ios(13.0))
@interface ZSignInApple ()
<
ASAuthorizationControllerDelegate,  // 苹果登录处理数据回调
ASAuthorizationControllerPresentationContextProviding // 苹果登录设置上下文，管理视图弹出在哪里
>

@property (copy, nonatomic) SuccessBlock success; // 授权成功
@property (copy, nonatomic) FailureBlock failure; // 授权失败

@end

API_AVAILABLE(ios(13.0))
@implementation ZSignInApple

+ (instancetype)shareInstance
{
    static ZSignInApple *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!instance) {
            instance = [[ZSignInApple alloc] init];
        }
    });
    return instance;
}

+ (void)signInAppleSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self shareInstance] signInAppleSuccess:success failure:failure];
}

- (void)signInAppleSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    if (success) self.success = success;
    if (failure) self.failure = failure;
    
    [self performExistingAccountSetupFlows];
}

/// MARK: 创建授权请求
- (void)creatAuthorizationRequest
{
    // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
    ASAuthorizationAppleIDRequest *request = [ASAuthorizationAppleIDProvider.new createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    
    // 管理授权请求的控制器
    ASAuthorizationController *auth = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    auth.delegate = self;
    auth.presentationContextProvider = self;
    // 启动授权
    [auth performRequests];
}

/// MARK: 执行现有的授权请求
- (void)performExistingAccountSetupFlows
{
    // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
    ASAuthorizationAppleIDRequest *idRequest = [ASAuthorizationAppleIDProvider.new createRequest];

    // 为了执行钥匙串凭证分享生成请求的一种机制
    ASAuthorizationPasswordRequest *passwordRequest = [ASAuthorizationPasswordProvider.new createRequest];

    // 管理授权请求的控制器
    ASAuthorizationController *auth = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[idRequest, passwordRequest]];
    auth.delegate = self;
    auth.presentationContextProvider = self;
    // 启动授权
    [auth performRequests];
}

#pragma mark - ASAuthorizationControllerDelegate

/// 苹果登录授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
{
    // 苹果用户唯一标识符
    NSString *userIdentifier;
    
    // 首次授权登录 !!!注意：第二次登录的时候不会返回所有数据，只返回了user，所以需要根据这个userIdentifier查询存储在服务器的完整用户信息
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *apple = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        userIdentifier = apple.user;
        NSPersonNameComponents *fullName = apple.fullName;
        NSString *email = apple.email;
        // 给后台向苹果服务器验证使用，有效时间五分钟。
        NSString *authorizationCode = [[NSString alloc] initWithData:apple.authorizationCode encoding:NSUTF8StringEncoding];
        // 给后台向苹果服务器验证使用
        NSString *identityToken = [[NSString alloc] initWithData:apple.identityToken encoding:NSUTF8StringEncoding];
        // 用于判断当前登录的苹果账号是否是一个真实用户
        ASUserDetectionStatus realUserStatus = apple.realUserStatus;
        
        [SSKeychain setPassword:userIdentifier forService:kKeyChainService account:kKeyChainAccount];
        
        NSLog(@"\n==Sign in with apple== \
              \n userIdentifier: %@ \
              \n fullName: %@ \
              \n email: %@ \
              \n authorizationCode: %@ \
              \n identityToken: %@ \
              \n realUserStatus: %@",
              userIdentifier, fullName, email, authorizationCode, identityToken, @(realUserStatus));
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        
        // Sign in using an existing iCloud Keychain credential.
        ASPasswordCredential *pass = (ASPasswordCredential *)authorization.credential;
        userIdentifier = pass.user;
        NSString *password = pass.password;
        NSLog(@"\n==sign in with password==: \nusername: %@\n password: %@", userIdentifier, password);
        
        if (userIdentifier) !self.success ?: self.success(userIdentifier);
    }
    if (userIdentifier) {
        !self.success ?: self.success(userIdentifier);
    } else {
        !self.failure ?: self.failure(@"未能获取到用户信息");
    }
}

/// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
{
    NSString * errorMsg;
    switch(error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown: {
            [self creatAuthorizationRequest];
        }
            break;
        default:
            errorMsg = @"未知错误";
            break;
    }
    !self.failure ?: self.failure(errorMsg);
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding

/// 苹果登录授权界面展示在哪里
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
{
    return UIApplication.sharedApplication.keyWindow;
}

#pragma mark - 授权检测

- (void)checkSignInAppleExpired:(void(^)(BOOL expired))completion
{
    if (@available(iOS 13.0, *)) {
        NSString *userIdentifier = [SSKeychain passwordForService:kKeyChainService account:kKeyChainAccount];
        if (!userIdentifier) return;
        
        ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
        [provider getCredentialStateForUserID:userIdentifier completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialRevoked: // 用户重新登录了其他的apple id
                case ASAuthorizationAppleIDProviderCredentialNotFound: // userid apple id 登录找不到
                {
                    [self alertUserInfoExpired];
                    completion(YES);
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

// 提示用户信息过期
- (void)alertUserInfoExpired
{
    [SSKeychain deletePasswordForService:kKeyChainService account:kKeyChainAccount];
    
    NSString *title = @"登录已过期";
    NSString *message = @"您的登录状态已过期，请重新登录";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:sureAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:^{}];
    });
}

@end
