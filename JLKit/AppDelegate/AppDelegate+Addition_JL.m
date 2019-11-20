//
//  AppDelegate+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "AppDelegate+Addition_JL.h"

@implementation AppDelegate (Addition_JL)

// RootViewController
- (UIViewController *)jl_rootViewController {
    return self.window.rootViewController;
}

// Selected NavigationViewController
- (__kindof UINavigationController *)jl_selectedNavigationViewController {
    UITabBarController *tabBarController = (UITabBarController *)[self jl_rootViewController];
    UINavigationController *selectedNavigationController = (UINavigationController *)tabBarController.selectedViewController;
    return selectedNavigationController;
}

// TopViewController
- (UIViewController *)jl_topViewController {
    return [self jl_topViewControllerWithRootViewController:self.window.rootViewController];
}

// TopViewController W Root
- (UIViewController *)jl_topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self jl_topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self jl_topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self jl_topViewControllerWithRootViewController:presentedViewController];
        
    } else {
        return rootViewController;
    }
}
@end
