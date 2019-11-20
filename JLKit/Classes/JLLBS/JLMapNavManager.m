

//
//  JLMapNavManager.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLMapNavManager.h"
#import <MapKit/MapKit.h>
#import "UIViewController+Addition_JL.h"

@interface JLMapNavManager ()

@property (nonatomic, strong) NSMutableArray *availableMaps;

@end

@implementation JLMapNavManager

- (NSMutableArray *)availableMaps {
    
    if (_availableMaps == nil) {
        _availableMaps = [[NSMutableArray alloc] init];
    }
    return _availableMaps;
}

+ (JLMapNavManager *)shared {
    
    static JLMapNavManager *SINGLETON = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        SINGLETON = [[JLMapNavManager alloc] init];
    });
    return SINGLETON;
}

- (void)_setupAvailableMaps {
    
    [self.availableMaps removeAllObjects];
    
    // 高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAPGAODE]]) {
        [self.availableMaps addObject:SCHEME_MAPGAODE];
    }
    // 腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAPQQ]]) {
        [self.availableMaps addObject:SCHEME_MAPQQ];
    }
    // 百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAPBAIDU]]) {
        [self.availableMaps addObject:SCHEME_MAPBAIDU];
    }
    // Google地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCHEME_MAPGOOGLE]]) {
        [self.availableMaps addObject:SCHEME_MAPGOOGLE];
    }
    
}

// 第三方地图导航
- (void)jl_mapStartNavi:(CLLocationDegrees)orgLng orgLat:(CLLocationDegrees)orgLat destLng:(CLLocationDegrees)destLng destLat:(CLLocationDegrees)destLat destName:(NSString *)destName coordinateSystem:(JLCoordinateSystem)coordinateSystem appScheme:(NSString *)appScheme fromController:(UIViewController * _Nonnull)controller customBlock:(void(^)(NSDictionary *availableMapUrls, JLMapNavVoidBlock executeMapAppleDirection))customBlock {
    
    [self _setupAvailableMaps];
    
    NSMutableArray *alertItems = nil;
    NSMutableDictionary *availableMapUrls = nil;
    if (customBlock == nil && controller != nil) {
        alertItems = [[NSMutableArray alloc] init];
    }else {
        availableMapUrls = [[NSMutableDictionary alloc] init];
    }
    
    // 判断目的地地址是否在国内，在国内需要根据不同的三方导航转换坐标系
    JLCLLocationCoordinate2D *startCoordinate2D = [[JLCLLocationCoordinate2D alloc] initWithLatitude:orgLat longitude:orgLng coordinateSystem:coordinateSystem];
    JLCLLocationCoordinate2D *destCoordinate2D = [[JLCLLocationCoordinate2D alloc] initWithLatitude:destLat longitude:destLng coordinateSystem:coordinateSystem];
    BOOL _insideChina = [JLCLLocationCoordinate2D isInsideChina:destCoordinate2D.coordinate2D];
    
    // 苹果自带导航
    JLMapNavVoidBlock _executeAppleDirection = ^{
        
        if (_insideChina) {
            // 转成高德国内坐标系GCJ-02
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destCoordinate2D.coordinate2DGCJ02 addressDictionary:nil];
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
            toLocation.name = destName;
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }else {
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destCoordinate2D.coordinate2D addressDictionary:nil];
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
            toLocation.name = destName;
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
    };
    if (availableMapUrls) {
        [availableMapUrls setValue:SCHEME_MAPAPPLE forKey:SCHEME_MAPAPPLE];
    }else if (alertItems) {
        JLAlertModel *alertModel = [JLAlertModel alertModel:@"苹果地图" style:UIAlertActionStyleDefault action:_executeAppleDirection color:[UIColor blackColor]];
        [alertItems addObject:alertModel];
    }
    // Google地图
    if ([self.availableMaps containsObject:SCHEME_MAPGOOGLE]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], appScheme, destCoordinate2D.coordinate2DGCJ02.latitude, destCoordinate2D.coordinate2DGCJ02.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], appScheme, destLat, destLng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        if (availableMapUrls) {
            [availableMapUrls setValue:url forKey:SCHEME_MAPGOOGLE];
        }else if (alertItems) {
            JLAlertModel *alertModel = [JLAlertModel alertModel:@"Google地图" style:UIAlertActionStyleDefault action:^{
                [[UIApplication sharedApplication] openURL:url];
            } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    // 高德地图
    if ([self.availableMaps containsObject:SCHEME_MAPGAODE]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], appScheme, destName, destCoordinate2D.coordinate2DGCJ02.latitude, destCoordinate2D.coordinate2DGCJ02.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"], appScheme, destName, destLat, destLng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        if (availableMapUrls) {
            [availableMapUrls setValue:url forKey:SCHEME_MAPGAODE];
        }else if (alertItems) {
            JLAlertModel *alertModel = [JLAlertModel alertModel:@"高德地图" style:UIAlertActionStyleDefault action:^{
                [[UIApplication sharedApplication] openURL:url];
            } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    // 百度地图
    if ([self.availableMaps containsObject:SCHEME_MAPBAIDU]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving", startCoordinate2D.coordinate2DBD09.latitude, startCoordinate2D.coordinate2DBD09.longitude, destCoordinate2D.coordinate2DBD09.latitude, destCoordinate2D.coordinate2DBD09.longitude, destName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving", orgLat, orgLng, destLat, destLng, destName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        if (availableMapUrls) {
            [availableMapUrls setValue:url forKey:SCHEME_MAPBAIDU];
        }else if (alertItems) {   JLAlertModel *alertModel = [JLAlertModel alertModel:@"百度地图" style:UIAlertActionStyleDefault action:^{
            [[UIApplication sharedApplication] openURL:url];
        } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    // 腾讯地图
    if ([self.availableMaps containsObject:SCHEME_MAPQQ]) {
        NSString *urlString = nil;
        if (_insideChina) {
            urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0", destCoordinate2D.coordinate2DGCJ02.latitude, destCoordinate2D.coordinate2DGCJ02.longitude, destName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0", destLat, destLng, destName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        if (availableMapUrls) {
            [availableMapUrls setValue:url forKey:SCHEME_MAPQQ];
        }else if (alertItems) {
            JLAlertModel *alertModel = [JLAlertModel alertModel:@"腾讯地图" style:UIAlertActionStyleDefault action:^{
                [[UIApplication sharedApplication] openURL:url];
            } color:[UIColor blackColor]];
            [alertItems addObject:alertModel];
        }
    }
    if (availableMapUrls) {
        customBlock(availableMapUrls, _executeAppleDirection);
    }else if (alertItems) {
        [controller jl_commonAlert:@"" message:@"请选择导航地图" items:alertItems cancel:YES cancelColor:[UIColor redColor] alertStyle:UIAlertControllerStyleActionSheet];
    }
}

@end
