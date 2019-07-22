//
//  PhotoViewController.m
//  youbei
//
//  Created by 赵春阳 on 2018/12/10.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView = [[UIImageView alloc]init];
    _imageView.width = SCREEN_WIDTH;
    _imageView.height = SCREEN_HEIGHT - kSafe_Bottom_Inset;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapImageView:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
