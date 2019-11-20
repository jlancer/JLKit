//
//  UIViewController+Stack_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Stack_JL)

// Push
- (void)jl_push:(UIViewController *)viewController animated:(BOOL)animated;

// Present
- (void)jl_present:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

// Pop到上一级ViewController
- (void)jl_popToPrevious:(BOOL)animated;

// Pop到Root ViewController
- (void)jl_popToRoot:(BOOL)animated;

// 消失或者上一页[默认动画转场]
- (void)jl_dismiss;

// 消失或者上一页[Base]
- (void)jl_dismiss:(BOOL)animated;

// 消失或者Root页[默认动画转场]
- (void)jl_dismissRoot;

// 消失或者Root页[Base]
- (void)jl_dismissRoot:(BOOL)animated;

// 消失或者Offset页[默认动画转场]
- (void)jl_dismissOffset:(NSUInteger)offset;

// 消失或者Offset页，当前页是0，上一页是1...[Base]
- (void)jl_dismissOffset:(NSUInteger)offset animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
