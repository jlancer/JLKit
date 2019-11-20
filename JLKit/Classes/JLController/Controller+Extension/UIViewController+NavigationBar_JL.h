//
//  UIViewController+NavigationBar_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationBar_JL)

// 设置是否隐藏
- (void)jl_navigationBarHidden:(BOOL)isBarHidden;

// 设置BarTintColor、Translucent和BottomLineColor
- (void)jl_navigationBarStyle:(UIColor *)barTintColor translucent:(BOOL)translucent bottomLineColor:(UIColor *)bottomLineColor;

// 设置BarTitle（NSAttributedString）
- (void)jl_navigationBarTitle:(NSAttributedString *)title;

// 设置BarTitle（NSString）
- (void)jl_navigationBarTitle:(NSString *)title titleAttrs:(NSDictionary *)titleAttrs;

// 设置默认字体格式的BarTitle（NSString）
- (void)jl_navigationDefaultBarTitle:(NSString *)title;

// (内部方法)设置BottomLineColor
- (void)_jl_setupBottomLineColor:(UIColor *)bottomLineColor;

@end

NS_ASSUME_NONNULL_END
