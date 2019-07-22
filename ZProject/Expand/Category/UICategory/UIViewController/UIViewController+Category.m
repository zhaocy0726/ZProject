//
//  UIViewController+Category.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController(Category)

- (void)pushToViewControllerWithClassName:(NSString *)className
{
    if (className != nil) {
        UIViewController *viewController = [[NSClassFromString(className) alloc] init];
        @try {
            if (viewController) {
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                NSLog(@"跳转异常: %@ 不存在", className);
            }
        }
        @catch (NSException *exception) {
            @throw exception;
            // 捕获到的异常exception
            NSLog(@"异常：%s\n%@", __FUNCTION__, exception);
        }
        @finally {
           
        }
    }
}

#pragma mark - 获取当前最顶端 viewController

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:self];//[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)popToViewControllerWithController:(Class)controller completionBlock:(void (^)(void))completeBlock
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:controller]) {
            completeBlock();
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

@end
