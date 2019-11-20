//
//  NSObject+Timer_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLTimer.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Timer_JL)

#pragma mark - Public

// 是否正在计时
- (BOOL)jl_isCountingDown;

// 初始化计时器，并开始计时
- (void)jl_startTimer:(int)countdown interval:(float)interval callback:(JLTimerBlock)callback;

// 重新计时
- (void)jl_reStartTimer;

// 停止
- (void)jl_endTimer;

// 暂停
- (void)jl_suspend;

// 继续
- (void)jl_resume;


@end

NS_ASSUME_NONNULL_END
