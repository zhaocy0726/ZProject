//
//  Macros.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#pragma mark - 输出

// MARK: 开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG

#define NSLog(...) do { \
NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]); \
} while(0)

#define ZLog(FORMAT, ...) do { \
fprintf(stderr,"%s %d行 \n %s\n", __func__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]); \
fprintf(stderr, "-----\n");\
} while(0)

#else
#define NSLog(...)
#define ZLog(FORMAT, ...)
#endif

#pragma mark - 字体语言

// MARK: 中文字体
#define CHINESE_FONT_NAME @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]

// MARK: 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)     [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// MARK: 获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#pragma mark - 颜色

// MARK: 基础色值获取方法
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define COLOR_RGB(r,g,b) COLOR_RGBA(r,g,b,1.0f)

#define COLOR_HEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define COLOR_HEX_A(rgbValue,a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]

// MARK: 字体色彩
#define COLOR_WORD_BLACK      COLOR_HEX(0x333333)

// MARK: 灰色字体
#define COLOR_WORD(x)         COLOR_RGB(x,x,x)

// MARK: 默认背景色
#define COLOR_DEFAULT_BACKGROUND COLOR_HEX(0xF4F4F4)
// MARK: 默认分割线颜色
#define COLOR_UNDER_LINE [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1]

#pragma mark - 尺寸

// MARK: 不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5 如果不是则根据实际情况修改）
#define kScreenWidthRatio  (Main_SCREEN_WIDTH / 320.0)
#define kScreenHeightRatio (Main_SCREEN_HEIGHT / 568.0)
#define kAdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define kAdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define kAdaptedFontSize(R)     CHINESE_SYSTEM(AdaptedWidth(R))

// MARK: 默认图片宽高比
#define kImageAspectRatioW_H 5/3.f
#define kImageAspectRatioH_W 3/5.f

#define UNICODETOUTF16(x) (((((x - 0x10000) >>10) | 0xD800) << 16)  | (((x-0x10000)&3FF) | 0xDC00))
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

// MARK: 获取View的属性
#define GetViewWidth(view)  view.frame.size.width
#define GetViewHeight(view) view.frame.size.height
#define GetViewX(view)      view.frame.origin.x
#define GetViewY(view)      view.frame.origin.y

// MARK:  MainScreen Height&Width
#define SCREEN_HEIGHT      [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH       [[UIScreen mainScreen] bounds].size.width
#define SCREEN_BOUNDS      [[UIScreen mainScreen] bounds]

// MARK:  导航栏高度
#define kNavigationBar_HEIGHT (isPhoneX ? 88.f : 64.f)
// MARK:  状态栏高度，iphoneX->44 其他 20
#define kStatusBar_Height (isPhoneX ? 44.f : 20.f)
// MARK:  tabbar 高度 iphoneX:83 其他:49
#define kTabbar_Height (isPhoneX ? 83.f : 49.f)
// MARK:  底部安全区偏移量
#define kSafe_Bottom_Inset (isPhoneX ? 34.f : 0.f)

// MARK:  判断是否为 iPhone 5
#define isPhone5 [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// MARK:  判断是否为iPhone 6/6s
#define isPhone6 [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// MARK:  判断是否为iPhone 6Plus/6sPlus
#define isPhone6P [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
// MARK:  ipnoneX
#define isPhoneX \
({\
BOOL isiPhoneX=NO;\
if(@available(iOS 11.0, *)){\
isiPhoneX=[[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0;\
}else{\
isiPhoneX=NO;\
}\
(isiPhoneX);\
})

#pragma mark - 版本

// MARK: App版本号
#define kLocalVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// MARK: 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// MARK:  是否小于等于IOS8
#define isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] <= 8.0)
// MARK:  是否大于IOS9
#define isIOS9                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)
// MARK:  是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#pragma mark - 判断是否为空

// MARK: 字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
// MARK: 数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
// MARK: 字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
// MARK: 是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#pragma mark - 沙盒及路径

// MARK: Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
// MARK: 获取temp
#define kPathTemp NSTemporaryDirectory()
// MARK: 获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// MARK: 获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#pragma mark - 强弱引用

// MARK: 弱引用/强引用  可配对引用在外面用WeakSelf(self)，block用StrongSelf(self)  也可以单独引用在外面用WeakSelf(self) block里面用weakself
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

#pragma mark - 系统调用简写

#define kAppDelegate        [[UIApplication sharedApplication] delegate]
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#pragma mark - other

// MARK: 获取图片资源
#define ImageFromName(name) [UIImage imageNamed:name]

// MARK: 由角度转换弧度
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
// MARK: 由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

// MARK: 获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)


// 10-100 个随机长度字符串(10 的倍数)
#define kRandomString \
({NSString *string = @"是考虑到就分开了多十"; \
for (NSInteger i = 1; i < arc4random() % 10; i ++) { \
string = [string stringByAppendingString:string]; \
}\
(string);\
})

/// MARK: 临时测试数据，接通接口后删除

#define kTestImage0 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546858200032&di=82cada865edd3fe0e18c5c5a848773ec&imgtype=0&src=http%3A%2F%2Fpic23.nipic.com%2F20120816%2F10691507_162853344170_2.jpg"
#define kTestImage1 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546926546357&di=0952a36a8379537c5b22d56a352026a8&imgtype=0&src=http%3A%2F%2Fimg3.redocn.com%2F20100622%2F20100621_8c78a30dc5c10ef5552cwCXmHvkvaDCT.jpg"
#define kTestImage2 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547521379&di=1cbd6c9de4afb1144879a267aa95fa1d&imgtype=jpg&er=1&src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2Fb6f31e9505acda1d37fee330da3a1d6a1711f28a.jpg"
#define kTestImage3 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546926779248&di=66b6fc56643c7ec4c3a31b90d6261710&imgtype=0&src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2Faccec800ff454bfc474d154da6ef282664b1db84.jpg"
#define kTestImage4 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546926893108&di=06c38eced5b278076cb33bc872ae9834&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Ffront%2F534%2Fw1366h768%2F20181213%2FvWhR-hqackac2454235.jpg"

#define kArrayImage @[kTestImage0, kTestImage1, kTestImage2, kTestImage3, kTestImage4]
#define kRandomImage [kArrayImage objectAtIndex:arc4random()%5]


#endif /* Macros_h */
