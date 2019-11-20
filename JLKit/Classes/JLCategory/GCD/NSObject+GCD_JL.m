

//
//  NSObject+GCD_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+GCD_JL.h"
#import <objc/runtime.h>

@implementation NSObject (GCD_JL)

// 延迟GCD
+ (dispatch_block_t)jl_gcdAfter:(NSTimeInterval)seconds onMainThread:(BOOL)onMainThread key:(void *)key block:(void(^)(void))block {
    
    dispatch_block_t callback = dispatch_block_create(DISPATCH_BLOCK_BARRIER, block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), onMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), callback);
    objc_setAssociatedObject(self, key, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return callback;
}

// 取消GCD（Key）
+ (void)jl_gcdCancelKey:(void *)key {
    
    dispatch_block_t block = objc_getAssociatedObject(self, key);
    if (block != nil) {
        dispatch_block_cancel(block);
    }
}

// 取消GCD（Block）
+ (void)jl_gcdCancelBlock:(dispatch_block_t)block {
    
    if (block != nil) {
        dispatch_block_cancel(block);
    }
}


@end
