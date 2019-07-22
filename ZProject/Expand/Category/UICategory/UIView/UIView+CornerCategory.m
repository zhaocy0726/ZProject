//
//  UIView+CornerCategory.m
//  youbei
//
//  Created by 赵春阳 on 2018/10/15.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "UIView+CornerCategory.h"

@implementation UIView(CornerCategory)

- (void)drawTopRoundedRectPathWithView:(UIView *)view 
{
    // 创建带圆角的矩形  圆角半径：10
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(view.x, view.y, view.width, view.height) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    
    // 创建可以指定圆角位置的矩形
    // 第一个参数一样是传了个矩形
    // 第二个参数是指定在哪个方向画圆角
    // 第三个参数是一个CGSize类型，用来指定水平和垂直方向的半径的大小
    
    //配置属性
    [[UIColor whiteColor] setFill];              // 设置填充颜色
    [[UIColor whiteColor] setStroke];            // 设置描边颜色
    path.lineWidth = .5f;                        // 设置线宽
    [path closePath];                            // 封闭图形
    
    //渲染
    [path stroke];
    [path fill];
}

/**
 绘制左下角右下角圆角的封闭框
 
 @param view 要绘制边框的view
 */
- (void)drawBottomRoundedRectPathWithView:(UIView *)view
{
    // 创建带圆角的矩形  圆角半径：10
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(view.x, view.y, view.width, view.height) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    
    // 创建可以指定圆角位置的矩形
    // 第一个参数一样是传了个矩形
    // 第二个参数是指定在哪个方向画圆角
    // 第三个参数是一个CGSize类型，用来指定水平和垂直方向的半径的大小
    
    //配置属性
    [[UIColor whiteColor] setFill];              // 设置填充颜色
    [[UIColor whiteColor] setStroke];            // 设置描边颜色
    path.lineWidth = .5f;                        // 设置线宽
    [path closePath];                            // 封闭图形
    
    //渲染
    [path stroke];
    [path fill];
}

- (void)clipCornerWithRadii:(CGFloat)radii corners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.x, self.y, self.width, self.height) byRoundingCorners:corners cornerRadii:CGSizeMake(radii, radii)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/**
 设置阴影
 
 @param shadowColor 阴影颜色
 @param shadowOffset 偏移量
 @param shadowOpacity 透明度 
 @param shadowRadius 渐变读
 */
- (void)setShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(float)shadowRadius{
    // 颜色
    self.layer.shadowColor = shadowColor.CGColor;
    // offset
    self.layer.shadowOffset = shadowOffset;
    // 透明度
    self.layer.shadowOpacity = shadowOpacity;
    // 阴影渐变
    self.layer.shadowRadius = shadowRadius;
    
}

@end
