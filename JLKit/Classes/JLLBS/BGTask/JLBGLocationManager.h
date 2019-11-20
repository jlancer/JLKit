//
//  JLBGLocationManager.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLBGLocationManager : NSObject<CLLocationManagerDelegate>

// 开始监听GPS Location监听服务
- (void)startLocation:(void(^)(void))serviceDisabledBlock notAuthorizated:(void(^)(void))notAuthorizatedBlock authorized:(void(^)(void))authorizedBlock errorBlock:(void(^)(NSError *error, NSString *alertTitle, NSString *alertMessage))errorBlock updateLocationBlock:(void(^)(CLLocation *location))updateLocationBlock;

// 停止监听GPS Location监听服务
- (void)stopLocation;

@end

NS_ASSUME_NONNULL_END
