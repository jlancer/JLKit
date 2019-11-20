//
//  NSObject+Error_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Error_JL)

/**
 *  任意类型转换成字符串
 */
- (NSString *)jl_errorString;

@end

NS_ASSUME_NONNULL_END
