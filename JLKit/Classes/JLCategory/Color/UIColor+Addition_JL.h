//
//  UIColor+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLGradientChangeDirection) {
    JLGradientChangeDirectionHorizontal,           // 水平渐变
    JLGradientChangeDirectionVertical,             // 竖直渐变
    JLGradientChangeDirectionUpwardDiagonalLine,   // 向下对角线渐变
    JLGradientChangeDirectionDownDiagonalLine,     // 向上对角线渐变
};

@interface UIColor (Addition_JL)

#pragma mark - 生成颜色

// 十六进制颜色
+ (UIColor *)jl_colorHexString:(NSString *)hexString;

// 十六进制颜色（alpha）
+ (UIColor *)jl_colorHexString:(NSString *)hexString withAlpha:(float)alpha;

// 创建的渐变颜色
+ (UIColor *)jl_colorGradient:(CGSize)size direction:(JLGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor;

#pragma mark - 校验颜色

// 颜色是否相同
- (BOOL)jl_colorIsEqual:(UIColor *)anotherColor;

// 求当前颜色近似的颜色（目前只返回黑色和白色）
- (UIColor *)jl_colorSemilar;

#pragma mark - 获取RGB值和Alpha值

// 获取ColorSpaceModel
- (CGColorSpaceModel)_colorSpaceModel;

/**
 *  获取颜色的Red值
 */
- (CGFloat)jl_red;

/**
 *  获取颜色的Green值
 */
- (CGFloat)jl_green;

/**
 *  获取颜色的Blue值
 */
- (CGFloat)jl_blue;

/**
 *  获取颜色的Alpha值
 */
- (CGFloat)jl_alpha;

@end

NS_ASSUME_NONNULL_END
