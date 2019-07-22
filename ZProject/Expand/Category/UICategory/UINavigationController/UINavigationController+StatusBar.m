//
//  UINavigationController+StatusBar.m
//  youbei
//
//  Created by 赵春阳 on 2019/2/15.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import "UINavigationController+StatusBar.h"

@implementation UINavigationController (StatusBar)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

@end
