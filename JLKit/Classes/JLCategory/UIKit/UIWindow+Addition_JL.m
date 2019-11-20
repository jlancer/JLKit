

//
//  UIWindow+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIWindow+Addition_JL.h"

@implementation UIWindow (Addition_JL)

/**
 *  获取 KeyWindow Actived UIViewController
 */
+ (UIViewController *)jl_keyWindowActivityViewController {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [window jl_activityViewController];
}

/**
 *  获取 KeyWindow Presented ViewController
 */
+ (UIViewController *)jl_keyWindowPresentedViewController {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [window jl_presentedViewController];
}

/**
 *  获取 KeyWindow 当前TopViewController
 */
+ (UIViewController*)jl_currentTopViewController {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [window jl_currentTopViewController];
}

/**
 *  获取 Actived UIViewController
 */
- (UIViewController *)jl_activityViewController {
    
    UIViewController* activityViewController = nil;
    if(self.windowLevel != UIWindowLevelNormal) {
        return nil;
    }
    NSArray *viewsArray = [self subviews];
    if([viewsArray count] > 0) {
        UIView *frontView = [viewsArray firstObject];
        id nextResponder = [frontView nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        } else {
            activityViewController = self.rootViewController;
        }
    }
    return activityViewController;
}

/**
 *  获取 Presented ViewController
 */
- (UIViewController *)jl_presentedViewController {
    
    UIViewController* topVC = nil;
    if(self.windowLevel != UIWindowLevelNormal) {
        return nil;
    }
    topVC = self.rootViewController;
    while (YES) {
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }else {
            break;
        }
    }
    return topVC;
}

/**
 *  获取 当前TopViewController
 */
- (UIViewController*)jl_currentTopViewController {
    
    UIViewController *currentViewController = self.rootViewController;
    while ([currentViewController presentedViewController])    currentViewController = [currentViewController presentedViewController];
    
    if ([currentViewController isKindOfClass:[UITabBarController class]]
        && ((UITabBarController*)currentViewController).selectedViewController != nil ) {
        currentViewController = ((UITabBarController*)currentViewController).selectedViewController;
    }
    
    while ([currentViewController isKindOfClass:[UINavigationController class]]
           && [(UINavigationController*)currentViewController topViewController]) {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }
    return currentViewController;
}

/**
 *  Window上的Controller是否初始化完成
 */
- (BOOL)jl_isControllerLoaded {

    if (self.rootViewController == nil) {
        return NO;
    }
    if ([self.rootViewController isKindOfClass:[UITabBarController class]] && self.rootViewController.childViewControllers.count > 0) {
        UIViewController *firstTabChildController = [self.rootViewController.childViewControllers objectAtIndex:0];
        if ([firstTabChildController isKindOfClass:[UINavigationController class]]) {
            // UITabController+UINavigationController结构
            if (((UINavigationController *)firstTabChildController).viewControllers.count > 0) {
                // UINavigationController的Controller栈非空
                UIViewController *firstNavController = [((UINavigationController *)firstTabChildController).viewControllers objectAtIndex:0];
                return firstNavController.isViewLoaded;
            }else{
                // UINavigationController的Controller栈空
                return firstTabChildController.isViewLoaded;
            }
        }else if ([firstTabChildController isKindOfClass:[UIViewController class]]) {
            // UITabController+UIViewController结构
            return firstTabChildController.isViewLoaded;
        }
    }else if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        // UINavigationController结构
        if (((UINavigationController *)self.rootViewController).viewControllers.count > 0) {
            // UINavigationController的Controller栈非空
            UIViewController *firstNavController = [((UINavigationController *)self.rootViewController).viewControllers objectAtIndex:0];
            return firstNavController.isViewLoaded;
        }else {
            // UINavigationController的Controller栈空
            return self.rootViewController.isViewLoaded;
        }
    }else if ([self.rootViewController isKindOfClass:[UIViewController class]]) {
        // UIViewController结构
        return self.rootViewController.isViewLoaded;
    }
    return YES;
}


@end
