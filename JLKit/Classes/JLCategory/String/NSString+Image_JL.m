
//
//  NSString+Image_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSString+Image_JL.h"
#import "NSBundle+Images_JL.h"

@interface _JLImageInternalObject : NSObject

@end

@implementation _JLImageInternalObject

@end

@implementation NSString (Image_JL)

/**
 *  根据String获取Image
 *  eg,
 *
 *  1) @"XXX".jl_image == [UIImage imageNamed:XXX];
 *
 *  2) @"BUNDLE.XXX".jl_image == [NSBundle jl_image:XXX extension:nil bunldeName:BUNDLE class:[_JLImageInternalObject class]] memCache:NO]
 *
 *  3) @"CLASS.BUNDLE.XXX".jl_image == [NSBundle jl_image:XXX extension:nil bunldeName:BUNDLE class:NSClassFromString(CLASS) memCache:NO]
 *
 */
- (UIImage *)jl_image {
    
    UIImage *image = [UIImage imageNamed:self];
    if (image != nil) {
        return image;
    }
    NSArray *components = [self componentsSeparatedByString:@"."];
    if (components.count < 2) {
        return nil;
    }
    NSString *className = nil;
    NSString *bundleName = nil;
    NSString *imageName = nil;
    if (components.count == 2) {
        className = [components objectAtIndex:0];
        imageName = [components objectAtIndex:1];
    }else if (components.count == 3) {
        className = [components objectAtIndex:0];
        bundleName = [components objectAtIndex:1];
        imageName =[components objectAtIndex:2];
    }
    return [NSBundle jl_image:imageName extension:nil bunldeName:bundleName class:(className == nil ? [_JLImageInternalObject class] : NSClassFromString(className)) memCache:NO];
}

@end
