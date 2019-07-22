//
//  LocationManager.m
//  youbei
//
//  Created by 赵春阳 on 2019/4/2.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import "LocationManager.h"

#import <CoreLocation/CoreLocation.h>

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (copy,nonatomic) void (^block)(NSString *city);// 回调 城市名

@end

@implementation LocationManager

- (instancetype)init
{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)startUpdatingLocationWithBlock:(void (^)(NSString *city))block
{
    LocationManager *manager = [self sharedInstance];
    manager.block = block;
    
    [manager.locationManager requestWhenInUseAuthorization];
}


#pragma mark - CLLocationManagerDelegate 反地理编码代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //    NSLog(@"locations -- %@",locations);
    [manager stopUpdatingLocation];
    if (locations.count != 0) {
        CLLocation *location = [locations lastObject];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        // MARK: 反地理编码
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = placemarks[0];
            //            NSLog(@"placemark -- %@",placemarks);
            if (self.block) {
                // 还原Device 的语言
                self.block(placemark.locality);
                //                NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                //                      ,placemark.name
                //                      ,placemark.thoroughfare
                //                      ,placemark.subThoroughfare
                //                      ,placemark.locality
                //                      ,placemark.subLocality
                //                      ,placemark.administrativeArea
                //                      ,placemark.subAdministrativeArea
                //                      ,placemark.postalCode
                //                      ,placemark.ISOcountryCode
                //                      ,placemark.country
                //                      ,placemark.inlandWater
                //                      ,placemark.ocean
                //                      ,placemark.areasOfInterest);
            }
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{    
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        NSString *title = @"定位服务未启用";
        NSString *message = @"你的手机目前并没有开启定位服务，请到设置->隐私->定位服务中，开启本程序的定位服务";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    if ([error code] == kCLErrorDenied) {
//        //访问被拒绝
//    }
//    if ([error code] == kCLErrorLocationUnknown) {
//        //无法获取位置信息
//    }
//}

@end
