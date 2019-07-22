//
//  NSString+Category.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NSString+Category.h"
#import "spelling.h"

@implementation NSString (Category)

- (instancetype)lg_subStringToIndex:(NSInteger)index{
    if (self == nil) {
        return nil;
    }
    if (self.length > (index - 1)) {
        return [self substringToIndex:index];
    }
    return self;
}

+ (BOOL)isEmpty:(NSString *)aString{
    BOOL ret = NO;
    if ((aString == nil) || ([[aString trim] length] == 0) || [aString isKindOfClass:[NSNull class]])
        ret = YES;
    return ret;
}

+ (NSString *)firstLetter:(NSString*)aString
{
    NSString *firstLetter = @"#";
    if (![NSString isEmpty:aString]) {
        char firstLetterChar = pinyinFirstLetter([aString characterAtIndex:0]);
        if (firstLetterChar >= 'a' && firstLetterChar <= 'z') {
            firstLetterChar = firstLetterChar - 32;
        }
        if (firstLetterChar >= 'A' && firstLetterChar <= 'Z') {
            firstLetter = [NSString stringWithFormat:@"%c",firstLetterChar];
        }
    }
    return firstLetter;
}

+ (NSArray *)indexLetters
{
    static NSMutableArray *indexTitleArray = nil;
    if (!indexTitleArray) {
        indexTitleArray = [NSMutableArray array];
        for (char c = 'A'; c <= 'Z'; c++) {
            [indexTitleArray addObject:[NSString stringWithFormat:@"%c", c]];
        }
        [indexTitleArray addObject:@"#"];
    }
    return indexTitleArray;
}
-(BOOL)isCharacter
{
    if (![NSString isEmpty:self]) {
        if (self.length > 0) {
            NSString *subString=[self substringWithRange:NSMakeRange(0, 1)];
            const char *cString=[subString UTF8String];
            return strlen(cString) == 1 ;
        }
    }
    return NO;
}

/**
 * 获取字符长度
 */
- (NSInteger)charLength
{
    if (self && self.length > 0)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData * data = [self dataUsingEncoding:enc];
        return [data length];
    }
    return 0;
}

/**
 * 从0开始截图字符长度为charLength的字符串，如果节点上市汉字 则截取charLength-1个字符
 */
- (NSString *)subStringWithCharLenth:(NSInteger)charLength
{
    if ([NSString isEmpty:self]) {
        return nil;
    }
    if ([self charLength] <= charLength) {
        return self;
    }
    NSString * result = @"";
    for (int i = 0; i < self.length; i ++) {
        NSString * str = [self substringWithRange:NSMakeRange(i, 1)];
        result = [result stringByAppendingString:str];
        if ([result charLength] > charLength) {
            result = [result substringWithRange:NSMakeRange(0, result.length - 1)];
            break;
        }
    }
    
    return result;
}
/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    } else {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size options:option attributes:attributes context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}

//转换日期格式
+(NSString *)convertDateWithString:(NSString *)dateStr andtype:(int)type
{
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    dateStr = [dateStr substringToIndex:11];
    NSDateFormatter *formtter1 = [[NSDateFormatter alloc] init];
    formtter1.dateFormat = @"MMM d yyyy";
    
    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    if (type == 0) {
        formtter.dateFormat = @"yyyy-MM-dd";
    } else if (type == 1) {
        formtter.dateFormat = @"yyyy年MM月dd日" ;
    } else if(type == 2) {
        formtter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    } else {
        formtter.dateFormat = @"yyyy/MM/dd HH:mm";
    }
    NSDate *newDate = [formtter1 dateFromString:dateStr];
    NSString *date = [formtter stringFromDate:newDate];
    
    return date;
}

/**
 *   浮点型 转 字符串 没有多余的零
 *传 float  得到 nsstring
 */
+(NSString *)returnStringWithFloat:(float)floatNum
{
    NSString *stringFloat = [NSString stringWithFormat:@"%.4f",floatNum];
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--) {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

/**
 * 按最长字符长度截取字符串
 */
-(NSString *)returnCharMaxLengthStringWith:(float)maxLength
{
    if ([self charLength] > maxLength && ![NSString isEmpty:self] && maxLength > 1) {
        int maxNum = 0;
        NSString *subString = @"";
        for (int i=0;i<self.length;i++) {
            NSString *unitStr = [self substringWithRange:NSMakeRange(i, 1)];
            if (maxNum > (maxLength-2)) {
                return subString;
            }
            maxNum += [unitStr charLength];
            subString = [subString stringByAppendingString:unitStr];
        }
    }
    return self;
}


- (NSString *)URLEncoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
}

- (NSString *)URLDecoding
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
    if ( self.length >= 2 )
    {
        if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
        
        if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
    }
    
    return self;
}

- (NSString *)normalize
{
    //	return [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //	return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSArray * lines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if ( lines && lines.count )
    {
        NSMutableString * mergedString = [NSMutableString string];
        
        for ( NSString * line in lines )
        {
            NSString * trimed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ( trimed && trimed.length )
            {
                [mergedString appendString:trimed];
            }
        }
        
        return mergedString;
    }
    
    return nil;
}

- (NSString *)repeat:(NSUInteger)count
{
    if ( 0 == count )
        return @"";
    
    NSMutableString * text = [NSMutableString string];
    
    for ( NSUInteger i = 0; i < count; ++i )
    {
        [text appendString:self];
    }
    
    return text;
}

- (NSString *)strongify
{
    return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)match:(NSString *)expression
{
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    if ( nil == regex )
        return NO;
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, self.length)];
    if ( 0 == numberOfMatches )
        return NO;
    
    return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
    for ( NSString * str in array )
    {
        if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)empty
{
    return (self == nil || [self isEqualToString:@""] || [self length] == 0) ? YES : NO;
}

- (BOOL)notEmpty
{
    return (self != nil && ![self isEqualToString:@""] && [self length] > 0) ? YES : NO;
}

- (BOOL)eq:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)equal:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)is:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
    return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
    return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
    NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
    
    for ( NSObject * obj in array )
    {
        if ( NO == [obj isKindOfClass:[NSString class]] )
            continue;
        
        if ( NSOrderedSame == [(NSString *)obj compare:self options:option] )
            return YES;
    }
    
    return NO;
}

- (BOOL)isNumber
{
    NSString *		regex = @"-?[0-9]+";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

// 判断是否是密码格式(a-z,A-Z,0-9,8-16位长度)
- (BOOL)isPassword
{
//    NSString *regex   = @"(^[A-Za-z0-9]{8,16}$)";
    NSString *regex = @"(^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

// 昵称: 由中英文、数字、“-”、“_”组成
- (BOOL)isNickname
{
//    NSString *regex = @"[-_a-zA-Z0-9\u4e00-\u9fa5]+";
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:self];
}

- (BOOL)isPasswordWithMinLength:(NSInteger)minL maxLength:(NSInteger)maxL
{
    NSString *regex   = [NSString stringWithFormat:@"(^[A-Za-z0-9]{%ld,%ld}$)", minL, maxL];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPhone
{
//    NSString *		regex = @"^(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$"; // 国际电话 2-3位国际区号 - 2-3位区号 - 7-8位电话号 - 3位分机号
//    NSString *		regex = @"^((d{2,3}-)?(d{7,8})?"; // 2-3位区号 7-8位电话号
    NSString *      phone = @"^1\\d{10}";   // 中国手机号
//    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSPredicate *  preds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    return [preds evaluateWithObject:self];
}

- (BOOL)isContainChinese {
    for(int i = 0; i < [self length]; i++){
        int a = [self characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}


// ---------------------------------------------

- (BOOL)isEmail
{
    NSString *		regex = @"\\S+@\\S+\\.\\S+";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isIPAddress
{
    NSArray *			components = [self componentsSeparatedByString:@"."];
    NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    
    if ( [components count] == 4 )
    {
        NSString *part1 = [components objectAtIndex:0];
        NSString *part2 = [components objectAtIndex:1];
        NSString *part3 = [components objectAtIndex:2];
        NSString *part4 = [components objectAtIndex:3];
        
        if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
        {
            if ( [part1 intValue] < 255 &&
                [part2 intValue] < 255 &&
                [part3 intValue] < 255 &&
                [part4 intValue] < 255 )
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string
{
    return [self substringFromIndex:from untilString:string endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset
{
    if ( 0 == self.length )
        return nil;
    
    if ( from >= self.length )
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfString:string options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        if ( endOffset )
        {
            *endOffset = range.location + range.length;
        }
        
        return [self substringWithRange:range];
    }
    else
    {
        if ( endOffset )
        {
            *endOffset = range2.location + range2.length;
        }
        
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset
{
    return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
    if ( 0 == self.length )
        return nil;
    
    if ( from >= self.length )
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        if ( endOffset )
        {
            *endOffset = range.location + range.length;
        }
        
        return [self substringWithRange:range];
    }
    else
    {
        if ( endOffset )
        {
            *endOffset = range2.location + range2.length;
        }
        
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset
{
    if ( 0 == self.length )
        return 0;
    
    if ( from >= self.length )
        return 0;
    
    NSCharacterSet * reversedCharset = [charset invertedSet];
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:reversedCharset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        return self.length - from;
    }
    else
    {
        return range2.location - from;		
    }
}

- (NSArray *)pairSeparatedByString:(NSString *)separator
{
    if ( nil == separator )
        return nil;
    
    NSUInteger	offset = 0;
    NSString *	key = [self substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:separator] endOffset:&offset];
    NSString *	val = nil;
    
    if ( nil == key || offset >= self.length )
        return nil;
    
    val = [self substringFromIndex:offset];
    if ( nil == val )
        return nil;
    
    return [NSArray arrayWithObjects:key, val, nil];
}

#pragma mark - 获取文字长度

//获取文字宽度
+ (CGFloat)stringWidthWithText:(NSString *)text fontSize:(NSInteger)fontSize {
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize], NSParagraphStyleAttributeName : style };
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(Screen_Width, 44)
                                         options:opts
                                      attributes:attributes
                                         context:nil].size;
    return textSize.width;
}

#pragma mark - 是否有 emoji

- (BOOL)hasEmoji:(NSString*)string;
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

- (BOOL)isContainsEmoji
{
    __block BOOL returnValue = NO;
    
    if ([self hasEmoji:self]) {
        return YES;
    }
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1F9FF) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

#pragma mark - 包含特殊字符

- (BOOL)isContainsIllegalCharacter {
    // 不能输入特殊字符(只能输入中英文数字)
    NSString *str = @"^[A-Za-z0-9_-\\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![predicate evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
