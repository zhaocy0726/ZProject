//
//  Macro+Singleton.h
//  youbei
//
//  Created by 赵春阳 on 2018/10/16.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#ifndef Macro_Singleton_h
#define Macro_Singleton_h

#import <objc/runtime.h>

#pragma mark -
#pragma mark - interface
/* Usage:
 *
 * MyClass.h:
 * ========================================
 *    #import "Singleton.h"
 *
 *    @interface MyClass: SomeSuperclass
 *    {
 *      ...
 *    }
 *    SYNTHESIZE_SINGLETON_INTERFACE(MyClass);
 *
 *    @end
 * ========================================
 */

#undef  SINGLETON_INTERFACE
#define SINGLETON_INTERFACE( __class ) \
\
+ (__class *)sharedInstance; \
\
+ (void)load; \
\

#pragma mark -
#pragma mark - implementation

/* Usage:
 *
 *    MyClass.m:
 * ========================================
 *    #import "MyClass.h"
 *
 *    @implementation MyClass
 *
 *    SYNTHESIZE_SINGLETON_IMPLEMENTION(MyClass);
 *
 *    ...
 *
 *    @end
 * ========================================
 */

#undef SINGLETON_IMPLEMENTION
#define SINGLETON_IMPLEMENTION( __class ) \
\
static __class * __singleton__; \
\
+ (__class *)sharedInstance \
{ \
static dispatch_once_t predicate; \
dispatch_once( &predicate, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
} \
+ (void)load \
{ \
[self sharedInstance]; \
} \

#endif /* Macro_Singleton_h */
