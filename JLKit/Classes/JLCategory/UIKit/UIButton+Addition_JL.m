
//
//  UIButton+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIButton+Addition_JL.h"
#import "UIView+Addition_JL.h"

@implementation UIButton (Addition_JL)

/**
 *  设置Title名称
 */
- (void)jl_setTitle:(NSString*)title {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setTitle:title forState:UIControlStateNormal];
        [weakSelf setTitle:title forState:UIControlStateHighlighted];
    });
    
}

/**
 *  设置Title颜色
 */
- (void)jl_setTitleColor:(UIColor*)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self.titleLabel setTextColor:color];
}

/**
 *  设置Title字体
 */
- (void)jl_setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}

/**
 *  设置自定义风格的Title
 */
- (void)jl_setTitle:(NSString*)title titleColor:(UIColor*)titleColor highlightedTitleColor:(UIColor*)highlightedTitleColor titleFont:(UIFont*)titleFont textAlignment:(UIControlContentHorizontalAlignment)textAlignment backgroundColor:(UIColor*)backgroundColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius {
    
    [self jl_setTitle:title];
    [self jl_setTitleFont:titleFont];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    self.contentHorizontalAlignment = textAlignment;
    self.backgroundColor = backgroundColor;
    [self jl_cornerRadius:cornerRadius borderWidth:borderWidth boderColor:borderColor];
}

/**
 *  设置字体排布风格
 */
- (void)jl_setTextAlignment:(NSTextAlignment)textAlignment {
    
    self.titleLabel.textAlignment = textAlignment;
}

@end
