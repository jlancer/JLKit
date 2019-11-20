//
//  NSObject+GCD_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GCD_JL)

// 延迟GCD
+ (dispatch_block_t)jl_gcdAfter:(NSTimeInterval)seconds onMainThread:(BOOL)onMainThread key:(void *)key block:(void(^)(void))block;

// 取消GCD（Key）
+ (void)jl_gcdCancelKey:(void *)key;

// 取消GCD（Block）
+ (void)jl_gcdCancelBlock:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
