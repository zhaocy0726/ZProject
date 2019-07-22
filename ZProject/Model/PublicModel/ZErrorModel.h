//
//  ZErrorModel.h
//  ZProject
//
//  Created by zhao on 2019/7/19.
//  Copyright © 2019 Z. All rights reserved.
//

#import "BaseModel.h"

@interface ZErrorModel : BaseModel

@property (assign, nonatomic) NSInteger code;    // 错误码
@property (strong, nonatomic) NSString *message; // 错误信息

@end
