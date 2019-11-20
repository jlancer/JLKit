//
//  UITabBarController+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (Addition_JL)

// Animation Property
@property(nonatomic, assign, readonly) BOOL JLTabBarAnimating;

// TabBar Hidden Property
@property(nonatomic, assign, readonly) BOOL JLTabBarHidden;

#pragma mark - Public

/**
 *  设置隐藏TabBar(hidden)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden;

/**
 *  设置隐藏TabBar(hidden,animated)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 *  设置隐藏TabBar(hidden,animated,completion)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  设置隐藏TabBar(hidden,animated,delaysContentResizing,completion)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delaysContentResizing:(BOOL)delaysContentResizing completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
