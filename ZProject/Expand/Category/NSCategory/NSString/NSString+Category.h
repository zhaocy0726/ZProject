//
//  NSString+Category.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Category)

//- (NSString *)replaceUnicode:(NSString *)unicodeStr;

/** 截取字符串 */
- (instancetype)lg_subStringToIndex:(NSInteger)index;
/**
 *  @brief 是否为空
 *
 *  @param aString 需要判断的字符串
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSString*)aString;

/**
 *  @brief 中文字符串的首字母
 *
 *  @param aString 字文字符串
 *
 *  @return 首字母
 */
+ (NSString *)firstLetter:(NSString*)aString;

/**
 *  所有索引目录
 *
 *  @return 索引目录
 */
+ (NSArray *)indexLetters;

/**
 * 判断 第一个字 是否为字母
 */
-(BOOL)isCharacter;

/**
 * 获取字符长度
 */
- (NSInteger)charLength;

/**
 * 从0开始截图字符长度为charLength的字符串，如果节点上市汉字 则截取charLength-1个字符
 */
- (NSString *)subStringWithCharLenth:(NSInteger)charLength;

/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  浮点型 转 字符串 没有多余的零
 *  传 float  得到 nsstring
 */
+(NSString *)returnStringWithFloat:(float)floatNum;

/**
 * 按最长字符长度截取字符串
 */
-(NSString *)returnCharMaxLengthStringWith:(float)maxLength;

/**
 * 转换日期
 *type =0 2015/01/01 12:23
 *type =1 2015年01月01日
 *type = 2 2015年01月01日 12:23
 */
+(NSString *)convertDateWithString:(NSString *)dateStr andtype:(int)type;

/** 获取文字宽度 */
+ (CGFloat)stringWidthWithText:(NSString *)text fontSize:(NSInteger)fontSize;

/** 编码解码 */
- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

/** 过滤空格 */
- (NSString *)trim;

- (NSString *)unwrap;
- (NSString *)normalize;
- (NSString *)repeat:(NSUInteger)count;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)empty;
- (BOOL)notEmpty;

- (BOOL)eq:(NSString *)other;
- (BOOL)equal:(NSString *)other;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (BOOL)isContainChinese; // 包含汉字
- (BOOL)isNickname; // 昵称: 4-20个字符, 可由中英文、数字、“-”、“_”组成
- (BOOL)isPhone;
- (BOOL)isNumber;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIPAddress;
- (BOOL)isPassword;
- (BOOL)isPasswordWithMinLength:(NSInteger)minL maxLength:(NSInteger)maxL; // 英文加数字的密码组合

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string;
- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset;

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset;

- (NSArray *)pairSeparatedByString:(NSString *)separator;
/** 包含emoji表情 */
- (BOOL)isContainsEmoji;
/** 包含特殊字符 */
- (BOOL)isContainsIllegalCharacter;

@end
