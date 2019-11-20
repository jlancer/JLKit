//
//  JLTabBarController.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLTabBarController : UITabBarController

@property(nonatomic, copy) BOOL(^jl_shouldSelectViewController)(__weak __kindof JLTabBarController *tabController, __weak UIViewController *viewController);

@property(nonatomic, copy) void(^jl_didSelectViewController)(__weak __kindof JLTabBarController *tabController, __weak UIViewController *viewController);

@property(nonatomic, assign) NSUInteger previousIndex;

// 添加视图控制器
- (void)jl_addChildViewController:(UIViewController *)childController tabName:(NSString *)tabname tabUnselectedImage:(id)unselectedImage tabSelectedImage:(id)selectedImage tabUnselectedTextAttrs:(NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(NSDictionary *)selectedTextAttrs navigationControllerClass:(Class)navigationControllerClass;

// 添加视图控制器
- (void)jl_addChildViewController:(UIViewController *)childController tabName:(NSString *)tabname tabUnselectedImage:(id)unselectedImage tabSelectedImage:(id)selectedImage tabUnselectedTextAttrs:(NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(NSDictionary *)selectedTextAttrs navigationControllerClass:(Class)navigationControllerClass imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets textOffset:(UIOffset)textOffset;

// 更新视图控制器
- (void)jl_updateChildViewController:(NSInteger)index childController:(UIViewController *)childController tabName:(NSString *)tabname tabUnselectedImage:(id)unselectedImage tabSelectedImage:(id)selectedImage tabUnselectedTextAttrs:(NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(NSDictionary *)selectedTextAttrs;

@end

NS_ASSUME_NONNULL_END
