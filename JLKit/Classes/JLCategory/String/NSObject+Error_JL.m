

//
//  NSObject+Error_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+Error_JL.h"

@implementation NSObject (Error_JL)

/**
 *  任意类型转换成字符串
 */
- (NSString *)jl_errorString {
    
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }else if ([self isKindOfClass:[NSAttributedString class]]) {
        return ((NSAttributedString *)self).string;
    }else if ([self isKindOfClass:[NSError class]]) {
        return ((NSError *)self).localizedDescription;
    }else {
        return self.description;
    }
}

@end
