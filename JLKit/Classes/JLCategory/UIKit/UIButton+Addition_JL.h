//
//  UIButton+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Addition_JL)

/**
 *  设置Title名称
 */
- (void)jl_setTitle:(NSString*)title;

/**
 *  设置Title颜色
 */
- (void)jl_setTitleColor:(UIColor*)color;

/**
 *  设置Title字体
 */
- (void)jl_setTitleFont:(UIFont *)font;

/**
 *  设置自定义风格的Title
 */
- (void)jl_setTitle:(NSString*)title titleColor:(UIColor*)titleColor highlightedTitleColor:(UIColor*)highlightedTitleColor titleFont:(UIFont*)titleFont textAlignment:(UIControlContentHorizontalAlignment)textAlignment backgroundColor:(UIColor*)backgroundColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius;

/**
 *  设置字体排布风格
 */
- (void)jl_setTextAlignment:(NSTextAlignment)textAlignment;

@end

NS_ASSUME_NONNULL_END
