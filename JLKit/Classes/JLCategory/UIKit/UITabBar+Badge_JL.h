//
//  UITabBar+Badge_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLTabBarBadgeSize) {
    JLTabBarBadgeSizeTiny,
    JLTabBarBadgeSizeSmall,
    JLTabBarBadgeSizeRegular,
    JLTabBarBadgeSizeBig,
};

@interface UITabBar (Badge_JL)

#pragma mark - Public

/**
 *  以点显示Badge
 */
- (void)jl_tabbarSetBadgePoint:(NSUInteger)index tabBarItemCount:(NSUInteger)tabBarItemCount tabBarBadgeSize:(JLTabBarBadgeSize)tabBarBadgeSize tabbarBadgeBackgroundColor:(UIColor *)tabbarBadgeBackgroundColor;

/**
 *  以数字显示Badge
 */
- (void)jl_tabbarSetBadgeNumber:(NSUInteger)index value:(NSUInteger)value tabBarItemCount:(NSUInteger)tabBarItemCount tabBarBadgeSize:(JLTabBarBadgeSize)tabBarBadgeSize tabbarBadgeBackgroundColor:(UIColor *)tabbarBadgeBackgroundColor textColor:(UIColor *)textColor textFont:(UIFont *)textFont;

/**
 *  移除Badge
 */
- (void)jl_tabbarRemoveBadge:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
