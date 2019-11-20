//
//  CALayer+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "CALayer+Addition_JL.h"
#import <objc/runtime.h>

@implementation CALayer (Addition_JL)

/**
 *  Rotate动画
 */
- (void)jl_animatedRotate:(CFTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue times:(CGFloat)times removedOnCompletion:(BOOL)removedOnCompletion {
    
    CABasicAnimation *anim;
    anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.repeatCount = times;
    anim.fromValue = [NSNumber numberWithFloat:fromValue];
    anim.toValue = [NSNumber numberWithFloat:toValue];
    if (removedOnCompletion == NO) {
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
    }
    [self addAnimation:anim forKey:@"animateTransform"];
}

- (UIColor *)jl_borderColorFromUIColor {
    
    return objc_getAssociatedObject(self, @selector(jl_borderColorFromUIColor));
    
}

-(void)setJl_borderColorFromUIColor:(UIColor *)color

{
    
    objc_setAssociatedObject(self, @selector(jl_borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setJl_borderColorFromUI:self.jl_borderColorFromUIColor];
    
}

- (void)setJl_borderColorFromUI:(UIColor *)color

{
    self.borderColor = color.CGColor;
}

- (void)setJl_borderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)jl_borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
