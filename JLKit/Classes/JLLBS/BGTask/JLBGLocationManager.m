
//
//  JLBGLocationManager.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLBGLocationManager.h"
#import "JLBGTask.h"

@interface JLBGLocationManager ()

// 后台任务
@property (nonatomic, strong) JLBGTask *bgTask;

@property (nonatomic, copy) void(^updateLocationBlock)(CLLocation *location);
@property (nonatomic, copy) void(^errorBlock)(NSError *error, NSString *alertTitle, NSString *alertMessage);

@end

@implementation JLBGLocationManager

//初始化
- (instancetype)init {
    if(self == [super init]) {
        
        self.bgTask = [JLBGTask shared];
        
        //监听进入后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

+ (CLLocationManager *)shared {
    
    static CLLocationManager *SINGLETON;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        SINGLETON = [[CLLocationManager alloc] init];
        SINGLETON.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        SINGLETON.distanceFilter = kCLDistanceFilterNone;
        if (@available(iOS 9.0, *)) {
            SINGLETON.allowsBackgroundLocationUpdates = YES;
        }
        SINGLETON.pausesLocationUpdatesAutomatically = NO;
    });
    return SINGLETON;
}

// 开始监听GPS Location监听服务
- (void)startLocation:(void(^)(void))serviceDisabledBlock notAuthorizated:(void(^)(void))notAuthorizatedBlock authorized:(void(^)(void))authorizedBlock errorBlock:(void(^)(NSError *error, NSString *alertTitle, NSString *alertMessage))errorBlock updateLocationBlock:(void(^)(CLLocation *location))updateLocationBlock {
    
    self.errorBlock = errorBlock;
    self.updateLocationBlock = updateLocationBlock;
    
    // 开启定位
    if ([CLLocationManager locationServicesEnabled] == NO) {
        serviceDisabledBlock == nil ? : serviceDisabledBlock();
    }else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if( authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted ){
            notAuthorizatedBlock == nil ? : notAuthorizatedBlock();
        } else {
            CLLocationManager *locationManager = [JLBGLocationManager shared];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.delegate = self;
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

// 停止监听GPS Location监听服务
- (void)stopLocation {
    
    CLLocationManager *locationManager = [JLBGLocationManager shared];
    [locationManager stopUpdatingLocation];
}

//后台监听方法
- (void)_applicationEnterBackground {
    
    // 进入后台
    CLLocationManager *locationManager = [JLBGLocationManager shared];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    // 不移动也可以后台刷新回调
    if (@available(iOS 8.0, *)) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_bgTask beginNewBackgroundTask];
}

// 重启监听GPS Location监听服务
- (void)_restartLocation {
    
    // 重新启动定位
    CLLocationManager *locationManager = [JLBGLocationManager shared];
    locationManager.delegate = self;
    // 不移动也可以后台刷新回调
    locationManager.distanceFilter = kCLDistanceFilterNone;
    if (@available(iOS 8.0, *)) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self.bgTask beginNewBackgroundTask];
}

#pragma mark - CLLocationManagerDelegate
//定位回调里执行重启定位和关闭定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.updateLocationBlock == nil ? : self.updateLocationBlock(locations[0]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    switch([error code])
    {
        case kCLErrorNetwork:
        {
            // general, network-related error
            self.errorBlock == nil ? : self.errorBlock(error, @"网络错误", @"请检查网络连接");
        }
            break;
        case kCLErrorDenied:
        {
            self.errorBlock == nil ? : self.errorBlock(error, @"请开启后台服务", @"应用没有不可以定位，需要在在设置/通用/后台应用刷新开启");
        }
            break;
        default:
            self.errorBlock == nil ? : self.errorBlock(error, @"GPS错误", @"GPS错误");
            break;
    }
}


@end
