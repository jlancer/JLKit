//
//  JLClock.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLClock : NSObject

/// The shared clock instance default 1s.
+ (instancetype)clock;

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;

/// The curent date and time. Observable.
@property (strong, readonly, nonatomic) NSDate *date;

/// The clock timeInterval.
@property (assign, nonatomic) NSTimeInterval timeInterval;

@end

NS_ASSUME_NONNULL_END
