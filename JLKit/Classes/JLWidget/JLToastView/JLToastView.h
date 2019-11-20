//
//  JLToastView.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLToastImageType) {
    JLToastImageTypeNone         = 0,     // 没有图
    JLToastImageTypeOK           = 1,     // OK
    JLToastImageTypeWarning      = 2,     // Warning
    JLToastImageTypeError        = 3,     // Error
    JLToastImageTypeCustom       = 4      // 用户自定义
};

@interface JLToastView : UIView

+ (JLToastView *)jl_createHUD:(JLToastImageType)type message:(NSString *)message attributedMessage:(NSAttributedString *)attributedMessage image:(UIImage *)image backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

- (void)jl_dismiss;

@end

NS_ASSUME_NONNULL_END
