//
//  UIDevice+NetWork_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (NetWork_JL)

/** 获取ip */
+ (NSString *)jl_getDeviceIPAddresses;

+ (NSString *)jl_getIpAddressWIFI;
+ (NSString *)jl_getIpAddressCell;

@end

NS_ASSUME_NONNULL_END
