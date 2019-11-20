//
//  UIView+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Geometry

@interface UIView (Addition_Geometry_JL)

// Origin
@property CGPoint jlOrigin;

// Size
@property CGSize  jlSize;

// Height
@property CGFloat jlHeight;

// Width
@property CGFloat jlWidth;

// Top
@property CGFloat jlTop;

// Left
@property CGFloat jlLeft;

// Bottom
@property CGFloat jlBottom;

// Right
@property CGFloat jlRight;

// Bottom Left
@property (readonly) CGPoint jlBottomLeft;

// Bottom Right
@property (readonly) CGPoint jlBottomRight;

// Top Left
@property (readonly) CGPoint jlTopLeft;

// Top Right
@property (readonly) CGPoint jlTopRight;

// 移动Offset单位
- (void)jl_moveBy:(CGPoint)delta;

// 比例扩大缩小
- (void)jl_scaleBy:(CGFloat)scaleFactor;

// 保证适合Size
- (void)jl_fitInSize:(CGSize)aSize;

// 判断自身是否在其它视图中
- (BOOL)jl_isInAnotherView:(UIView *)anotherView;

@end

#pragma mark - Find

@interface UIView (Addition_Find_JL)

// 根据Class查找UIView
- (__kindof UIView*)jl_findView:(Class)cls;

@end

#pragma mark - Layer

@interface UIView (Addition_Layer_JL)

// 设置圆形
- (void)jl_round;

// 设置圆形（边宽、颜色）
- (void)jl_roundWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color;

// 设置圆角（角度）
- (void)jl_cornerRadius:(CGFloat)radius;

// 设置边框（边宽，颜色）
- (void)jl_borderWidth:(CGFloat)width boderColor:(UIColor *)color;

// 设置圆角（角度，边宽，颜色）
- (void)jl_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width boderColor:(UIColor *)color;

// 设置圆角（角度、位置）
- (void)jl_cornerRadius:(CGFloat)radius corner:(UIRectCorner)corner;

// Outter Shadow（radius和skecth中的blur是对应的）
// 微调：降低opacity,提高radius；或者提高opacity，降低radius
- (void)jl_shadowOffset:(CGSize)offset color:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius;

// 创建线段
+ (UIView *)jl_createLine:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
