//
//  BaseNavigationView.h
//  ZProject
//
//  Created by zhao on 2019/7/22.
//  Copyright © 2019 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationView : UIView

@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UIButton *btnRightItem;

@property (strong, nonatomic) NSString *title; // 标题
@property (strong, nonatomic) NSString *rightItemTitle; // 右侧按键文字
@property (strong, nonatomic) NSString *rightItemImage; // 右侧按键图片

@property (strong, nonatomic) UIView *containerView;    // 容器

@property (assign, nonatomic) BOOL hiddenLeftItem; // 隐藏左侧返回按键

@property (copy, nonatomic) void (^clickBtnLeftItemBlock)(void); // 点击左侧按键回调

/** 隐藏导航栏 */
@property (assign, nonatomic) BOOL navHidden;

- (void)configViewUI;

- (void)click_btnLeftItem;
- (void)click_btnRightItem;

@end

