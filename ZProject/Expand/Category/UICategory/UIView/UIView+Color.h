//
//  UIView+Color.h
//  youbei
//
//  Created by 赵春阳 on 2019/2/25.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Color)

//获取图片某一点的颜色
- (UIColor *)colorAtPixel:(CGPoint)pixel image:(UIImage *)image;

@end
