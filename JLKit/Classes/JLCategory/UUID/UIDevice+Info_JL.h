//
//  UIDevice+Info_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Info_JL)

/** 获取设备颜色 */
+ (NSString *)jl_getDeviceColor;
/** 获取设备外壳颜色 */
+ (NSString *)jl_getDeviceEnclosureColor;
/** 获取mac地址 */
+ (NSString *)jl_getMacAddress;
/** 获取广告标识符 */
+ (NSString *)jl_getIDFA;
/** 获取设备上次重启的时间 */
+ (NSDate *)jl_getSystemUptime;

+ (NSUInteger)jl_getCPUFrequency;
/** 获取总线程频率 */
+ (NSUInteger)jl_getBusFrequency;
/** 获取当前设备主存 */
+ (NSUInteger)jl_getRamSize;

/** 获取CPU数量 */
+ (NSUInteger)jl_getCPUCount;
/** 获取CPU总的使用百分比 */
+ (float)jl_getCPUUsage;
/** 获取单个CPU使用百分比 */
+ (NSArray *)jl_getPerCPUUsage;


/** 获取本 App 所占磁盘空间 */
+ (NSString *)jl_getApplicationSize;
/** 获取磁盘总空间 */
+ (int64_t)jl_getTotalDiskSpace;
/** 获取未使用的磁盘空间 */
+ (int64_t)jl_getFreeDiskSpace;
/** 获取已使用的磁盘空间 */
+ (int64_t)jl_getUsedDiskSpace;

/** 获取总内存空间 */
+ (int64_t)jl_getTotalMemory;
/** 获取活跃的内存空间 */
+ (int64_t)jl_getActiveMemory;
/** 获取不活跃的内存空间 */
+ (int64_t)jl_getInActiveMemory;
/** 获取空闲的内存空间 */
+ (int64_t)jl_getFreeMemory;
/** 获取正在使用的内存空间 */
+ (int64_t)jl_getUsedMemory;
/** 获取存放内核的内存空间 */
+ (int64_t)jl_getWiredMemory;
/** 获取可释放的内存空间 */
+ (int64_t)jl_getPurgableMemory;

@end

NS_ASSUME_NONNULL_END
