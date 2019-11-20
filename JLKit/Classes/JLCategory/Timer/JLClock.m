//
//  JLClock.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLClock.h"

@interface JLClock ()

@property (strong, readwrite, nonatomic) NSDate *date;

@end

@implementation JLClock
{
    dispatch_source_t _timer;
}

+ (instancetype)clock {
    static JLClock *_clock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _clock = [[JLClock alloc] initWithTimeInterval:1.0 * NSEC_PER_SEC];
    });
    return _clock;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval {
    self = [super init];
    if (self) {
        [self _updateDate];
        
        _timeInterval = timeInterval;
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, _timeInterval, 0.0);
        
        __weak JLClock *weakSelf = self;
        dispatch_source_set_event_handler(timer, ^{
            [weakSelf _updateDate];
        });
        
        _timer = timer;
        dispatch_resume(timer);
    }
    return self;
}

- (void)dealloc {
    if (NULL != _timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)_updateDate {
    self.date = [NSDate date];
}
@end
