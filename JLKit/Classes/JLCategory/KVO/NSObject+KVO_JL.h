//
//  NSObject+KVO_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLKVOBlock)(__weak id obj, id oldValue, id newValue);
typedef void(^JLNotificationBlock)(NSNotification *notification);

@interface NSObject (KVO_JL)

// 添加KVO监听
- (void)jl_addObserverBlockForKeyPath:(NSString *)keyPath block:(JLKVOBlock)block;

// 移除KVO监听
- (void)jl_removeObserverBlockForKeyPath:(NSString *)keyPath;

// 移除全部KVO监听
- (void)jl_removeAllObserverBlocks;

// 添加通知
- (void)jl_addNotificationBlockForName:(NSString *)name block:(JLNotificationBlock)block;

// 移除通知
- (void)jl_removeNotificationBlockForName:(NSString *)name;

// 移除全部通知
- (void)jl_removeAllNotificationBlocks;

// 发送通知
- (void)jl_postNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
