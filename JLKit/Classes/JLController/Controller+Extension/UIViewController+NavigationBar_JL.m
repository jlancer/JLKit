

//
//  UIViewController+NavigationBar_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIViewController+NavigationBar_JL.h"
#import "NSString+Color_JL.h"

@implementation UIViewController (NavigationBar_JL)

// 设置是否隐藏
- (void)jl_navigationBarHidden:(BOOL)isBarHidden {
    @synchronized (self) {
        [self.navigationController setNavigationBarHidden:isBarHidden];
    }
}

// 设置BarTintColor、Translucent和BottomLineColor
- (void)jl_navigationBarStyle:(UIColor *)barTintColor translucent:(BOOL)translucent bottomLineColor:(UIColor *)bottomLineColor {
    
    [self jl_navigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = barTintColor;
    self.navigationController.navigationBar.translucent = translucent;
    [self _jl_setupBottomLineColor:bottomLineColor];
}

// 设置BarTitle（NSAttributedString）
- (void)jl_navigationBarTitle:(NSAttributedString *)title {
    
    [self jl_navigationBarHidden:NO];
    if (self.navigationItem.titleView == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        titleLabel.attributedText = title;
        self.navigationItem.titleView = titleLabel;
    }else{
        UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
        if ([titleLabel isKindOfClass:[UILabel class]]) {
            titleLabel.attributedText = title;
        }else{
            self.navigationItem.titleView = nil;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.bounds];
            titleLabel.attributedText = title;
            self.navigationItem.titleView = titleLabel;
        }
    }
}

// 设置BarTitle（NSString）
- (void)jl_navigationBarTitle:(NSString *)title titleAttrs:(NSDictionary *)titleAttrs {
    
    [self jl_navigationBarHidden:NO];
    self.navigationItem.title = title;
    self.navigationController.navigationBar.titleTextAttributes = titleAttrs;
}

// 设置默认字体格式的BarTitle（NSString）
- (void)jl_navigationDefaultBarTitle:(NSString *)title {
    
    [self jl_navigationBarHidden:NO];
    // 方法一
    if (@available(iOS 8.2, *)) {
        [self jl_navigationBarTitle:title titleAttrs:@{NSForegroundColorAttributeName : @"#1D1D1F".jl_color, NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold]}];
    } else {
        [self jl_navigationBarTitle:title titleAttrs:@{NSForegroundColorAttributeName : @"#1D1D1F".jl_color, NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    }
    // 方法二
    // NSAttributedString *attrStr = title.typeset.font(MediumWithSize(16).fontName, 16).color(HTColor1D1D1F.jl_color).textAlignment(NSTextAlignmentCenter).string;
    // [self ht_navigationBarTitle:attrStr];
}

// (内部方法)设置BottomLineColor
- (void)_jl_setupBottomLineColor:(UIColor *)bottomLineColor {
    
    UIImageView *shadowImageView = [self _jl_findHairlineImageViewUnder:self.navigationController.navigationBar];
    if (shadowImageView) {
        if (bottomLineColor == nil) {
            shadowImageView.hidden = YES;
        }else{
            shadowImageView.backgroundColor = bottomLineColor;
            shadowImageView.hidden = NO;
        }
    }
}

// (内部方法)找出一个View的子控件中高度小于等于1像素的UIImageView控件
- (UIImageView *)_jl_findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && CGRectGetHeight(view.bounds) <= 1.f) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self _jl_findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


@end
