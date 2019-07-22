//
//  BaseView.m
//  ZProject
//
//  Created by zhao on 2019/7/22.
//  Copyright © 2019 Z. All rights reserved.
//

#import "BaseView.h"

@interface BaseView ()

@property (assign, nonatomic) BOOL executedConfigUI; // 执行过配置界面方法

@end

@implementation BaseView

- (instancetype)init
{
    if (self = [super init]) {
        [self addContainerView];
        [self configViewUI];
        self.executedConfigUI = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (!self.executedConfigUI) {
            [self addContainerView];
            [self configViewUI];
            self.executedConfigUI = YES;
        }
    }
    return self;
}

- (void)addContainerView
{
    [self addSubview:self.containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges  .mas_equalTo(self);
    }];
}

- (void)configViewUI
{
    
}

#pragma mark - setter

- (UIView *)containerView
{
    if (_containerView == nil) {
        _containerView = [UIView new];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

@end
