//
//  PickView.m
//  youbei
//
//  Created by 赵春阳 on 2018/10/17.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "PickView.h"

@interface PickView ()

@property (strong, nonatomic) UIView   *viewBackground;
@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UIButton *btnSure;
@property (strong, nonatomic) UIPickerView *pickView;

@end

@implementation PickView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource selected:(NSInteger)selected;
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _arrData = dataSource;
        _selectedIndex = selected;
        
        [self addSubview:self.pickView];
        [self addSubview:self.viewBackground];
        [_viewBackground addSubview:self.btnSure];
        [_viewBackground addSubview:self.btnCancel];
    }
    return self;
}

#pragma mark -
#pragma mark UIPickerViewDelegate, UIPickerViewDataSource

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return _arrData.count;
//}
//
//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if ([_arrData[row] isKindOfClass:[NSString class]]) {
//        return _arrData[row];
//    }
//    else if ([_arrData[row] isKindOfClass:[UserModel class]]) {
//        UserModel *user = _arrData[row];
//        return user.name;
//    }
//    else if ([_arrData[row] isKindOfClass:[ClassModel class]]) {
//        ClassModel *classInfo = _arrData[row];
//        return classInfo.className;
//    }
//    else {
//        NSNumber *num =  _arrData[row];
//        return [NSString stringWithFormat:@"%@", num];
//    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    _btnSure.hidden = NO;
    _selectedIndex = row;
}

#pragma mark -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    if (view == self) {
        [self hidden];
    }
}

/**
 *  是否弹出日期选择器
 */
- (BOOL)showing
{
    return (self.superview != nil);
}

/**
 *  弹出日期选择器
 */
- (void)show
{
    self.top = SCREEN_HEIGHT;
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.top = 0;
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  隐藏选择器
 */
- (void)hidden
{
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.top = self.top + self.height;
    } completion:^(BOOL finished){

    }];
}

- (void)click_btnSure
{
    !self.selectIndexBlock ?: self.selectIndexBlock(_selectedIndex);
}

- (void)click_btnCancel
{
    !self.cancelSelectBlock ?: self.cancelSelectBlock();
}


#pragma mark - setter

- (UIButton *)btnCancel
{
    if (_btnCancel == nil) {
        _btnCancel = [UIButton new];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:COLOR_WORD(157) forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(click_btnCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (UIButton *)btnSure
{
    if (_btnSure == nil) {
        _btnSure = [UIButton new];
        [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [_btnSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_btnSure addTarget:self action:@selector(click_btnSure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSure;
}


@end
