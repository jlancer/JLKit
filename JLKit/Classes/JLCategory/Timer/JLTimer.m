//
//  JLTimer.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLTimer.h"

@interface JLTimer() {
    int _countdown;
    int _interval;
    int _curDays;
    int _curHours;
    int _curMinutes;
    int _curSeconds;
    int _curTimeout;
}

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy)   JLTimerBlock block;

@end

@implementation JLTimer

- (void)dealloc {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - Public

- (id)initWithCoutdown:(int)countdown interval:(int)interval callback:(JLTimerBlock)callback {
    
    self = [super init];
    if (self) {
        _countdown = countdown;
        _interval = interval;
        _block = callback;
    }
    return self;
}

// 是否在计时
- (BOOL)jl_isCountingDown {
    
    return self.timer != nil;
}

// 设置回调
- (void)jl_setTimerCallback:(JLTimerBlock)callback {
    
    if (_block) {
        _block = nil;
    }
    _block = callback;
}

// 开始计时（重复调用和第一次调用效果一样）
- (void)jl_startTimer {
    
    [self jl_startTimer:_countdown interval:_interval restart:NO];
}

- (void)jl_startTime:(long long)startTime endTime:(long long)endTime interval:(float)interval {
    
    [self jl_startTimer:(int)(endTime - startTime) interval:interval restart:NO];
}

- (void)jl_startTimer:(int)timeout interval:(float)interval {
    
    [self jl_startTimer:timeout interval:interval restart:NO];
}

// 重新计时
- (void)jl_reStartTimer {
    
    [self jl_startTimer:_countdown interval:_interval restart:YES];
}

- (void)jl_reStartTime:(long long)startTime endTime:(long long)endTime interval:(float)interval {
    
    [self jl_startTimer:(int)(endTime - startTime) interval:interval restart:YES];
}

- (void)jl_reStartTimer:(int)timeout interval:(float)interval {
    
    [self jl_startTimer:timeout interval:interval restart:YES];
}

// 停止
- (void)jl_endTimer {
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [self _setCurrentDays:0 hours:0 minutes:0 seconds:0];
    _block == nil ? : _block(0,0,0,0,0);
}

// 暂停
- (void)jl_suspend {
    
    [self jl_startTimer:0 interval:0 restart:YES];
    _block == nil ? : _block(_curDays, _curHours, _curMinutes, _curSeconds, _curDays * 24 * 60 * 60 + _curHours * 60 * 60 + _curMinutes * 60 + _curSeconds );
}

// 继续
- (void)jl_resume {
    
    [self jl_startTimer:_curTimeout interval:_interval restart:YES];
}

// 公共方法
- (void)jl_startTimer:(int)countdown interval:(float)interval restart:(BOOL)restart {
    
    if (restart == YES) {
        if (_timer) {
            dispatch_source_set_event_handler(_timer, NULL);
            _timer = nil;
        }
    }
    if (_timer == nil) {
        __block int time = countdown;
        if (time != 0) {
            __weak typeof(self) weakSelf = self;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            
            // 每period秒执行一次
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(_timer, ^{
                if(time <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(weakSelf.timer);
                    weakSelf.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf _setCurrentDays:0 hours:0 minutes:0 seconds:0];
                        weakSelf.block == nil ? : weakSelf.block(0,0,0,0,0);
                    });
                }else{
                    int days =   (int) (time / (3600 * 24) );
                    int hours =  (int) ((time - days * 24 * 3600) / 3600);
                    int minute = (int) (time - days * 24 * 3600 - hours * 3600) / 60;
                    int second = time - days * 24 * 3600 - hours * 3600 - minute * 60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf != nil) {
                            [weakSelf _setCurrentDays:days hours:hours minutes:minute seconds:second];
                        }
                        weakSelf.block == nil ? : weakSelf.block(days, hours, minute, second, days * 24 * 60 * 60 + hours * 60 * 60 + minute * 60 + second);
                    });
                    time--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

#pragma mark - Private

- (void)_setCurrentDays:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds {
    
    _curDays = days;
    _curHours = hours;
    _curMinutes = minutes;
    _curSeconds = seconds;
    _curTimeout = (days * days * 24 * 3600) + (hours * 3600) + (minutes * 60) + seconds;
}


@end
