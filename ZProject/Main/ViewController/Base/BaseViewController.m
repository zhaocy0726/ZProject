//
//  ViewController.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/19.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

@end
