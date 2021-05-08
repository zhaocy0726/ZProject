//
//  HomeViewController.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/20.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "HomeViewController.h"

#import "ZSignInApple.h"

@interface HomeViewController ()

@property (strong, nonatomic) UIButton *testButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.testButton];
    [_testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center .mas_equalTo(self.view);
        make.size   .mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)testButton
{
    if (_testButton == nil) {
        UIButton *button = UIButton.new;
        button.backgroundColor = UIColor.redColor;
        
        [button setTitle:@"testButton" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button addTarget:self action:@selector(clickTestButton) forControlEvents:UIControlEventTouchUpInside];
        
        _testButton = button;
    }
    return _testButton;
}

- (void)clickTestButton
{
    [ZSignInApple signInAppleSuccess:^(NSString * _Nonnull userIdentifier) {
        [self presentMessageTips:userIdentifier];
    } failure:^(NSString * _Nonnull errorMessage) {
        [self presentMessageTips:errorMessage];
    }];
}


@end
