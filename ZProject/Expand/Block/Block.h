//
//  Block.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#ifndef Block_h
#define Block_h

// 网络请求返回的block类型
typedef void (^ReturnBlock) (id returnValue);
typedef void (^FailureBlock)(NSError *error);
typedef void (^NetworkStateBlock) (id networkState);

#endif /* Block_h */
