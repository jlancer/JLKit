

//
//  NSAttributedString+Addition_JL.m
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSAttributedString+Addition_JL.h"

@implementation NSAttributedString (Addition_JL)

#pragma mark - 字符串size、height、width

/**
 *  获得字符串高度
 */
- (CGFloat)jl_getHeight:(CGFloat)fixedWidth {
    
    return [self jl_getSize:CGSizeMake(fixedWidth, MAXFLOAT) enableCeil:YES].height;
}

/**
 *  获得字符串宽度
 */
- (CGFloat)jl_getWidth:(CGFloat)fixedHeight {
    
    return [self jl_getSize:CGSizeMake(MAXFLOAT, fixedHeight) enableCeil:YES].width;
}

/**
 *  获得字符串尺寸
 */
- (CGSize)jl_getSize:(CGSize)renderSize enableCeil:(BOOL)enableCeil {
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine;
    CGSize size = [self boundingRectWithSize:renderSize options:options context:nil].size;
    if (enableCeil) {
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    }
    return size;
}

@end
