//
//  JLMapNavManager.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JLCLLocationCoordinate2D.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLMapNavVoidBlock)(void);

// 苹果地图
#define SCHEME_MAPAPPLE  @"self"
// Google地图
#define SCHEME_MAPGOOGLE @"comgooglemaps://"
// 高德地图
#define SCHEME_MAPGAODE  @"iosamap://"
// 百度地图
#define SCHEME_MAPBAIDU  @"baidumap://"
// 腾讯地图
#define SCHEME_MAPQQ     @"qqmap://"

@interface JLMapNavManager : NSObject

+ (JLMapNavManager *)shared;

- (void)jl_mapStartNavi:(CLLocationDegrees)orgLng orgLat:(CLLocationDegrees)orgLat destLng:(CLLocationDegrees)destLng destLat:(CLLocationDegrees)destLat destName:(NSString *)destName coordinateSystem:(JLCoordinateSystem)coordinateSystem appScheme:(NSString *)appScheme fromController:(UIViewController * _Nonnull)controller customBlock:(void(^)(NSDictionary *availableMapUrls, JLMapNavVoidBlock executeMapAppleDirection))customBlock;

@end

NS_ASSUME_NONNULL_END
