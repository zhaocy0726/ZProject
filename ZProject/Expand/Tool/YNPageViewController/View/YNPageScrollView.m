//
//  YNPageScrollView.m
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNPageScrollView.h"
#import "UIView+YNPageExtend.h"
#import <objc/runtime.h>

@interface YNPageScrollView () <UIGestureRecognizerDelegate>

@end

@implementation YNPageScrollView
    
// 支持多个手势一起触发方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

// 根据触发点及方向判断是否返回手势
- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {

    // 侧边返回的临界范围:0.15倍的屏宽
    int location_X = 0.15 * kYNPAGE_SCREEN_WIDTH;

    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        // 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。 （0，0点从你下手的地方开始）
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            // 手指在视图上的位置（x,y）就是手指在视图(UIScrollview)本身坐标系的位置。
            CGPoint location = [gestureRecognizer locationInView:self];
            // 由于视图是 UIScrollview, 存在 contentSize (超过一屏幕的存在)
            int temp1 = location.x;
            int temp2 = kYNPAGE_SCREEN_WIDTH;
            // 所以这边计算实际在当前屏幕下的手指位置
            NSInteger XX = temp1 % temp2;
            // 如果手指向右移动滑动, 并且手指实际位置在临界范围之内
            if (point.x > 0 && XX < location_X) {
                return YES;
            }
            /*
            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
                return YES;
            }
             */
        }
    }
    return NO;
}
    
// 开始进行手势识别时调用的方法，返回NO则结束，不再触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}


@end
