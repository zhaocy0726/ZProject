//
//  UIView+CornerCategory.h
//  youbei
//
//  Created by 赵春阳 on 2018/10/15.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(CornerCategory)

/**
 绘制左上角右上角圆角的封闭框
 
 @param view 要绘制边框的view
 */
- (void)drawTopRoundedRectPathWithView:(UIView *)view;

/**
 绘制左下角右下角圆角的封闭框
 
 @param view 要绘制边框的view
 */
- (void)drawBottomRoundedRectPathWithView:(UIView *)view;

/**
 切圆角

 @param radii 半径
 @param corners 切的角
 */
- (void)clipCornerWithRadii:(CGFloat)radii corners:(UIRectCorner)corners;

/**
 设置阴影
 
 @param shadowColor 阴影颜色 默认 black
 @param shadowOffset 偏移量 默认[0, -3]
 @param shadowOpacity 透明度 默认 0 范围[0,1]
 @param shadowRadius 渐变读 默认 3
 */
- (void)setShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(float)shadowRadius;

@end

NS_ASSUME_NONNULL_END
