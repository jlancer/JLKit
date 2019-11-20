//
//  AppDelegate+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Addition_JL)

// RootViewController
- (UIViewController *)jl_rootViewController;

// Selected NavigationViewController
- (__kindof UINavigationController *)jl_selectedNavigationViewController;

// TopViewController
- (UIViewController *)jl_topViewController;

// TopViewController W Root
- (UIViewController *)jl_topViewControllerWithRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
