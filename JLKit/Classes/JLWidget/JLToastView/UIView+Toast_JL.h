//
//  UIView+Toast_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLToastView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Toast_JL)

- (void)jl_toast:(JLToastImageType)type message:(NSString *)message;

- (void)jl_toast:(JLToastImageType)type message:(NSString *)message image:(UIImage *)image completion:(void(^)(void))completion;

- (void)jl_toast:(JLToastImageType)type message:(NSString *)message attributedMessage:(NSAttributedString *)attributedMessage image:(UIImage *)image duration:(NSTimeInterval)duration backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius completion:(void(^)(void))completion;

- (BOOL)jl_inToasting;

@end

NS_ASSUME_NONNULL_END
