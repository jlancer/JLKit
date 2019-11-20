
//
//  UITabBarController+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UITabBarController+Addition_JL.h"
#import <objc/runtime.h>

@implementation UITabBarController (Addition_JL)

static void const *kJLTabBarAnimatingKey = "kJLTabBarAnimatingKey";

// property jl_tabBarAnimating
- (BOOL)JLTabBarAnimating {
    
    return [objc_getAssociatedObject(self, kJLTabBarAnimatingKey) boolValue];
}

- (void)setJLTabBarAnimating:(BOOL)JLTabBarAnimating {
    
    objc_setAssociatedObject(self, kJLTabBarAnimatingKey, [NSNumber numberWithBool:JLTabBarAnimating], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// property jl_tabBarAnimating
- (BOOL)JLTabBarHidden {
    return self.tabBar.hidden;
}

#pragma mark - Public

/**
 *  设置隐藏TabBar(hidden)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden {
    
    [self jl_setTabBarHidden:hidden animated:NO completion:NULL];
}

/**
 *  设置隐藏TabBar(hidden,animated)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    
    [self jl_setTabBarHidden:hidden animated:animated delaysContentResizing:NO completion:NULL];
}

/**
 *  设置隐藏TabBar(hidden,animated,completion)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion {
    
    [self jl_setTabBarHidden:hidden animated:animated delaysContentResizing:NO completion:completion];
}

/**
 *  设置隐藏TabBar(hidden,animated,delaysContentResizing,completion)
 */
- (void)jl_setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delaysContentResizing:(BOOL)delaysContentResizing completion:(void (^)(void))completion {
    
    if ( [self.view.subviews count] < 2 ) return;
    UIView *transitionView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        // iOS4
        transitionView = [self.view.subviews objectAtIndex:1];
    } else {
        transitionView = [self.view.subviews objectAtIndex:0]; // UITransitionView in iOS5
    }
    if (!hidden) {
        self.tabBar.hidden = NO;
    }
    [self setJLTabBarAnimating:YES];
    [UIView animateWithDuration:(animated ? UINavigationControllerHideShowBarDuration : 0)
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGFloat tabBarTop = 0;
                         if (hidden) {
                             CGRect viewFrame = [self.view convertRect:self.view.bounds toView:self.tabBar.superview];
                             tabBarTop = viewFrame.origin.y+viewFrame.size.height;
                             transitionView.frame = self.view.bounds;
                         }
                         else {
                             CGRect viewFrame = [self.view convertRect:self.view.bounds toView:self.tabBar.superview];
                             tabBarTop = viewFrame.origin.y+viewFrame.size.height-self.tabBar.frame.size.height;
                             if (!delaysContentResizing) {
                                 transitionView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                   self.view.bounds.origin.y,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height-self.tabBar.frame.size.height);
                             }
                         }
                         CGRect frame;
                         frame = self.tabBar.frame;
                         frame.origin.y = tabBarTop;
                         self.tabBar.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         if (hidden) {
                             self.tabBar.hidden = YES;
                         }
                         else {
                             if (delaysContentResizing && finished) {
                                 transitionView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                   self.view.bounds.origin.y,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - self.tabBar.frame.size.height);
                             }
                         }
                         [self setJLTabBarAnimating:NO];
                         if (completion) {
                             completion();
                         }
                     }];
}

@end
