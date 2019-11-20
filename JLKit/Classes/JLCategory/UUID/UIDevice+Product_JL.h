//
//  UIDevice+Product_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Product_JL)

/**
 *  获取设备名称
*/
+ (const NSString *)jl_getDiviceName;

/**
 *  获取设备初始系统型号
*/
+ (const NSString *)jl_getInitialVersion;

/**
 *  获取设备支持的最高系统型号
*/
+ (const NSString *)jl_getLatestVersion;

/**
 *  获取设备电池容量，单位 mA 毫安
*/
+ (NSInteger)jl_getBatteryCapacity;

/**
 *  获取电池电压，单位 V 福特
*/
+ (CGFloat)jl_getBatterVolocity;

/**
 *  获取CPU处理器名称
*/
+ (const NSString *)jl_getCPUProcessor;

/**
 *  得到当前手机所属运营商名称，如果没有则为nil
*/
+ (NSString *)jl_getPhoneOperatorName;


/**
 *  得到当前手机号的国家代码，如果没有则为nil
*/
+ (NSString *)jl_getISOCountryCode;

/**
 *  得到移动国家码
*/
+ (NSString *)jl_getMobileCountryCode;

@end

NS_ASSUME_NONNULL_END
