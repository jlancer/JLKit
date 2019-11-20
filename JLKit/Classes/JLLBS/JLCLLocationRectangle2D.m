
//
//  JLCLLocationRectangle2D.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLCLLocationRectangle2D.h"

@interface JLCLLocationRectangle2D ()

@property (nonatomic, assign) CLLocationDegrees west;
@property (nonatomic, assign) CLLocationDegrees north;
@property (nonatomic, assign) CLLocationDegrees east;
@property (nonatomic, assign) CLLocationDegrees south;

@end

@implementation JLCLLocationRectangle2D

+ (JLCLLocationRectangle2D *)rectangle2D:(CLLocationDegrees)startLng startLat:(CLLocationDegrees)startLat endLng:(CLLocationDegrees)endLng endLat:(CLLocationDegrees)endLat {
    
    return [[JLCLLocationRectangle2D alloc] initWithStartLng:startLng startLat:startLat endLng:endLng endLat:endLat];
}

+ (JLCLLocationRectangle2D *)rectangle2D:(CLLocationCoordinate2D)startCoordinated2D endCoordinate2D:(CLLocationCoordinate2D)endCoordinate2D {
    
    return [[JLCLLocationRectangle2D alloc] initWithStartLng:startCoordinated2D.longitude startLat:startCoordinated2D.latitude endLng:endCoordinate2D.longitude endLat:endCoordinate2D.latitude];
}

- (instancetype)initWithStartLng:(CLLocationDegrees)startLng startLat:(CLLocationDegrees)startLat endLng:(CLLocationDegrees)endLng endLat:(CLLocationDegrees)endLat {
    
    self = [super init];
    if (self) {
        self.west =  MIN(startLng, endLng);
        self.north = MAX(startLat, endLat);
        self.east =  MAX(startLng, endLng);
        self.south = MIN(startLat, endLat);
    }
    return self;
}

- (BOOL)isPointInside:(CLLocationCoordinate2D)coordinate {
    
    return self.west <= coordinate.longitude && self.east >= coordinate.longitude && self.north >= coordinate.latitude && self.south <= coordinate.latitude;
}

@end
