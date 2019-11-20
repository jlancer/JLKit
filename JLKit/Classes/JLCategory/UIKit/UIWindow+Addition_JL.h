//
//  UIWindow+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (Addition_JL)

/**
 *  获取 KeyWindow Actived UIViewController
 */
+ (UIViewController *)jl_keyWindowActivityViewController;

/**
 *  获取 KeyWindow Presented ViewController
 */
+ (UIViewController *)jl_keyWindowPresentedViewController;

/**
 *  获取 KeyWindow 当前TopViewController
 */
+ (UIViewController*)jl_currentTopViewController;

/**
 *  获取 Actived UIViewController
 */
- (UIViewController *)jl_activityViewController;

/**
 *  获取 Presented ViewController
 */
- (UIViewController *)jl_presentedViewController;

/**
 *  获取 当前TopViewController
 */
- (UIViewController*)jl_currentTopViewController;

/**
 *  Window上的Controller是否初始化完成
 */
- (BOOL)jl_isControllerLoaded;

@end

NS_ASSUME_NONNULL_END
