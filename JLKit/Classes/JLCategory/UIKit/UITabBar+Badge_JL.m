
//
//  UITabBar+Badge_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UITabBar+Badge_JL.h"
#import "UIView+Addition_JL.h"

// 小红点和数字Badge的背景色
#define TABBAR_BADGE_BACKGROUND_COLOR [UIColor redColor]
// 数字Badge的文字颜色
#define TABBAR_BADGE_TEXT_COLOR       [UIColor whiteColor]

@implementation UITabBar (Badge_JL)

#pragma mark - Public

/**
 *  以点显示Badge
 */
- (void)jl_tabbarSetBadgePoint:(NSUInteger)index tabBarItemCount:(NSUInteger)tabBarItemCount tabBarBadgeSize:(JLTabBarBadgeSize)tabBarBadgeSize tabbarBadgeBackgroundColor:(UIColor *)tabbarBadgeBackgroundColor {
    
    //移除之前的Badge
    [self jl_tabbarRemoveBadge:index];
    //新建小红点
    UIView *badgeView         = [[UIView alloc] init];
    badgeView.tag             = 888 + index;
    badgeView.backgroundColor = tabbarBadgeBackgroundColor ? tabbarBadgeBackgroundColor : TABBAR_BADGE_BACKGROUND_COLOR;
    CGRect tabFrame           = self.frame;
    //确定小红点的位置
    float percentX            = (index + 0.6) / tabBarItemCount;
    CGFloat x                 = ceilf(percentX * tabFrame.size.width);
    CGFloat y                 = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame           = CGRectMake(x, y, [self _tabbarBadgePointDismeter:tabBarBadgeSize], [self _tabbarBadgePointDismeter:tabBarBadgeSize]);
    [self addSubview:badgeView];
    [badgeView jl_round];
}

/**
 *  以数字显示Badge
 */
- (void)jl_tabbarSetBadgeNumber:(NSUInteger)index value:(NSUInteger)value tabBarItemCount:(NSUInteger)tabBarItemCount tabBarBadgeSize:(JLTabBarBadgeSize)tabBarBadgeSize tabbarBadgeBackgroundColor:(UIColor *)tabbarBadgeBackgroundColor textColor:(UIColor *)textColor textFont:(UIFont *)textFont {
    
    //移除之前的Badge
    [self jl_tabbarRemoveBadge:index];
    if (value <= 0) {
        return;
    }
    //新建Badge
    UILabel *badgeView        = [[UILabel alloc] init];
    badgeView.textAlignment   = NSTextAlignmentCenter;
    badgeView.tag             = 888 + index;
    badgeView.backgroundColor = tabbarBadgeBackgroundColor ? tabbarBadgeBackgroundColor : TABBAR_BADGE_BACKGROUND_COLOR;
    badgeView.text            = [self _tabbarTransforBadgeNumber:value];
    badgeView.textColor       = textColor ? textColor : TABBAR_BADGE_TEXT_COLOR;
    badgeView.font            = textFont ? textFont : [self _tabbarBadgeTextFont:tabBarBadgeSize badgeText:badgeView.text];
    CGRect tabFrame           = self.frame;
    //确定数字Badge的位置
    float percentX            = (index + 0.6) / tabBarItemCount;
    CGFloat x                 = ceilf(percentX * tabFrame.size.width);
    CGFloat y                 = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame           = CGRectMake(x, y, [self _tabbarBadgeLength:tabBarBadgeSize], [self _tabbarBadgeLength:tabBarBadgeSize]);
    [self addSubview:badgeView];
    [badgeView jl_round];
}

/**
 *  移除Badge
 */
- (void)jl_tabbarRemoveBadge:(NSUInteger)index {
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - Private

// 小红点直径
- (CGFloat)_tabbarBadgePointDismeter:(JLTabBarBadgeSize)tabBarBadgeSize {
    
    switch (tabBarBadgeSize) {
        case JLTabBarBadgeSizeTiny:
            return 4.0;
        case JLTabBarBadgeSizeSmall:
            return 6.0;
        case JLTabBarBadgeSizeRegular:
            return 8.0;
        case JLTabBarBadgeSizeBig:
            return 10.0;
    }
    return 8.0;
}

// 数字Badge边长
- (CGFloat)_tabbarBadgeLength:(JLTabBarBadgeSize)tabBarBadgeSize {
    
    switch (tabBarBadgeSize) {
        case JLTabBarBadgeSizeTiny:
            return 10.0;
        case JLTabBarBadgeSizeSmall:
            return 12.0;
        case JLTabBarBadgeSizeRegular:
            return 14.0;
        case JLTabBarBadgeSizeBig:
            return 16.0;
    }
    return 14.0;
}

- (UIFont *)_tabbarBadgeTextFont:(JLTabBarBadgeSize)tabBarBadgeSize badgeText:(NSString *)badgeText {
    
    switch (badgeText.length) {
        case 2:
        {
            switch (tabBarBadgeSize) {
                case JLTabBarBadgeSizeTiny:
                    return [UIFont systemFontOfSize:6.0];
                case JLTabBarBadgeSizeSmall:
                    return [UIFont systemFontOfSize:7.0];
                case JLTabBarBadgeSizeRegular:
                    return [UIFont systemFontOfSize:8.0];
                case JLTabBarBadgeSizeBig:
                    return [UIFont systemFontOfSize:9.0];
            }
        }
            break;
        case 1:
        {
            switch (tabBarBadgeSize) {
                case JLTabBarBadgeSizeTiny:
                    return [UIFont systemFontOfSize:8.0];
                case JLTabBarBadgeSizeSmall:
                    return [UIFont systemFontOfSize:9.0];
                case JLTabBarBadgeSizeRegular:
                    return [UIFont systemFontOfSize:10.0];
                case JLTabBarBadgeSizeBig:
                    return [UIFont systemFontOfSize:12.0];
            }
        }
    }
    return [UIFont systemFontOfSize:8.0];
}

- (NSString *)_tabbarTransforBadgeNumber:(NSUInteger)value {
    
    if (value > 99) {
        return @"99";
    }else if (value > 0) {
        return [NSString stringWithFormat:@"%d", (int)value];
    }else {
        return nil;
    }
}

@end
