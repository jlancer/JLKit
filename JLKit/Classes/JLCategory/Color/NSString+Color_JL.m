
//
//  NSString+Color_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSString+Color_JL.h"

@implementation NSString (Color_JL)

/**
 *  获取颜色
 */
- (UIColor *)jl_color {

    if ([self characterAtIndex:0] == '#') {
        if ([self length] == 9) {
            NSString *colorHex = [self substringToIndex:7];
            NSString *alphaPercent = [self substringFromIndex:7];
            float alpha = [alphaPercent floatValue] / 100.0;
            return [UIColor jl_colorHexString:colorHex withAlpha:alpha];
        }else if ([self length] == 7) {
            return [UIColor jl_colorHexString:self];
        }
    }else{
        if ([self length] == 8) {
            NSString *colorHex = [NSString stringWithFormat:@"#%@",[self substringToIndex:6]];
            NSString *alphaPercent = [self substringFromIndex:6];
            float alpha = [alphaPercent floatValue] / 100.0;
            return [UIColor jl_colorHexString:colorHex withAlpha:alpha];
        }else if ([self length] == 6) {
            return [UIColor jl_colorHexString:[NSString stringWithFormat:@"#%@",self]];
        }
    }
    return nil;
}

/**
 *  获取颜色, alpha
 */
- (UIColor *)jl_color:(CGFloat)alpha {
    
    return [[self jl_color] colorWithAlphaComponent:alpha];
}

@end
