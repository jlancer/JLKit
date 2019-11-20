
//
//  NSObject+Launch_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+Launch_JL.h"
#import <objc/runtime.h>
#import "NSString+Addition_JL.h"

@implementation NSObject (Launch_JL)

static JLLaunchType _launchType;

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _launchType = JLLaunchTypeUnknown;
        if ([NSObject _isFirstLastLaunched]) {
            [NSObject jl_setLaunchType:JLLaunchTypeFirstInstalled];
        }
        if ([NSObject _isUpdatedLaunched]) {
            [NSObject jl_setLaunchType:JLLaunchTypeUpdated];
        }
        [NSObject _updateLastLaunch];
    });
}

// 是否是type方式启动
+ (BOOL)jl_isLaunchType:(JLLaunchType)type {
    
    return _launchType & type;
}

// 设置启动方式为type
+ (void)jl_setLaunchType:(JLLaunchType)type {
    
    _launchType |= type;
}

+ (void)_updateLastLaunch {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *version = [[bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (version) {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"kJLLastLaunchVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)_isFirstLastLaunched {
    
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"kJLLastLaunchVersion"];
    if (nil == version) {
        return YES;
    }
    return NO;
}

+ (BOOL)_isUpdatedLaunched {
    
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"kJLLastLaunchVersion"];
    if (version != nil) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *currentVersion = [[bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        return [NSString jl_compare:currentVersion than:version] == JLCompareResultLarger;
    }
    return NO;
}

@end
