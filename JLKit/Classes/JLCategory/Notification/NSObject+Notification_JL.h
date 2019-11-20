//
//  NSObject+Notification_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Notification_JL)

#pragma mark - Public

// 发送通知（无参）
- (void)jl_postNotification:(NSString *)name;

// 发送通知（带参infos）
- (void)jl_postNotification:(NSString *)name infos:(id)infos;

// 发送通知（带参object）
- (void)jl_postNotification:(NSString *)name object:(id)object;

// 发送通知（带参object,infos）
- (void)jl_postNotification:(NSString *)name object:(id)object infos:(id)infos;

// 添加通知（Block不带参）
- (void)jl_addNotification:(NSString *)name notifyBlock:(void(^)(void))notifyBlock;

// 添加通知（Block带参,postNotificationName:object:userInfo:对应，这个object和post方法中的anObject对应，设置对应后才能触发。）
- (void)jl_addNotification:(NSString *)name notifyParameterBlock:(void(^)(NSDictionary *userInfo))notifyParameterBlock;

// 删除通知
- (void)jl_removeNotifications;

// 删除通知（通知名称）
- (void)jl_removeNotification:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
