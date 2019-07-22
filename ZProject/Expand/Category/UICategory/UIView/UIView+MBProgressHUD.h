//
//  UIView+MBProgressHUD.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#pragma mark - UIView

@interface UIView (MBProgressHUD)

- (MBProgressHUD *)presentMessageTips:(NSString *)message;
//- (MBProgressHUD *)presentSuccessTips:(NSString *)message;
//- (MBProgressHUD *)presentFailureTips:(NSString *)message;
- (MBProgressHUD *)presentLoadingTips:(NSString *)message;
- (MBProgressHUD *)showTips:(NSString *)message autoHide:(BOOL)autoHide;
- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide; // 向上偏移50高度

- (MBProgressHUD *)showWaitTips; // 转菊花等待

- (void)dismissTips;

@end

#pragma mark - UIViewController

@interface UIViewController (MBProgressHUD)

- (MBProgressHUD *)presentMessageTips:(NSString *)message;
- (MBProgressHUD *)presentLoadingTips:(NSString *)message;
- (MBProgressHUD *)showTips:(NSString *)message autoHide:(BOOL)autoHide;
- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide;

- (MBProgressHUD *)showWaitTips; // 转菊花等待
- (void)dismissTips;

- (void)presentStandaloneMessageTips:(NSString *)message; // 展现一个独立的提示框, 不会被dismiss干掉

@end
