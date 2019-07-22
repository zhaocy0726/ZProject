//
//  UILabel+Category.m
//  youbei
//
//  Created by 赵春阳 on 2019/1/25.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import "UILabel+Category.h"

#import <CoreText/CoreText.h>

@implementation UILabel(Category)

- (void)textAlignmentLeftAndRight {
    [self textAlignmentLeftAndRightWith:CGRectGetWidth(self.frame)];
}

- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth{
    if (self.text == nil || self.text.length == 0) {
        return;
    }
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:self.font}
                                          context:nil].size;
    NSInteger length = (self.text.length - 1);
    NSString *lastStr = [self.text substringWithRange:NSMakeRange(self.text.length - 1,1)];
    if ([lastStr isEqualToString:@":"] || [lastStr isEqualToString:@"："]) {
        length = (self.text.length - 2);
    }
    CGFloat margin = (labelWidth - size.width)/length;
    
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,length)];

    self.attributedText = attribute;
}

- (void)text:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font{
    self.text       = text;
    self.textColor  = textColor;
    self.font       = [UIFont systemFontOfSize:font];
}

@end
