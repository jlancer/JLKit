

//
//  UIViewController+Stack_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIViewController+Stack_JL.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <dispatch/semaphore.h>

@implementation UIViewController (Stack_JL)

#pragma mark - Public

// Push
- (void)jl_push:(UIViewController *)viewController animated:(BOOL)animated {
    
    @synchronized (self) {
        
        if (![self _isPassCheckOverSeconds:1.0]) {
            // Push间隔1秒
            return;
        }
        [self _updateLastCheckPushDate];
        __block UINavigationController *navigationController;
        if ([self isKindOfClass:[UINavigationController class]]) {
            // self为UINavigationController类型
            navigationController = (UINavigationController *)self;
        }else {
            // self为其他类型控制器
            navigationController = self.navigationController;
        }
        
        if (navigationController == nil ||
            navigationController.topViewController == viewController ||
            viewController.presentingViewController != nil) {
            // 1）导航控制器为空，
            // 或者，2）导航控制器的topViewController和被Push的viewController是同一个
            // 否则，报错Pushing the same view controller instance more than once is not supported
            // 或者，3）viewController不能是模态过的控制器，否则EXC_BAD_ACCESS
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [navigationController pushViewController:viewController animated:animated];
        });
    }
}

// Present
- (void)jl_present:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    
    @synchronized (self) {
        
        if (![self _isPassCheckOverSeconds:1.0]) {
            // Present间隔1秒
            return;
        }
        [self _updateLastCheckPushDate];
        if (viewController.presentingViewController != nil ||
            viewController.navigationController != nil) {
            // 1）当viewController的模态弹出控制器不为空，
            // 否则，会报错 Application tried to present modally an active controller
            // 或者2）viewController已经被Push出来
            // 否则，同样会报1）的错误
            return;
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:viewController animated:animated completion:completion];
        });
    }
}

// Pop到上一级ViewController
- (void)jl_popToPrevious:(BOOL)animated {
    
    __block UINavigationController *navigationController = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // self为UINavigationController类型
        navigationController = (UINavigationController *)self;
    }else {
        // self为其他类型控制器
        navigationController = self.navigationController;
    }
    if ([navigationController.viewControllers count] <= 1) {
        // Controller Stack 数量小于等于1
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [navigationController popViewControllerAnimated:animated];
    });
}

// Pop到Root ViewController
- (void)jl_popToRoot:(BOOL)animated {
    
    __block UINavigationController *navigationController = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // self为UINavigationController类型
        navigationController = (UINavigationController *)self;
    }else {
        // self为其他类型控制器
        navigationController = self.navigationController;
    }
    if ([navigationController.viewControllers count] <= 1) {
        // Controller Stack 数量小于等于1
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [navigationController popToRootViewControllerAnimated:animated];
    });
}

// 消失或者上一页[默认动画转场]
- (void)jl_dismiss {
    
    [self jl_dismiss:YES];
}

// 消失或者上一页[Base]
- (void)jl_dismiss:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // UINavigationController
        UINavigationController *navigationController = (UINavigationController *)self;
        if ([navigationController.viewControllers count] > 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UINavigationController *)weakSelf popViewControllerAnimated:animated];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }else {
        // UIViewController
        if (self.navigationController != nil) {
            if ([self.navigationController.viewControllers count] > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:animated];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController dismissViewControllerAnimated:animated completion:nil];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }
}

// 消失或者Root页[默认动画转场]
- (void)jl_dismissRoot {
    
    [self jl_dismissRoot:YES];
}

// 消失或者Root页[Base]
- (void)jl_dismissRoot:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // UINavigationController
        UINavigationController *navigationController = (UINavigationController *)self;
        if ([navigationController.viewControllers count] > 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UINavigationController *)weakSelf popToRootViewControllerAnimated:animated];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }else {
        // UIViewController
        if (self.navigationController != nil) {
            if ([self.navigationController.viewControllers count] > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:animated];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController dismissViewControllerAnimated:animated completion:nil];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }
}

// 消失或者Offset页[默认动画转场]
- (void)jl_dismissOffset:(NSUInteger)offset {
    
    [self jl_dismissOffset:YES];
}

// 消失或者Offset页，当前页是0，上一页是1...[Base]
- (void)jl_dismissOffset:(NSUInteger)offset animated:(BOOL)animated {
    
    if (offset <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:[UINavigationController class]]) {
        // UINavigationController
        UINavigationController *navigationController = (UINavigationController *)self;
        if ([navigationController.viewControllers count] > 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *toVC = [((UINavigationController *)weakSelf).viewControllers objectAtIndex:((UINavigationController *)weakSelf).viewControllers.count - 1 - offset];
                [(UINavigationController *)weakSelf popToViewController:toVC animated:animated];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }else {
        // UIViewController
        if (self.navigationController != nil) {
            if ([self.navigationController.viewControllers count] > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *toVC = [((UINavigationController *)weakSelf).viewControllers objectAtIndex:((UINavigationController *)weakSelf).viewControllers.count - 1 - offset];
                    [weakSelf.navigationController popToViewController:toVC animated:animated];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController dismissViewControllerAnimated:animated completion:nil];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:animated completion:nil];
            });
        }
    }
}

#pragma mark - Private
static void const *kLastPushDate = "kLastPushDate";

- (BOOL)_isPassCheckOverSeconds:(double)seconds {
    
    double last = [self _lastCheckDate];
    double now = [[NSDate date] timeIntervalSince1970];
    if (now - last > seconds) {
        return YES;
    }
    return NO;
}

- (double)_lastCheckDate {
    
    return [objc_getAssociatedObject(self, kLastPushDate) doubleValue];
}

- (void)_updateLastCheckPushDate {
    
    NSNumber *date = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    objc_setAssociatedObject(self, kLastPushDate, date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
