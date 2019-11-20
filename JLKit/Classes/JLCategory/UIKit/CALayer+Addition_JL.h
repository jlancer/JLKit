//
//  CALayer+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/31.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Addition_JL)

/**
 *  Rotate动画
 */
- (void)jl_animatedRotate:(CFTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue times:(CGFloat)times removedOnCompletion:(BOOL)removedOnCompletion;

- (void)setJl_borderColorFromUIColor:(UIColor *)color;

@property(nonatomic, strong) UIColor *jl_borderColorFromUIColor;

@property(nonatomic, assign) UIColor *jl_borderUIColor;

@end

NS_ASSUME_NONNULL_END
