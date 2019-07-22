//
//  NSObject+Category.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "NSObject+Category.h"
//#import "SSKeychain.h"

@implementation NSObject(Category)


- (NSNumber *)floatToNumber:(CGFloat)floatNumber
{
    // 取两位小数
    NSString *strFloat = [NSString stringWithFormat:@"%.2f", floatNumber];
    NSNumberFormatter *numf = [[NSNumberFormatter alloc] init];
    NSNumber *numTemp = [numf numberFromString:strFloat];
    return numTemp;
}

#pragma mark - 获取与设置设备唯一标识符

- (void)deviceUUID
{
//    NSString *service = @"com.retech.xxx";
//    NSString *account = @"uuid";
//    NSString *cacheUUID = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_UUID]; // 缓存中的uuid
//    NSString *keyUUID   = [SSKeychain passwordForService:service account:account];                // 钥匙串的uuid
//    /**
//     缓存中查看是否有uuid
//     1.没有uuid: 到钥匙串中查看是否有uuid
//     1.1 有uuid: 取出uuid, 保存到缓存中
//     1.2 没有uuid: 创建uuid, 保存到钥匙串并保存到缓存中
//     2.有uuid: 无操作
//     */
//    if (cacheUUID == nil || [cacheUUID empty]) {
//        if (keyUUID == nil || [keyUUID empty]) {
//            NSString *uuid = [NSUUID UUID].UUIDString;
//            [SSKeychain setPassword:uuid forService:service account:account];
//            [[CacheDataSource sharedInstance] setCache:uuid withCacheKey:CacheKey_UUID];
//        }
//        else {
//            [[CacheDataSource sharedInstance] setCache:keyUUID withCacheKey:CacheKey_UUID];
//        }
//    }
}

#pragma mark - 获取当前最上层控制器

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for (UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal) {
//                NSLog(@"normal window %@ \nlast %@", tmpWin, [windows lastObject]);
//                window = tmpWin;
//                break;
//            }
//        }
//    }
    
    if ([window subviews].count > 0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            result = nextResponder;
        else
            result = window.rootViewController;
    } else {
        result = window.rootViewController;
    }

    return result;
}

- (NSDateComponents *)compareDateWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate unit:(NSCalendarUnit)unit
{
    // 利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 比较的结果是NSDateComponents类对象
    NSDateComponents *dateComponents = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    return dateComponents;
}

@end
