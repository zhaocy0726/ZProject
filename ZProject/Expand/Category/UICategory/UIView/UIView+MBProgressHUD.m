//
//  UIView+MBProgressHUD.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIView+MBProgressHUD.h"

__weak MBProgressHUD * _sharedHud;

static CGFloat const kDelay = 1.5f; // 提示框延期消失时间

@implementation UIView (MBProgressHUD)

- (MBProgressHUD *)showTips:(NSString *)message autoHide:(BOOL)autoHide
{
    UIView * container = self;
    
    if ( container ) {
        if ( nil != _sharedHud ) {
            [_sharedHud hideAnimated:NO];
        }
        
        UIView * view = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        _sharedHud = hud;
        
        
        if (autoHide) {
            [hud hideAnimated:YES afterDelay:kDelay];
        } else {
            hud.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTips)];
            [hud addGestureRecognizer:tap];
        }
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)presentMessageTips:(NSString *)message
{
    return [self showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentSuccessTips:(NSString *)message
{
    return [self showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentFailureTips:(NSString *)message
{
    return [self showTips:message autoHide:YES];
}

- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide
{
    UIView * container = self;
    
    if ( container ) {
        if ( nil != _sharedHud ) {
            [_sharedHud hideAnimated:NO];
        }
        
        UIView * view = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        hud.offset = CGPointMake(hud.offset.x, hud.offset.y - 50);
        _sharedHud = hud;
        
        if ( autoHide )
        {
            [hud hideAnimated:YES afterDelay:kDelay];
        }
    }
    
    return _sharedHud;
}

- (MBProgressHUD *)presentLoadingTips:(NSString *)message
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hideAnimated:NO];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        if (![message empty]) {
            hud.detailsLabel.text = message;
            hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        }
        _sharedHud = hud;
    }
    
    return _sharedHud;
}

- (void)dismissTips
{
    [_sharedHud hideAnimated:YES];
    _sharedHud = nil;
}

- (MBProgressHUD *)showWaitTips;
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != _sharedHud )
        {
            [_sharedHud hideAnimated:NO];
        }
        
        UIView * view = self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        _sharedHud = hud;
    }
    return _sharedHud;
}

@end

@implementation UIViewController (MBProgressHUD)

- (MBProgressHUD *)presentMessageTips:(NSString *)message
{
    return [self.navigationController.view showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentSuccessTips:(NSString *)message
{
    return [self.navigationController.view showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentFailureTips:(NSString *)message
{
    return [self.navigationController.view showTips:message autoHide:YES];
}

- (MBProgressHUD *)presentLoadingTips:(NSString *)message
{
    return [self.navigationController.view presentLoadingTips:message];
}

- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide
{
    return [self.navigationController.view showTipsWithYOffset:message autoHide:autoHide];
}

- (MBProgressHUD *)showTips:(NSString *)message autoHide:(BOOL)autoHide
{
    return [self.navigationController.view showTips:message autoHide:autoHide];
}

- (MBProgressHUD *)showWaitTips // 转菊花等待
{
    return [self.navigationController.view showWaitTips];
}

- (void)dismissTips
{
    [self.navigationController.view dismissTips];
}

- (void)presentStandaloneMessageTips:(NSString *)message
{
    UIView *view = self.navigationController.view ? self.navigationController.view : self.view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.detailsLabel.text = message;
    [hud hideAnimated:YES afterDelay:1.5f];
}

@end
