
//
//  UIView+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIView+Addition_JL.h"

#pragma mark - Geometry

// CGRect转换成CGPoint
CGPoint CGRectGetCenter(CGRect rect) {
    
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

// CGRect移动到CGPoint中心点
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center) {
    
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x - CGRectGetMidX(rect);
    newrect.origin.y = center.y - CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (Addition_Geometry_JL)

// 获取和设置UIView属性 - 原点
- (CGPoint)jlOrigin {
    
    return self.frame.origin;
}


- (void)setjlOrigin:(CGPoint)jlOrigin {
    
    CGRect newframe = self.frame;
    newframe.origin = jlOrigin;
    self.frame = newframe;
}

// 获取和设置UIView属性 - 尺寸
- (CGSize)jlSize {
    
    return self.frame.size;
}

- (void)setjlSize:(CGSize)jlSize {
    
    CGRect newframe = self.frame;
    newframe.size = jlSize;
    self.frame = newframe;
}

// 获取和设置UIView属性 - 高度
- (CGFloat)jlHeight {
    
    return self.frame.size.height;
}

- (void)setjlHeight:(CGFloat)jlHeight {
    
    CGRect newframe = self.frame;
    newframe.size.height = jlHeight;
    self.frame = newframe;
}

// 获取和设置UIView属性 - 宽度
- (CGFloat)jlWidth {
    
    return self.frame.size.width;
}

- (void)setjlWidth:(CGFloat)jlWidth {
    
    CGRect newframe = self.frame;
    newframe.size.width = jlWidth;
    self.frame = newframe;
}

// 获取和设置UIView属性 - 顶边
- (CGFloat)jlTop {
    
    return self.frame.origin.y;
}

- (void)setjlTop:(CGFloat)jlTop {
    
    CGRect newframe = self.frame;
    newframe.origin.y = jlTop;
    self.frame = newframe;
}

// 获取和设置UIView属性 - 左边
- (CGFloat)jlLeft {
    
    return self.frame.origin.x;
}

- (void)setjlLeft:(CGFloat)jlLeft {
    
    CGRect newframe = self.frame;
    newframe.origin.x = jlLeft;
    self.frame = newframe;
}

// 获取和设置UIView属性 - 底边
- (CGFloat)jlBottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setjlBottom:(CGFloat)jlBottom {
    
    CGRect newframe = self.frame;
    newframe.origin.y = jlBottom - self.frame.size.height;
    self.frame = newframe;
}

// 获取和设置UIView属性 - 右边
- (CGFloat)jlRight {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setjlRight:(CGFloat)jlRight {
    
    CGFloat delta = jlRight - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

// 获取UIView属性 - 底左边
- (CGPoint)jlBottomLeft {
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

// 获取UIView属性 - 底右边
- (CGPoint)jlBottomRight {
    
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

// 获取UIView属性 - 上左边
- (CGPoint)jlTopLeft {
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

// 获取UIView属性 - 上右边
- (CGPoint)jlTopRight {
    
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

// 移动Offset单位
- (void)jl_moveBy:(CGPoint)delta {
    
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// 比例扩大缩小
- (void)jl_scaleBy:(CGFloat)scaleFactor {
    
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// 保证适合Size
- (void)jl_fitInSize:(CGSize)aSize {
    
    CGFloat scale;
    CGRect newframe = self.frame;
    if (newframe.size.height && (newframe.size.height > aSize.height)) {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width)) {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    self.frame = newframe;
}

// 判断自身是否在其它视图中
- (BOOL)jl_isInAnotherView:(UIView *)anotherView {
    
    CGRect rect = [self convertRect:self.frame toView:anotherView];
    if (CGRectIntersectsRect(anotherView.frame, rect)) {
        return YES;
    }else {
        return NO;
    }
}

@end

#pragma mark - Find

@implementation UIView (Addition_Find_JL)

// 根据Class查找UIView
- (__kindof UIView*)jl_findView:(Class)cls {
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        if ([next isKindOfClass:cls]) {
            return next;
        }else {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:cls]) {
                return (UIView *)nextResponder;
            }
        }
    }
    return nil;
}

@end

#pragma mark - Layer

@implementation UIView (Addition_Layer_JL)

// 设置圆形
- (void)jl_round {
    
    [self jl_roundWithBorderWidth:0 borderColor:nil];
}

// 设置圆形（边宽、颜色）
- (void)jl_roundWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color {
    
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat r = 0.0f;
    if (w >= h) {
        r = w / 2.0f;
    }else {
        r = h / 2.0f;
    }
    [self jl_cornerRadius:r borderWidth:width boderColor:color];
}

// 设置边框（边宽，颜色）
- (void)jl_borderWidth:(CGFloat)width boderColor:(UIColor *)color {
    
    [self jl_cornerRadius:0.0 borderWidth:width boderColor:color];
}

// 设置圆角（角度）
- (void)jl_cornerRadius:(CGFloat)radius {
    
    [self jl_cornerRadius:radius borderWidth:0.0 boderColor:nil];
}

// 设置圆角（角度，边宽，颜色）
- (void)jl_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width boderColor:(UIColor *)color {
    
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

// 设置圆角（角度、位置）
- (void)jl_cornerRadius:(CGFloat)radius corner:(UIRectCorner)corner {
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = (CACornerMask)corner;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    byRoundingCorners:corner
                                                          cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

// Outter Shadow（radius和skecth中的blur是对应的）
// 微调：降低opacity,提高radius；或者提高opacity，降低radius
- (void)jl_shadowOffset:(CGSize)offset color:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius {
    
    // add shadow (use shadowPath to improve rendering performance)
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}

#pragma mark - Quick Setup UI

// 创建线段
+ (UIView *)jl_createLine:(UIColor *)color {
    
    UIView *line = [[UIView alloc] init];
    if (color == nil) {
        // 默认是E6E6E6
        line.backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:230.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
    }else {
        line.backgroundColor = color;
    }
    return line;
}

@end
