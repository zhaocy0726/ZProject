//
//  BaseNavigationView.m
//  ZProject
//
//  Created by zhao on 2019/7/22.
//  Copyright © 2019 Z. All rights reserved.
//

#import "BaseNavigationView.h"

#import "BackButton.h"

@interface BaseNavigationView ()

@property (strong, nonatomic) UIView *shadowlineView; // 阴影线
@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) BackButton *btnLeftItem;

@end

@implementation BaseNavigationView

- (instancetype)init
{
    if (self = [super init]) {
        [self configBaseViewUI];
        [self configViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configBaseViewUI];
        [self configViewUI];
    }
    return self;
}

- (void)configBaseViewUI
{
    [self addSubview:self.containerView];
    [self addSubview:self.navigationView];
    [_navigationView addSubview:self.btnLeftItem];
    [_navigationView addSubview:self.lblTitle];
    [_navigationView addSubview:self.btnRightItem];
    [_navigationView addSubview:self.shadowlineView];
    
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height .mas_equalTo(kNavigationBar_HEIGHT);
    }];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom .mas_equalTo(self.navigationView);
        make.centerX.mas_equalTo(self.navigationView);
        make.height .mas_equalTo(44);
    }];
    [_btnLeftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left   .mas_equalTo(self.navigationView).offset(5);
        make.bottom .mas_equalTo(self.navigationView).offset(-5);
        make.size   .mas_equalTo(CGSizeMake(60, 34));
    }];
    [_btnRightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right  .mas_equalTo(self.navigationView);
        make.bottom .mas_equalTo(self.btnLeftItem);
        make.size   .mas_equalTo(self.btnLeftItem);
    }];
    [_shadowlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.navigationView);
        make.height .mas_equalTo(.5f);
    }];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top    .mas_equalTo(self.navigationView.mas_bottom);
    }];
}

- (void)configViewUI
{
    
}

#pragma mark - action

- (void)click_btnLeftItem
{
    !self.clickBtnLeftItemBlock ? [self actionTopViewPopViewController] : self.clickBtnLeftItemBlock();
}

- (void)actionTopViewPopViewController
{
    [[[self getCurrentVC] topViewController].navigationController popViewControllerAnimated:YES];
}

- (void)click_btnRightItem
{
    
}

#pragma mark - setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    _lblTitle.text = _title;
}

- (void)setRightItemTitle:(NSString *)rightItemTitle
{
    _rightItemTitle = rightItemTitle;
    [_btnRightItem setTitle:_rightItemTitle forState:UIControlStateNormal];
    _btnRightItem.hidden = _rightItemTitle.trim.length == 0;
}

- (void)setRightItemImage:(NSString *)rightItemImage
{
    _rightItemImage = rightItemImage;
    UIImage *image = ImageFromName(rightItemImage);
    [_btnRightItem setImage:image forState:UIControlStateNormal];
    _btnRightItem.hidden = !image;
}

- (void)setHiddenLeftItem:(BOOL)hiddenLeftItem
{
    _hiddenLeftItem = hiddenLeftItem;
    _btnLeftItem.hidden = hiddenLeftItem;
}

- (void)setNavHidden:(BOOL)navHidden{
    _navHidden = navHidden;
    self.navigationView.hidden = YES;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UIView *)containerView
{
    if (_containerView == nil) {
        _containerView = [UIView new];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UIView *)navigationView
{
    if (_navigationView == nil) {
        _navigationView = [UIView new];
        _navigationView.backgroundColor = [UIColor whiteColor];
    }
    return _navigationView;
}

- (UIView *)shadowlineView
{
    if (_shadowlineView == nil) {
        _shadowlineView = [UIView new];
        _shadowlineView.backgroundColor = COLOR_UNDER_LINE;
    }
    return _shadowlineView;
}

- (UILabel *)lblTitle
{
    if (_lblTitle == nil) {
        _lblTitle = [UILabel new];
        _lblTitle.textColor = COLOR_WORD_BLACK;
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.font = SYSTEMFONT(18.f);
    }
    return _lblTitle;
}

- (BackButton *)btnLeftItem
{
    if (_btnLeftItem == nil) {
        _btnLeftItem = [BackButton new];
        [_btnLeftItem setTitleColor:COLOR_WORD(157) forState:UIControlStateNormal];
        [_btnLeftItem setImage:ImageFromName(@"arrow_left") forState:UIControlStateNormal];
        [_btnLeftItem addTarget:self action:@selector(click_btnLeftItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLeftItem;
}

- (UIButton *)btnRightItem
{
    if (_btnRightItem == nil) {
        _btnRightItem = [UIButton new];
        _btnRightItem.titleLabel.font = SYSTEMFONT(14.f);
        _btnRightItem.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_btnRightItem setTitleColor:COLOR_WORD(157) forState:UIControlStateNormal];
        [_btnRightItem addTarget:self action:@selector(click_btnRightItem) forControlEvents:UIControlEventTouchUpInside];
        _btnRightItem.hidden = YES;
    }
    return _btnRightItem;
}

@end
