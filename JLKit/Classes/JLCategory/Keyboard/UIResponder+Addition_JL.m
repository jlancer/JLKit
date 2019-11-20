//
//  UIResponder+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIResponder+Addition_JL.h"

@implementation UIResponder (Addition_JL)

// 创建UITextField和UITextView的键盘InputAccessoryView
- (void)jl_createInputAccessory:(UIView *(^)(void))inputAccessoryBlock {
    
    if (inputAccessoryBlock != nil && ([self isKindOfClass:[UITextView class]] || [self isKindOfClass:[UITextField class]])) {
        
        if ([self isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)self;
            textView.inputAccessoryView = inputAccessoryBlock();
        }else {
            UITextField *textField = (UITextField *)self;
            textField.inputAccessoryView = inputAccessoryBlock();
        }
    }
}

@end
