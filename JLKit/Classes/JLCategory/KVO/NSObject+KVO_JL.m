//
//  NSObject+KVO_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+KVO_JL.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface _JLKVOTarget : NSObject
{
    NSMutableSet *_JLKvoBlocks;
    NSMutableSet *_JLNotifications;
}

- (void)jl_addKVOBlock:(JLKVOBlock)block;
- (void)jl_addNotificationBlock:(JLNotificationBlock)block;
- (void)jl_doNotification:(NSNotification *)notification;

@end

@implementation _JLKVOTarget

- (instancetype)init
{
    self = [super init];
    if (self) {
        _JLKvoBlocks = [[NSMutableSet alloc] init];
        _JLNotifications = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)jl_addKVOBlock:(void(^)(__weak id obj, id oldValue, id newValue))block {
    
    [_JLKvoBlocks addObject:[block copy]];
}

- (void)jl_addNotificationBlock:(void(^)(NSNotification *notification))block {
    
    [_JLNotifications addObject:[block copy]];
}

- (void)jl_doNotification:(NSNotification *)notification {
    
    if (_JLNotifications.count > 0) {
        [_JLNotifications enumerateObjectsUsingBlock:^(JLNotificationBlock block, BOOL * _Nonnull stop) {
            block(notification);
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    // NSKeyValueObservingOptionNew：当options中包括了这个参数的时候，观察者收到的change参数中就会包含NSKeyValueChangeNewKey和它对应的值，也就是说，观察者可以得知这个property在被改变之后的新值。
    // NSKeyValueObservingOptionOld：和NSKeyValueObservingOptionNew的意思类似，当包含了这个参数的时候，观察者收到的change参数中就会包含NSKeyValueChangeOldKey和它对应的值。
    // NSKeyValueObservingOptionInitial：当包含这个参数的时候，在addObserver的这个过程中，就会有一个notification被发送到观察者那里，反之则没有。
    // NSKeyValueObservingOptionPrior：当包含这个参数的时候，在被观察的property的值改变前和改变后，系统各会给观察者发送一个change notification；在property的值改变之前发送的change notification中，change参数会包含NSKeyValueChangeNotificationIsPriorKey并且值为@YES，但不会包含NSKeyValueChangeNewKey和它对应的值。
    if (_JLKvoBlocks.count > 0) {
        BOOL prior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
        if (prior) {
            // 改变前的信息
            return;
        }
        NSKeyValueChange kind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
        if (kind != NSKeyValueChangeSetting) {
            // 非设置的，其它还有NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, NSKeyValueChangeReplacement
            return;
        }
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (oldValue == [NSNull null]) {
            oldValue = nil;
        }
        if (newValue == [NSNull null]) {
            newValue = nil;
        }
        [_JLKvoBlocks enumerateObjectsUsingBlock:^(JLKVOBlock block, BOOL * _Nonnull stop) {
            block(object, oldValue, newValue);
        }];
    }
}

@end

// 保存[NSString : JLKVOBlock]字典
static void *const kJLKVOBlockKey = "kJLKVOBlockKey";

// 保存[NSString : JLNotificationBlock]字典
static void *const kJLNotificationBlockKey = "kJLNotificationBlockKey";

// KVO信号量（使用信号量保证线程安全）
static void *const kSemaphoreKVO = "kSemaphoreKVO";

// Notification信号量（使用信号量保证线程安全）
static void *const kSemaphoreNotification = "kSemaphoreNotification";

// 替换dealloc方法标记
static void *const kSwizzledDealloc = "kSwizzledDealloc";

@implementation NSObject (KVO_JL)

// 添加KVO监听
- (void)jl_addObserverBlockForKeyPath:(NSString *)keyPath block:(JLKVOBlock)block {
    
    if (!keyPath || !block) {
        return;
    }
    dispatch_semaphore_t semaphore = [self _jl_getSemaphore:kSemaphoreKVO];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // 取出保存KVOTarget字典
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kJLKVOBlockKey);
    if (!allTargets) {
        allTargets = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, kJLKVOBlockKey, allTargets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // 取出对应的Target(以keyPath存储)
    _JLKVOTarget *target = [allTargets objectForKey:keyPath];
    if (!target) {
        target = [[_JLKVOTarget alloc] init];
        [allTargets setObject:target forKey:keyPath];
        // 注册监听
        [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    [target jl_addKVOBlock:block];
    [self _jl_swizzleDealloc];
    dispatch_semaphore_signal(semaphore);
}

// 移除KVO监听
- (void)jl_removeObserverBlockForKeyPath:(NSString *)keyPath {
    
    if (!keyPath) {
        return;
    }
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kJLKVOBlockKey);
    if (!allTargets) {
        return;
    }
    _JLKVOTarget *target = [allTargets objectForKey:keyPath];
    if (!target) {
        return;
    }
    dispatch_semaphore_t semaphore = [self _jl_getSemaphore:kSemaphoreKVO];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self removeObserver:target forKeyPath:keyPath];
    [allTargets removeObjectForKey:keyPath];
    dispatch_semaphore_signal(semaphore);
}

// 移除全部KVO监听
- (void)jl_removeAllObserverBlocks {
    
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kJLKVOBlockKey);
    if (!allTargets) {
        return;
    }
    dispatch_semaphore_t semaphore = [self _jl_getSemaphore:kSemaphoreKVO];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSEnumerator *enumerator = [allTargets keyEnumerator];
    NSString *key = nil;
    while (key = [enumerator nextObject]) {
        _JLKVOTarget *target = allTargets[key];
        [self removeObserver:target forKeyPath:key];
    }
    [allTargets removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

// 添加通知
- (void)jl_addNotificationBlockForName:(NSString *)name block:(JLNotificationBlock)block {
    if (!name || !block) {
        return;
    }
    dispatch_semaphore_t semaphore = [self _jl_getSemaphore:kSemaphoreNotification];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // 取出保存KVOTarget字典
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kJLNotificationBlockKey);
    if (!allTargets) {
        allTargets = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, kJLNotificationBlockKey, allTargets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _JLKVOTarget *target = [allTargets objectForKey:name];
    if (!target) {
        target = [[_JLKVOTarget alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(jl_doNotification:) name:name object:nil];
    }
    [target jl_addNotificationBlockForName:name block:block];
    [self _jl_swizzleDealloc];
    dispatch_semaphore_signal(semaphore);
}

// 移除通知
- (void)jl_removeNotificationBlockForName:(NSString *)name {
    if (!name) {
        return;
    }
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kJLNotificationBlockKey);
    if (!allTargets) {
        return;
    }
    _JLKVOTarget *target = [allTargets objectForKey:name];
    if (!target) {
        return;
    }
    dispatch_semaphore_t semaphore = [self _jl_getSemaphore:kSemaphoreNotification];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [[NSNotificationCenter defaultCenter] removeObserver:target];
    [allTargets removeObjectForKey:name];
    dispatch_semaphore_signal(semaphore);
}

// 移除全部通知
- (void)jl_removeAllNotificationBlocks {
    NSMutableDictionary *allTargets = objc_getAssociatedObject(self, kJLNotificationBlockKey);
    if (!allTargets) {
        return;
    }
    dispatch_semaphore_t semaphore = [self _jl_getSemaphore:kSemaphoreNotification];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [allTargets enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _JLKVOTarget *target, BOOL * _Nonnull stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:target];
    }];
    [allTargets removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

// 发送通知
- (void)jl_postNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

- (dispatch_semaphore_t)_jl_getSemaphore:(void *)key {
    
    dispatch_semaphore_t semaphore = objc_getAssociatedObject(self, key);
    if (!semaphore) {
        semaphore = dispatch_semaphore_create(1);
        objc_setAssociatedObject(self, key, semaphore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return semaphore;
}

- (void)_jl_swizzleDealloc {
    
    BOOL swizzled = [objc_getAssociatedObject(self, kSwizzledDealloc) boolValue];
    if (swizzled) {
        return;
    }
    Class swizzleClass = [self class];
    @synchronized(swizzleClass) {
        
        swizzled = [objc_getAssociatedObject(self, kSwizzledDealloc) boolValue];
        if (swizzled) {
            return;
        }
        
        // 获取原有的dealloc方法
        SEL deallocSelector = sel_registerName("dealloc");
        // 初始化一个函数指针用于保存原有的dealloc方法
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        // 实现我们自己的dealloc方法，通过block的方式
        id newDealloc = ^(__unsafe_unretained id objSelf) {
            // 在这里我们移除所有的KVO
            [objSelf jl_removeAllObserverBlocks];
            // 移除所有通知
            [objSelf jl_removeAllNotificationBlocks];
            // 根据原有的dealloc方法是否存在进行判断
            if (originalDealloc == NULL) {
                // 如果不存在，说明本类没有实现dealloc方法，则需要向父类发送dealloc消息(objc_msgSendSuper)
                // 构造objc_msgSendSuper所需要的参数，.receiver为方法的实际调用者，即为类本身，.super_class指向其父类
                struct objc_super superInfo = {
                    .receiver = objSelf,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                // 构建objc_msgSendSuper函数
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                //向super发送dealloc消息
                msgSend(&superInfo, deallocSelector);
            }else{
                // 如果存在，表明该类实现了dealloc方法，则直接调用即可
                // 调用原有的dealloc方法
                originalDealloc(objSelf, deallocSelector);
            }
        };
        // 根据block构建新的dealloc实现IMP
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        // 尝试添加新的dealloc方法，如果该类已经复写的dealloc方法则不能添加成功，反之则能够添加成功
        // "v@:"  这是一个void类型的方法，没有参数传入;
        // "i@:"  这是一个int类型的方法，没有参数传入;
        // "i@:@" 这是一个int类型的方法，有一个参数传入。
        if (!class_addMethod(swizzleClass, deallocSelector, newDeallocIMP, "v@:")) {
            // 如果没有添加成功则保存原有的dealloc方法，用于新的dealloc方法中
            Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        // 标记该类已经调剂过了
        objc_setAssociatedObject(self.class, kSwizzledDealloc, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


@end
