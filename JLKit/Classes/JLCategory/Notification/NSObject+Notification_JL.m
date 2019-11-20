
//
//  NSObject+Notification_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+Notification_JL.h"
#import <objc/runtime.h>

@implementation NSObject (Notification_JL)

#pragma mark - Public

// 发送通知（无参）
- (void)jl_postNotification:(NSString *)name {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:nil];
}

// 发送通知（带参infos）
- (void)jl_postNotification:(NSString *)name infos:(id)infos {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:infos];
}

// 发送通知（带参object）
- (void)jl_postNotification:(NSString *)name object:(id)object {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:nil];
}

// 发送通知（带参object,infos）
- (void)jl_postNotification:(NSString *)name object:(id)object infos:(id)infos {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:infos];
}

// 添加通知（Block不带参）
- (void)jl_addNotification:(NSString *)name notifyBlock:(void(^)(void))notifyBlock {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_callObserverWOParameter:) name:name object:nil];
    [self _setNoParamaterBlock:notifyBlock name:name];
}

// 添加通知（Block带参,postNotificationName:object:userInfo:对应，这个object和post方法中的anObject对应，设置对应后才能触发。）
- (void)jl_addNotification:(NSString *)name notifyParameterBlock:(void(^)(NSDictionary *userInfo))notifyParameterBlock {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_callObserverWParameter:) name:name object:nil];
    [self _setParamaterBlock:notifyParameterBlock name:name];
}

// 删除通知
- (void)jl_removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self _removeAllBlocks];
}

// 删除通知（通知名称）
- (void)jl_removeNotification:(NSString *)name {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [self _removeBlock:name];
}

#pragma mark - Private

- (void)_setNoParamaterBlock:(void(^)(void))notifyBlock name:(NSString *)name {
    
    [self _setBaseBlock:notifyBlock name:name];
}

- (void)_setParamaterBlock:(void(^)(NSDictionary *))notifyBlock name:(NSString *)name {
    
    [self _setBaseBlock:notifyBlock name:name];
}

- (void)_setBaseBlock:(id)notifyBlock name:(NSString *)name {
    
    NSMutableDictionary *blockMap = objc_getAssociatedObject(self, @"blockMap");
    if (blockMap == nil) {
        blockMap = [[NSMutableDictionary alloc] init];
    }
    if (notifyBlock != nil && name != nil) {
        [blockMap setObject:notifyBlock forKey:name];
    }
    objc_setAssociatedObject(self, @"blockMap", blockMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)_getBlock:(NSString *)name {
    
    NSMutableDictionary *blockMap = objc_getAssociatedObject(self, @"blockMap");
    if (blockMap == nil) {
        return nil;
    }
    return [blockMap objectForKey:name];
}

- (void)_removeBlock:(NSString *)name {
    
    NSMutableDictionary *blockMap = objc_getAssociatedObject(self, @"blockMap");
    [blockMap removeObjectForKey:name];
}

- (void)_removeAllBlocks {
    
    NSMutableDictionary *blockMap = objc_getAssociatedObject(self, @"blockMap");
    [blockMap removeAllObjects];
}


- (void)_callObserverWOParameter:(NSNotification *)notify {
    
    NSString *name = [notify name];
    void(^block)(void) = [self _getBlock:name];
    block == nil ? : block();
}

- (void)_callObserverWParameter:(NSNotification *)notify {
    
    NSString *name = [notify name];
    NSDictionary *userInfo = [notify userInfo];
    void(^block)(NSDictionary *) = [self _getBlock:name];
    block == nil ? : block(userInfo);
}


@end
