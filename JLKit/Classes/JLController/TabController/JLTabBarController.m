

//
//  JLTabBarController.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLTabBarController.h"
#import "NSObject+AnyImage_JL.h"

@interface JLTabBarController () <UITabBarControllerDelegate>

@end

@implementation JLTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.previousIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加视图控制器
- (void)jl_addChildViewController:(UIViewController *)childController tabName:(NSString *)tabname tabUnselectedImage:(id)unselectedImage tabSelectedImage:(id)selectedImage tabUnselectedTextAttrs:(NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(NSDictionary *)selectedTextAttrs navigationControllerClass:(Class)navigationControllerClass {
    
    [self jl_addChildViewController:childController tabName:tabname tabUnselectedImage:unselectedImage tabSelectedImage:selectedImage tabUnselectedTextAttrs:unselectedTextAttrs tabSelectedTextAttrs:selectedTextAttrs navigationControllerClass:navigationControllerClass imageEdgeInsets:UIEdgeInsetsZero textOffset:UIOffsetZero];
}

// 添加视图控制器
- (void)jl_addChildViewController:(UIViewController *)childController tabName:(NSString *)tabname tabUnselectedImage:(id)unselectedImage tabSelectedImage:(id)selectedImage tabUnselectedTextAttrs:(NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(NSDictionary *)selectedTextAttrs navigationControllerClass:(Class)navigationControllerClass imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets textOffset:(UIOffset)textOffset {
    
    // 设置未选中Tab图标
    [childController.tabBarItem jl_setImage:unselectedImage isSelected:NO];
    // 设置已选中Tab图片
    [childController.tabBarItem jl_setImage:selectedImage isSelected:YES];
    // 设置Tab名称
    childController.tabBarItem.title = tabname;
    // 设置未选中Tab名称文字式样
    if (unselectedTextAttrs != nil && [unselectedTextAttrs.allKeys count] != 0) {
        [childController.tabBarItem setTitleTextAttributes:unselectedTextAttrs forState:UIControlStateNormal];
    }
    // 设置已选中Tab名称文字式样
    if (selectedTextAttrs != nil && [selectedTextAttrs.allKeys count] != 0) {
        [childController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    }
    // 将childController作为NavigationController的根
    UINavigationController *nav = nil;
    if (navigationControllerClass != nil) {
        nav = [[navigationControllerClass alloc] initWithRootViewController:childController];
    }else{
        nav = [[UINavigationController alloc] initWithRootViewController:childController];
    }
    [self addChildViewController:nav];
    
    if (imageEdgeInsets.bottom != 0 || imageEdgeInsets.top != 0 || imageEdgeInsets.left != 0 || imageEdgeInsets.right != 0) {
        childController.tabBarItem.imageInsets = imageEdgeInsets;
    }
    if (textOffset.horizontal != 0 || textOffset.vertical != 0 ) {
        childController.tabBarItem.titlePositionAdjustment = textOffset;
    }
}

// 更新视图控制器
- (void)jl_updateChildViewController:(NSInteger)index childController:(UIViewController *)childController tabName:(NSString *)tabname tabUnselectedImage:(id)unselectedImage tabSelectedImage:(id)selectedImage tabUnselectedTextAttrs:(NSDictionary *)unselectedTextAttrs tabSelectedTextAttrs:(NSDictionary *)selectedTextAttrs {
    
    UIViewController *childVC = nil;
    if (childController != nil) {
        childVC = childController;
    }else if (index >= 0 && index < self.childViewControllers.count) {
        childVC = [self.childViewControllers objectAtIndex:index];
    }
    // 设置未选中Tab图标
    [childVC.tabBarItem jl_setImage:unselectedImage isSelected:NO];
    // 设置已选中Tab图片
    [childVC.tabBarItem jl_setImage:selectedImage isSelected:YES];
    // 设置Tab名称
    childVC.tabBarItem.title = tabname;
    // 设置未选中Tab名称文字式样
    if (unselectedTextAttrs != nil && [unselectedTextAttrs.allKeys count] != 0) {
        [childVC.tabBarItem setTitleTextAttributes:unselectedTextAttrs forState:UIControlStateNormal];
    }
    // 设置已选中Tab名称文字式样
    if (selectedTextAttrs != nil && [selectedTextAttrs.allKeys count] != 0) {
        [childVC.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    }
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    if (self.jl_shouldSelectViewController != nil) {
        return _jl_shouldSelectViewController(tabBarController, viewController);
    }
    return YES;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (self.jl_didSelectViewController != nil) {
        _jl_didSelectViewController(tabBarController, viewController);
    }
    self.previousIndex = tabBarController.selectedIndex;
}

@end
