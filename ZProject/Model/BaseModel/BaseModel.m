//
//  BaseModel.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/22.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "BaseModel.h"

#import <objc/runtime.h>

@implementation BaseModel

MJExtensionCodingImplementation

- (NSMutableDictionary *)createDictionayFromModelProperties
{
    NSMutableDictionary *propsDic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    // class:获取哪个类的成员属性列表
    // count:成员属性总数
    // 拷贝属性列表
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        // 属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        // 属性值
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        // 设置KeyValues
        if (propertyValue) [propsDic setObject:propertyValue forKey:propertyName];
    }
    // 需手动释放 不受ARC约束
    free(properties);
    return propsDic;
}

/** 在控制台po输入对象具体信息 */
- (NSString *)debugDescription {
    
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSString class]]) {
        return self.debugDescription;
    }
    // 初始化一个字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 得到当前class的所有属性
    uint count;
    objc_property_t *properites = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) { // 循环使用kvc获取每一个值
        objc_property_t property = properites[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?: @"nil";
        [dic setValue:value forKey:name];
    }
    free(properites);
    return [NSString stringWithFormat:@"%@(%p): %@", [self class], self, dic];
}

@end
