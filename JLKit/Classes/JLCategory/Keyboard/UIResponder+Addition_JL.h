//
//  UIResponder+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Addition_JL)

// 创建UITextField和UITextView的键盘InputAccessoryView
- (void)jl_createInputAccessory:(UIView *(^)(void))inputAccessoryBlock;

@end

NS_ASSUME_NONNULL_END
