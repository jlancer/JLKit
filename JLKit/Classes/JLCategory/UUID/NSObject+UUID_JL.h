//
//  NSObject+UUID_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (UUID_JL)

/**
 *  IDFA UUID
 */
+ (NSString *)jl_uuidIDFA;

/**
 *  IDFA UUID （Without Line）
 */
+ (NSString *)jl_uuidIDFANoLine;

/**
 *  IDFV UUID
 */
+ (NSString *)jl_uuidIDFV;

/**
 *  IDFV UUID （Without Line）
 */
+ (NSString *)jl_uuidIDFVNoLine;

/**
 *  随机UUID
 */
+ (NSString *)jl_uuidRandom;

/**
 *  随机UUID( + TimeStamp )
 */
+ (NSString *)jl_uuidRandomTimestamp;

@end

NS_ASSUME_NONNULL_END
