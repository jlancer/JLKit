//
//  NSAttributedString+Addition_JL.h
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Addition_JL)

#pragma mark - 字符串size、height、width

/**
 *  获得字符串高度
 */
- (CGFloat)jl_getHeight:(CGFloat)fixedWidth;

/**
 *  获得字符串宽度
 */
- (CGFloat)jl_getWidth:(CGFloat)fixedHeight;

/**
 *  获得字符串尺寸
 */
- (CGSize)jl_getSize:(CGSize)renderSize enableCeil:(BOOL)enableCeil;

@end

NS_ASSUME_NONNULL_END
