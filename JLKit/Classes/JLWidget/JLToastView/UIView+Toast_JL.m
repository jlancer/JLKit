

//
//  UIView+Toast_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIView+Toast_JL.h"
#import <objc/runtime.h>
#import "Macro.h"

@implementation UIView (Toast_JL)

- (void)jl_toast:(JLToastImageType)type message:(NSString *)message {
    
    [self jl_toast:type message:message image:nil completion:nil];
}

- (void)jl_toast:(JLToastImageType)type message:(NSString *)message image:(UIImage *)image completion:(void(^)(void))completion {
    
    [self jl_toast:type message:message attributedMessage:nil image:image duration:1.5 backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] cornerRadius:2.0 completion:completion];
}

- (void)jl_toast:(JLToastImageType)type message:(NSString *)message attributedMessage:(NSAttributedString *)attributedMessage image:(UIImage *)image duration:(NSTimeInterval)duration backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius completion:(void(^)(void))completion {
    
    if (message.length == 0 && attributedMessage.length == 0) {
        return;
    }
    @synchronized (self) {
        
        __weak typeof(self) weakSelf = self;
        if ([self _jl_getJLToasting] == YES) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration + 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf jl_toast:type message:message image:image completion:completion];
            });
            return;
        }
        
        [self _jl_setJLToasting:@YES];
        if (self.tag < 0) {
            return;
        }
        JLToastView *hudView = [JLToastView jl_createHUD:type message:message attributedMessage:attributedMessage image:image backgroundColor:backgroundColor cornerRadius:cornerRadius];
        if (hudView != nil) {
            [MF_KEY_WINDOW addSubview:hudView];
            hudView.center = UI_POINT_CENTER;
            __weak typeof(hudView) weakHudView = hudView;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakHudView jl_dismiss];
                [weakSelf _jl_setJLToasting:@NO];
                completion == nil ? : completion();
            });
        }
    }
}

- (BOOL)jl_inToasting {
    
    return [self _jl_getJLToasting];
}

static void const *kJLToasting = "kJLToasting";

- (void)_jl_setJLToasting:(NSNumber *)intoasting {
    objc_setAssociatedObject(self, kJLToasting, intoasting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_jl_getJLToasting {
    return [objc_getAssociatedObject(self, kJLToasting) boolValue];
}

@end
