//
//  UIViewController+BarButtonItem_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIViewController+BarButtonItem_JL.h"
#import <BlocksKit/UIView+BlocksKit.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import "NSString+Addition_JL.h"
#import "NSAttributedString+Addition_JL.h"

@implementation UIViewController (BarButtonItem_JL)

// 增加图片类型导航按钮（左）
- (void)jl_addLeftBarButton:(UIImage *)image action:(void(^)(void))action {
    [self jl_addBarButton:YES object:image size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

// 增加图片类型导航按钮（右）
- (void)jl_addRightBarButton:(UIImage *)image action:(void(^)(void))action {
    [self jl_addBarButton:NO object:image size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

// 增加文本类型导航按钮（左）
- (void)jl_addLeftBarTextButton:(NSAttributedString *)text action:(void(^)(void))action {
    [self jl_addBarButton:YES object:text size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

// 增加文本类型导航按钮（右）
- (void)jl_addRightBarTextButton:(NSAttributedString *)text action:(void(^)(void))action {
    [self jl_addBarButton:NO object:text size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

// 增加自定义类型导航按钮（左）
- (void)jl_addLeftBarCustomView:(UIView *)customeView action:(void(^)(void))action {
    [self jl_addBarButton:YES object:customeView size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

// 增加自定义类型导航按钮（右）
- (void)jl_addRightBarCustomView:(UIView *)customeView action:(void(^)(void))action {
    [self jl_addBarButton:NO object:customeView size:CGSizeZero margin:UIEdgeInsetsZero action:action];
}

// 移除左侧导航按钮
- (void)jl_removeLeftBarButtons {
    self.navigationItem.leftBarButtonItems = nil;
}

// 移除右侧导航按钮
- (void)jl_removeRightBarButtons {
    self.navigationItem.rightBarButtonItems = nil;
}

// 增加UIBarButtonItem（Base）
- (void)jl_addBarButton:(BOOL)isLeft object:(id)object size:(CGSize)size margin:(UIEdgeInsets)margin action:(void(^)(void))action {
    
    id customView = nil;
    if ([object isKindOfClass:[UIImage class]]) {
        // 图片类型，图片保持 24 * 24
        UIImage *image = object;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal | UIControlStateHighlighted];
        if (size.width > 0 && size.height > 0) {
            button.frame = CGRectMake(0, 0, size.width, size.height);
        }else{
            button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button bk_addEventHandler:^(id sender) {
            action == nil ? : action();
        } forControlEvents:UIControlEventTouchUpInside];
        
        customView = button;
        
    }else if ([object isKindOfClass:[NSAttributedString class]]) {
        // 文本类型
        NSAttributedString *str = object;
        CGSize size = [str jl_getSize:CGSizeMake(MAXFLOAT, 24.0) enableCeil:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, size.width + 10, 24.0);
        [button setAttributedTitle:str forState:UIControlStateNormal];
        [button setAttributedTitle:str forState:UIControlStateHighlighted];
        [button bk_addEventHandler:^(id sender) {
            action == nil ? : action();
        } forControlEvents:UIControlEventTouchUpInside];
        
        customView = button;
        
    }else if ([object isKindOfClass:[UIView class]]) {
        // 自定义类型
        customView = object;
    }else{
        return;
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    UIBarButtonItem *marginLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *marginRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    marginLeft.width = margin.left;
    marginRight.width = margin.right;
    if (isLeft) {
        if ([self.navigationItem.leftBarButtonItems count] > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
            [arr addObject:marginLeft];
            [arr addObject:barButton];
            [arr addObject:marginRight];
            self.navigationItem.leftBarButtonItems = nil;
            self.navigationItem.leftBarButtonItems = arr;
        }else{
            self.navigationItem.leftBarButtonItems = @[marginLeft, barButton, marginRight];
        }
        
    }else{
        if ([self.navigationItem.rightBarButtonItems count] > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
            [arr addObject:marginLeft];
            [arr addObject:barButton];
            [arr addObject:marginRight];
            self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.rightBarButtonItems = arr;
        }else {
            self.navigationItem.rightBarButtonItems = @[marginLeft, barButton, marginRight];
        }
    }
}


@end
