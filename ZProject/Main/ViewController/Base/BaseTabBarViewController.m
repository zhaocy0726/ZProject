//
//  BaseTabBarViewController.m
//  ZProject
//
//  Created by zhao on 2019/8/26.
//  Copyright © 2019 Z. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSetting];
    
//    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)baseSetting{
    
    [self setChildViewControllerWith:(UIViewController *)[NSClassFromString(@"HomeViewController") new]
                               title:LOCALIZATION(@"书城")
                            iconName:@"icon_tabbar_home_select_0"
                          iconSeName:@"icon_tabbar_home_select_1"];
    
    [self setChildViewControllerWith:(UIViewController *)[NSClassFromString(@"UserViewController") new]
                               title:LOCALIZATION(@"我")
                            iconName:@"icon_tabbar_user_select_0"
                          iconSeName:@"icon_tabbar_user_select_1"];
    
    /// MARK: 设置tabbar 背景色，字体色
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    NSMutableDictionary *textDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if (0) {
        /// 修改tabbar 的 背景色
        [[UITabBar appearance] setBarTintColor:[UIColor redColor]];
        [[UITabBar appearance] setTranslucent:NO];
        
        textDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        [tabBarItem setTitleTextAttributes:textDict forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:textDict forState:UIControlStateSelected];
    }else{
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setTranslucent:YES];
        
        textDict[NSForegroundColorAttributeName] = [UIColor greenColor];
        /// 设置为nil，让其他皮肤的未选中状态恢复默认
        [tabBarItem setTitleTextAttributes:nil forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:textDict forState:UIControlStateSelected];
    }
    
}

- (void)setChildViewControllerWith:(UIViewController *)vc title:(NSString *)title iconName:(NSString *)iconName iconSeName:(NSString *)iconSeName{
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:iconSeName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2.5)];
    //    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(-5, 0, 5, 0)];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    // 切换tabbar
    
}

#pragma mark - 屏幕旋转控制

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
