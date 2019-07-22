//
//  IPhoneVersion.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface IPhoneVersion : NSObject

#define iOSVersionEqualTo(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define iOSVersionGreaterThan(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define iOSVersionGreaterThanOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOSVersionLessThan(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define iOSVersionLessThanOrEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


typedef NS_ENUM(NSInteger, DeviceVersion){
    iPhone4 = 3,
    iPhone4S,
    iPhone5,
    iPhone5C,
    iPhone5S,
    iPhone6,
    iPhone6Plus,
    iphone6s,
    iPhone6sPlus,
    iPhoneSE,
    iphone7,
    iphone7Plus,
    iphone8,
    iphone8Plus,
    iphoneX,
    
    iPad1 = 109,
    iPad2 = 110,
    iPadMini = 111,
    iPad3 = 112,
    iPad4 = 113,
    iPadAir = 115,
    iPadMiniRetina = 116,
    Simulator = 0
};

typedef NS_ENUM(NSInteger, DeviceSize){
    UnknownSize = 0,
    iPhone35inch = 1,   // 4
    iPhone4inch = 2,    // 5
    iPhone47inch = 3,   // 6
    iPhone55inch = 4,   // 6P
    iPhone58inch = 5    // x
};

+(DeviceVersion)deviceVersion;
+(DeviceSize)deviceSize;
+(NSString*)deviceName;
+(CGSize)deviceScreenSize;

+(BOOL)isSameWithDeviceSize:(id)deviceSizes;
/** 适配函数 */
-(void)fitIphone4Or5f:(BlankBlock)ablock and6:(BlankBlock)cblock and6P:(BlankBlock)dblock;

@end
