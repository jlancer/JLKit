//
//  NSBundle+Images_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define EXTENSION_PNG  @"png"
#define EXTENSION_JPG  @"jpg"
#define EXTENSION_JPEG @"jpeg"

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Images_JL)

// 获取Resource Bundle对象（类方法）
+ (NSBundle *)jl_resourceBundle:(NSString *)bundleName class:(Class)cls;

// 获取Resource Bundle的图片（类方法）
+ (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension bunldeName:(NSString *)bundleName class:(Class)cls;

// 获取Resource Bundle的图片，Memory Cache（类方法）
+ (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension bunldeName:(NSString *)bundleName class:(Class)cls memCache:(BOOL)memCache;

// 获取Resource Bundle的图片（实例方法）
- (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension;

// 获取Resource Bundle的图片，Memory Cache（实例方法）
- (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension memCache:(BOOL)memCache;

@end

NS_ASSUME_NONNULL_END
