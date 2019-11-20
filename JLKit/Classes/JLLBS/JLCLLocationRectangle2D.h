//
//  JLCLLocationRectangle2D.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLCLLocationRectangle2D : NSObject

@property (nonatomic, assign, readonly) CLLocationDegrees west;
@property (nonatomic, assign, readonly) CLLocationDegrees north;
@property (nonatomic, assign, readonly) CLLocationDegrees east;
@property (nonatomic, assign, readonly) CLLocationDegrees south;

+ (JLCLLocationRectangle2D *)rectangle2D:(CLLocationDegrees)startLng startLat:(CLLocationDegrees)startLat endLng:(CLLocationDegrees)endLng endLat:(CLLocationDegrees)endLat;

+ (JLCLLocationRectangle2D *)rectangle2D:(CLLocationCoordinate2D)startCoordinated2D endCoordinate2D:(CLLocationCoordinate2D)endCoordinate2D;

- (instancetype)initWithStartLng:(CLLocationDegrees)startLng startLat:(CLLocationDegrees)startLat endLng:(CLLocationDegrees)endLng endLat:(CLLocationDegrees)endLat;

- (BOOL)isPointInside:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END
