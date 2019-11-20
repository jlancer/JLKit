//
//  NSObject+Timer_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+Timer_JL.h"
#import <objc/runtime.h>

@implementation NSObject (Timer_JL)

#pragma mark - Public

// 是否正在计时
- (BOOL)jl_isCountingDown {
    
    JLTimer *timer = [self _getTimer];
    if (timer) {
        return [timer jl_isCountingDown];
    }
    return NO;
    
}

// 初始化计时器，并开始计时
- (void)jl_startTimer:(int)countdown interval:(float)interval callback:(JLTimerBlock)callback {
    
    JLTimer *timer = [self _getTimer];
    if (!timer) {
        // 第一次初始化
        timer = [[JLTimer alloc] initWithCoutdown:countdown interval:interval callback:callback];
        [self _setTimer:timer];
        [timer jl_startTimer];
    }else {
        // 计时器存在，重新开始计时
        [timer jl_startTimer:countdown interval:interval];
        [timer jl_reStartTimer];
    }
}

// 重新计时
- (void)jl_reStartTimer {
    
    JLTimer *timer = [self _getTimer];
    [timer jl_reStartTimer];
}

// 停止
- (void)jl_endTimer {
    
    JLTimer *timer = [self _getTimer];
    [timer jl_endTimer];
}

// 暂停
- (void)jl_suspend {
    
    JLTimer *timer = [self _getTimer];
    [timer jl_suspend];
}

// 继续
- (void)jl_resume {
    
    JLTimer *timer = [self _getTimer];
    [timer jl_resume];
}

#pragma mark - Private

static void const* kJLTimer = "kJLTimer";

-(void)_setTimer:(JLTimer *)timer {
    
    objc_setAssociatedObject(self, kJLTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JLTimer *)_getTimer {
    
    return objc_getAssociatedObject(self, kJLTimer);
}

@end
