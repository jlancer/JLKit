//
//  NSObject+Launch_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLLaunchType) {
    JLLaunchTypeUnknown         = 0x0000,
    JLLaunchTypeFirstInstalled  = 0x0001,  // （When）首次安装打开
    JLLaunchTypeUpdated         = 0x0002,  // （When）更新版本
    JLLaunchTypeFromDeskTop     = 0x0004,  // （Where）从手机桌面打开
    JLLaunchTypeFromDeepLink    = 0x0008,  // （Where）从DeepLink打开
    JLLaunchTypeFromScheme      = 0x0010,  // （Where）从Scheme打开
};

@interface NSObject (Launch_JL)

// 是否是type方式启动
+ (BOOL)jl_isLaunchType:(JLLaunchType)type;

// 设置启动方式为type
+ (void)jl_setLaunchType:(JLLaunchType)type;


@end

NS_ASSUME_NONNULL_END
