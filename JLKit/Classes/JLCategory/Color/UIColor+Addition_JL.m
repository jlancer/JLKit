//
//  UIColor+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIColor+Addition_JL.h"

@implementation UIColor (Addition_JL)

#pragma mark - 生成颜色

// 十六进制颜色
+ (UIColor *)jl_colorHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

// 十六进制颜色（alpha）
+ (UIColor *)jl_colorHexString:(NSString *)hexString withAlpha:(float)alpha {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

// 创建的渐变颜色
+ (UIColor *)jl_colorGradient:(CGSize)size direction:(JLGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    CGPoint startPoint = CGPointZero;
    if (direction == JLGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case JLGradientChangeDirectionHorizontal:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case JLGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case JLGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case JLGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

#pragma mark - 校验颜色

// 颜色是否相同
- (BOOL)jl_colorIsEqual:(UIColor *)anotherColor {
    
    if (CGColorEqualToColor(self.CGColor, anotherColor.CGColor)) {
        return YES;
    }else {
        if (self.jl_red == anotherColor.jl_red &&
            self.jl_green == anotherColor.jl_green &&
            self.jl_blue == anotherColor.jl_blue &&
            self.jl_alpha == anotherColor.jl_alpha) {
            return YES;
        }
        return NO;
    }
}

// 求当前颜色近似的颜色（目前只返回黑色和白色）
- (UIColor *)jl_colorSemilar {
    
    CGFloat red = 0, green = 0, blue = 0;
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    if (count == 4) {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        // 获取RGB颜色
        red = components[0];
        green = components[1];
        blue = components[2];
    }
    if (red > 185/255.0 && green > 185/255.0 && blue > 185/255.0) {
        return [UIColor blackColor];
    }
    return [UIColor whiteColor];
}

#pragma mark - 获取RGB值和Alpha值

// 获取ColorSpaceModel
- (CGColorSpaceModel)_colorSpaceModel {
    
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

/**
 *  获取颜色的Red值
 */
- (CGFloat)jl_red {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

/**
 *  获取颜色的Green值
 */
- (CGFloat)jl_green {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self _colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

/**
 *  获取颜色的Blue值
 */
- (CGFloat)jl_blue {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self _colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

/**
 *  获取颜色的Alpha值
 */
- (CGFloat)jl_alpha {
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[CGColorGetNumberOfComponents(self.CGColor)-1];
}

@end
