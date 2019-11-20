//
//  JLCLLocationCoordinate2D.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLCoordinateSystem) {
    
    // 地球坐标 ：（代号：GPS、WGS84，国际标准）CLLocationManager 获取的坐标，Google Earth、Google Map、GPS模块等
    JLCoordinateSystemWGS84,
    
    // 火星坐标 ：（代号：GCJ-02，中国坐标偏移标准）高德地图、腾讯地图、阿里云地图、灵图51地图
    JLCoordinateSystemGCJ02,
    
    // 百度坐标 ：（代号：BD-09，百度坐标偏移标准）百度坐标系统，百度坐标是在火星坐标的基础上再次加密计算
    JLCoordinateSystemBD09
};

@interface JLCLLocationCoordinate2D : NSObject

@property (nonatomic, assign, readonly) CLLocationDegrees latitude;
@property (nonatomic, assign, readonly) CLLocationDegrees longitude;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, assign, readonly) JLCoordinateSystem coordinateSystem;

// WGS84坐标系
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate2DWGS84;
// GCJ02坐标系
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate2DGCJ02;
// BD09坐标系
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate2DBD09;

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D;

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D coordinateSystem:(JLCoordinateSystem)coordinateSystem;

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude coordinateSystem:(JLCoordinateSystem)coordinateSystem;

#pragma mark - 坐标系转换
// 将WGS-84(地球坐标)转为GCJ-02(火星坐标)
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)p;

// 将GCJ-02(火星坐标)转为BD-09(百度坐标)
+ (CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p;

// 将BD-09(百度坐标)转为GCJ-02(火星坐标)
+ (CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p;

// 将GCJ-02(火星坐标)转为WGS-84(地球坐标)
+ (CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p;

#pragma mark - 判断WGS-84坐标是否在中国区域内
// 判断是否在中国（简易判断）
+ (BOOL)isInsideChinaSimple:(CLLocationCoordinate2D)location;
// 判断location是否在中国（稍微复杂判断）
+ (BOOL)isInsideChina:(CLLocationCoordinate2D)location;

#pragma mark - 计算两点之间的直线距离
+ (CLLocationDistance)distance:(CLLocationCoordinate2D)startCoordinate2D end:(CLLocationCoordinate2D)endCoordinate2D;

+ (CLLocationDistance)distance:(CLLocationDegrees)startLng startLat:(CLLocationDegrees)startLat endLng:(CLLocationDegrees)endLng endLat:(CLLocationDegrees)endLat;

@end

NS_ASSUME_NONNULL_END
