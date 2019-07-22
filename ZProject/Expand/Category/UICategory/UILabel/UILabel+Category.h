//
//  UILabel+Category.h
//  youbei
//
//  Created by 赵春阳 on 2019/1/25.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel (Category)

// 两端对齐 // 使用前需要确定 frame 与 text
- (void)textAlignmentLeftAndRight;

// 指定Label以最后的冒号对齐的width两端对齐 // 使用前需要确定 frame 与 text
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;

- (void)text:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font;

@end

