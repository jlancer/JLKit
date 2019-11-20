

//
//  JLCLLocationCoordinate2D.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLCLLocationCoordinate2D.h"
#import "JLCLLocationRectangle2D.h"

static const double a   = 6378245.0;
static const double ee  = 0.00669342162296594323;
static const double pi  = M_PI;
static const double xPi = M_PI * 3000.0 / 180.0;

@interface JLCLLocationCoordinate2D ()

// 当前输入坐标系值和坐标系类型
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, assign) JLCoordinateSystem coordinateSystem;

// WGS84坐标系
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2DWGS84;
// GCJ02坐标系
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2DGCJ02;
// BD09坐标系
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2DBD09;

@end

@implementation JLCLLocationCoordinate2D

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D {
    
    return [self initWithCoordinate2D:coordinate2D coordinateSystem:JLCoordinateSystemWGS84];
}

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D coordinateSystem:(JLCoordinateSystem)coordinateSystem {
    
    if (self = [super init]) {
        self.latitude = coordinate2D.latitude;
        self.longitude = coordinate2D.longitude;
        self.coordinate2D = coordinate2D;
        self.coordinateSystem = coordinateSystem;
        [self _tranformCoordinate];
    }
    return self;
}

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    
    return [self initWithLatitude:latitude longitude:longitude coordinateSystem:JLCoordinateSystemWGS84];
}

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude coordinateSystem:(JLCoordinateSystem)coordinateSystem {
    
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.coordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
        self.coordinateSystem = coordinateSystem;
        [self _tranformCoordinate];
    }
    return self;
}

- (void)_tranformCoordinate {
    switch (self.coordinateSystem) {
        case JLCoordinateSystemWGS84:
        {
            self.coordinate2DWGS84 = self.coordinate2D;
            self.coordinate2DGCJ02 = [[self class] transformFromWGSToGCJ:self.coordinate2D];
            self.coordinate2DBD09 = [[self class] transformFromGCJToBaidu:self.coordinate2DGCJ02];
        }
            break;
        case JLCoordinateSystemGCJ02:
        {
            self.coordinate2DGCJ02 = self.coordinate2D;
            self.coordinate2DWGS84 = [[self class] transformFromGCJToWGS:self.coordinate2D];
            self.coordinate2DBD09 = [[self class] transformFromGCJToBaidu:self.coordinate2D];
        }
            break;
        case JLCoordinateSystemBD09:
        {
            self.coordinate2DBD09 = self.coordinate2D;
            self.coordinate2DGCJ02 = [[self class] transformFromBaiduToGCJ:self.coordinate2D];
            self.coordinate2DWGS84 = [[self class] transformFromGCJToWGS:self.coordinate2DGCJ02];
            break;
        }
        default:
            break;
    }
}

- (CLLocationCoordinate2D)coordinate2D:(JLCoordinateSystem)coordinateSystem {
    switch (self.coordinateSystem) {
        case JLCoordinateSystemWGS84:
            return self.coordinate2DWGS84;
        case JLCoordinateSystemGCJ02:
            return self.coordinate2DGCJ02;
        case JLCoordinateSystemBD09:
            return self.coordinate2DBD09;
        default:
            return self.coordinate2DWGS84;
    }
}

#pragma mark - 坐标系转换
// 将WGS-84(地球坐标)转为GCJ-02(火星坐标)
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)p {
    
    CLLocationCoordinate2D adjustLoc;
    if(![self isInsideChina:p]) {
        adjustLoc = p;
    } else{
        double adjustLat = [self _transformLatWithX:p.longitude - 105.0 withY:p.latitude - 35.0];
        double adjustLon = [self _transformLonWithX:p.longitude - 105.0 withY:p.latitude - 35.0];
        long double radLat = p.latitude / 180.0 * pi;
        long double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        long double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        adjustLoc.latitude = p.latitude + adjustLat;
        adjustLoc.longitude = p.longitude + adjustLon;
    }
    return adjustLoc;
}

// 将GCJ-02(火星坐标)转为BD-09(百度坐标)
+ (CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p {
    
    long double z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude) + 0.00002 * sqrt(p.latitude * pi);
    long double theta = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * pi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude = (z * sin(theta) + 0.006);
    geoPoint.longitude = (z * cos(theta) + 0.0065);
    return geoPoint;
}

// 将BD-09(百度坐标)转为GCJ-02(火星坐标)
+ (CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p {
    
    double x = p.longitude - 0.0065, y = p.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude  = z * sin(theta);
    geoPoint.longitude = z * cos(theta);
    return geoPoint;
}

// 将GCJ-02(火星坐标)转为WGS-84(地球坐标)
+ (CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p {
    
    double threshold = 0.00001;
    // The boundary
    double minLat = p.latitude - 0.5;
    double maxLat = p.latitude + 0.5;
    double minLng = p.longitude - 0.5;
    double maxLng = p.longitude + 0.5;
    double delta = 1;
    int maxIteration = 30;
    // Binary search
    while(true) {
        CLLocationCoordinate2D leftBottom  = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = minLng}];
        CLLocationCoordinate2D rightBottom = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = maxLng}];
        CLLocationCoordinate2D leftUp      = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = maxLat,.longitude = minLng}];
        CLLocationCoordinate2D midPoint    = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2.0),.longitude = ((minLng + maxLng) / 2.0)}];
        delta = fabs(midPoint.latitude - p.latitude) + fabs(midPoint.longitude - p.longitude);
        if( maxIteration-- <= 0 || delta <= threshold ) {
            return (CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2.0),.longitude = ((minLng + maxLng) / 2.0)};
        }
        if(_isContains(p, leftBottom, midPoint)) {
            maxLat = (minLat + maxLat) / 2.0;
            maxLng = (minLng + maxLng) / 2.0;
        }else if(_isContains(p, rightBottom, midPoint)) {
            maxLat = (minLat + maxLat) / 2.0;
            minLng = (minLng + maxLng) / 2.0;
        }else if(_isContains(p, leftUp, midPoint)) {
            minLat = (minLat + maxLat) / 2.0;
            maxLng = (minLng + maxLng) / 2.0;
        }else {
            minLat = (minLat + maxLat) / 2.0;
            minLng = (minLng + maxLng) / 2.0;
        }
    }
}

+ (double)_transformLatWithX:(double)x withY:(double)y {
    
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+ (double)_transformLonWithX:(double)x withY:(double)y {
    
    double lng = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lng += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lng += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lng += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lng;
}

static bool _isContains(CLLocationCoordinate2D point, CLLocationCoordinate2D p1, CLLocationCoordinate2D p2) {
    
    return (point.latitude >= MIN(p1.latitude, p2.latitude) && point.latitude <= MAX(p1.latitude, p2.latitude)) && (point.longitude >= MIN(p1.longitude,p2.longitude) && point.longitude <= MAX(p1.longitude, p2.longitude));
}

#pragma mark - 判断WGS-84坐标是否在中国区域内
// 判断是否在中国（简易判断）
+ (BOOL)isInsideChinaSimple:(CLLocationCoordinate2D)location {
    
    if (location.longitude >= 72.004 && location.longitude <= 137.8347 && location.latitude >= 0.8293 && location.latitude <= 55.8271) {
        return YES;
    }
    return NO;
}

// 判断location是否在中国（稍微复杂判断）
+ (BOOL)isInsideChina:(CLLocationCoordinate2D)location {
    
    //范围矩形列表
    NSArray *regionRectangle = [[NSArray alloc] initWithObjects:
                                [JLCLLocationRectangle2D rectangle2D:079.446200 startLat:49.220400 endLng:096.330000 endLat:42.889900],
                                [JLCLLocationRectangle2D rectangle2D:109.687200 startLat:54.141500 endLng:135.000200 endLat:39.374200],
                                [JLCLLocationRectangle2D rectangle2D:073.124600 startLat:42.889900 endLng:124.143255 endLat:29.529700],
                                [JLCLLocationRectangle2D rectangle2D:082.968400 startLat:29.529700 endLng:097.035200 endLat:26.718600],
                                [JLCLLocationRectangle2D rectangle2D:097.025300 startLat:29.529700 endLng:124.367395 endLat:20.414096],
                                [JLCLLocationRectangle2D rectangle2D:107.975793 startLat:20.414096 endLng:111.744104 endLat:17.871542],
                                nil];
    
    //范围内排除的矩形列表
    NSArray *excludeRectangle = [[NSArray alloc] initWithObjects:
                                 [JLCLLocationRectangle2D rectangle2D:119.921265 startLat:25.398623 endLng:122.497559 endLat:21.785006],
                                 [JLCLLocationRectangle2D rectangle2D:101.865200 startLat:22.284000 endLng:106.665000 endLat:20.098800],
                                 [JLCLLocationRectangle2D rectangle2D:106.452500 startLat:21.542200 endLng:108.051000 endLat:20.487800],
                                 [JLCLLocationRectangle2D rectangle2D:109.032300 startLat:55.817500 endLng:119.127000 endLat:50.325700],
                                 [JLCLLocationRectangle2D rectangle2D:127.456800 startLat:55.817500 endLng:137.022700 endLat:49.557400],
                                 [JLCLLocationRectangle2D rectangle2D:131.266200 startLat:44.892200 endLng:137.022700 endLat:42.569200],
                                 nil];
    
    for (JLCLLocationRectangle2D *r in regionRectangle) {
        if ([r isPointInside:location]) {
            for (JLCLLocationRectangle2D *e in excludeRectangle) {
                if ([e isPointInside:location]) {
                    return NO;
                }
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - 计算两点之间的直线距离
+ (CLLocationDistance)distance:(CLLocationCoordinate2D)startCoordinate2D end:(CLLocationCoordinate2D)endCoordinate2D {
    
    return [[self class] distance:startCoordinate2D.longitude startLat:startCoordinate2D.latitude endLng:endCoordinate2D.longitude endLat:endCoordinate2D.latitude];
}

+ (CLLocationDistance)distance:(CLLocationDegrees)startLng startLat:(CLLocationDegrees)startLat endLng:(CLLocationDegrees)endLng endLat:(CLLocationDegrees)endLat {
    
    // 第一个坐标
    CLLocation *start = [[CLLocation alloc] initWithLatitude:startLat longitude:startLng];
    // 第二个坐标
    CLLocation *end = [[CLLocation alloc] initWithLatitude:endLat longitude:endLng];
    // 计算距离
    CLLocationDistance meters = [start distanceFromLocation:end];
    return meters;
}

@end
