//
//  FRPickView.h
//  youbei
//
//  Created by 赵春阳 on 2018/10/17.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "YBBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRPickView : YBBaseView

@property (assign, nonatomic ,readonly) BOOL showing;

@property (assign ,nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSArray *arrData;

@property (copy, nonatomic) void (^selectIndexBlock)(NSInteger); // 选择
@property (copy, nonatomic) void (^cancelSelectBlock)(void); // 取消

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource selected:(NSInteger)selected;

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
