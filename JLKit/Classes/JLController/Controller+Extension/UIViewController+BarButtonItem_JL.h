//
//  UIViewController+BarButtonItem_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BarButtonItem_JL)

// 增加图片类型导航按钮（左）
- (void)jl_addLeftBarButton:(UIImage *)image action:(void(^)(void))action;

// 增加图片类型导航按钮（右）
- (void)jl_addRightBarButton:(UIImage *)image action:(void(^)(void))action;

// 增加文本类型导航按钮（左）
- (void)jl_addLeftBarTextButton:(NSAttributedString *)text action:(void(^)(void))action;

// 增加文本类型导航按钮（右）
- (void)jl_addRightBarTextButton:(NSAttributedString *)text action:(void(^)(void))action;

// 增加自定义类型导航按钮（左）
- (void)jl_addLeftBarCustomView:(UIView *)customeView action:(void(^)(void))action;

// 增加自定义类型导航按钮（右）
- (void)jl_addRightBarCustomView:(UIView *)customeView action:(void(^)(void))action;

// 移除左侧导航按钮
- (void)jl_removeLeftBarButtons;

// 移除右侧导航按钮
- (void)jl_removeRightBarButtons;

// 增加UIBarButtonItem（Base）
- (void)jl_addBarButton:(BOOL)isLeft object:(id)object size:(CGSize)size margin:(UIEdgeInsets)margin action:(void(^)(void))action;

@end

NS_ASSUME_NONNULL_END
