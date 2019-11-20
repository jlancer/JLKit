//
//  NSString+Color_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Addition_JL.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Color_JL)

/**
 *  获取颜色
 */
- (UIColor *)jl_color;

/**
 *  获取颜色, alpha
 */
- (UIColor *)jl_color:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
