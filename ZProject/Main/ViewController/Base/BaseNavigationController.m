//
//  BaseNavigationController.m
//  ZProject
//
//  Created by zhao on 2019/7/22.
//  Copyright © 2019 Z. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUserInterface];
}

// MARK: 重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 当退出到根控制器时不隐藏
//    if (self.childViewControllers.count && (![viewController isKindOfClass:[HOMECONTROLLER class]] ||
//                                            ![viewController isKindOfClass:[USERCONTROLLER class]])) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
    [super pushViewController:viewController animated:animated];
}

- (void)configUserInterface {
    self.navigationBar.tintColor = [UIColor whiteColor];
    // 设置导航栏标题字体颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationBar setTranslucent:NO];
}


@end
