//
//  JLTimer.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLTimerBlock) (int days, int hrs, int mins, int secs, int totalsecs);


@interface JLTimer : NSObject

#pragma mark - Public

// 初始化(countdown, interval, callback)
- (id)initWithCoutdown:(int)countdown interval:(int)interval callback:(JLTimerBlock)callback;

// 是否在计时
- (BOOL)jl_isCountingDown;

// 设置回调
- (void)jl_setTimerCallback:(JLTimerBlock)callback;

// 开始计时（重复调用和第一次调用效果一样）
- (void)jl_startTimer;

- (void)jl_startTime:(long long)startTime endTime:(long long)endTime interval:(float)interval;

- (void)jl_startTimer:(int)timeout interval:(float)interval;

// 重新计时
- (void)jl_reStartTimer;

- (void)jl_reStartTime:(long long)startTime endTime:(long long)endTime interval:(float)interval;

- (void)jl_reStartTimer:(int)timeout interval:(float)interval;

// 停止
- (void)jl_endTimer;

// 暂停
- (void)jl_suspend;

// 继续
- (void)jl_resume;

// 公共方法
- (void)jl_startTimer:(int)countdown interval:(float)interval restart:(BOOL)restart;

@end

NS_ASSUME_NONNULL_END
