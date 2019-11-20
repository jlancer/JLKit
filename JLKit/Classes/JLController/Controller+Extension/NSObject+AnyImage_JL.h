//
//  NSObject+AnyImage_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AnyImage_JL)

// 设置任意图片源
- (void)jl_setImage:(id)anyResource;

// 设置任意图片源(isSelected)
- (void)jl_setImage:(id)anyResource isSelected:(BOOL)isSelected;

// 设置任意图片源(Base, isSelect, renderingMode)
- (void)jl_setImage:(id)anyResource isSelected:(BOOL)isSelected renderingMode:(UIImageRenderingMode)renderingMode;

@end

NS_ASSUME_NONNULL_END
