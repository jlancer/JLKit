//
//  NSBundle+Images_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSBundle+Images_JL.h"

static NSMutableDictionary *imagesMap = nil;

@implementation NSBundle (Images_JL)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagesMap = [[NSMutableDictionary alloc] init];
    });
}

// 获取Resource Bundle对象（类方法）
+ (NSBundle *)jl_resourceBundle:(NSString *)bundleName class:(Class)cls {
    
    if (cls == nil) {
        return nil;
    }
    NSBundle *bundle = nil;
    if (bundle == nil) {
        // 适配CocoaPods
        bundle = [NSBundle bundleForClass:cls];
        if (bundleName.length > 0) {
            NSString *bundlePath = [bundle pathForResource:bundleName ofType:@"bundle"];
            bundle = [NSBundle bundleWithPath:bundlePath];
        }
    }
    return bundle;
}

// 获取Resource Bundle的图片（类方法）
+ (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension bunldeName:(NSString *)bundleName class:(Class)cls {
    
    return [NSBundle jl_image:imageName extension:extension bunldeName:bundleName class:cls memCache:NO];
}

// 获取Resource Bundle的图片，Memory Cache（类方法）
+ (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension bunldeName:(NSString *)bundleName class:(Class)cls memCache:(BOOL)memCache {
    
    // 从Bundle中加载
    NSBundle *bundle = [self jl_resourceBundle:bundleName class:cls];
    UIImage *image = [bundle jl_image:imageName extension:extension memCache:memCache];
    if (image) {
        return image;
    }
    // 防止误用jl_image或者使用封装jl_image后的API
    return [UIImage imageNamed:imageName];
}

// 获取Resource Bundle的图片（实例方法）
- (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension {
    
    return [self jl_image:imageName extension:extension memCache:NO];
}

// 获取Resource Bundle的图片，Memory Cache（实例方法）
- (UIImage *)jl_image:(NSString *)imageName extension:(NSString *)extension memCache:(BOOL)memCache {
    
    NSString *key = [NSString stringWithFormat:@"%@/%@", self.bundlePath, imageName];
    UIImage *image = [imagesMap objectForKey:imageName];
    if (image == nil) {
        NSBundle *bundle = self;
        int scale  = (int)[UIScreen mainScreen].scale;
        NSArray *scales = nil;
        if (scale == 3) {
            scales = @[@(3), @(2), @(1)];
        }else if (scale == 2) {
            scales = @[@(2), @(3), @(1)];
        }else {
            scales = @[@(1), @(2), @(3)];
        }
        for (NSNumber *number in scales) {
            if (extension.length > 0) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@%@x", imageName, number] ofType:extension]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }else {
                for (NSString *ext in @[EXTENSION_PNG, EXTENSION_JPG, EXTENSION_JPEG]) {
                    image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@%@x", imageName, number] ofType:ext]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    if (image) {
                        break;
                    }
                }
            }
            if(image == nil) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@%@x", imageName, number] ofType:nil]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            if (image) {
                break;
            }
        }
        if (image == nil) {
            for (NSString *ext in @[EXTENSION_PNG, EXTENSION_JPG, EXTENSION_JPEG]) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:ext]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                if (image) {
                    break;
                }
            }
            if(image == nil) {
                image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:extension]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        }
        if (image != nil && memCache) {
            [imagesMap setValue:image forKey:key];
        }
    }
    if (!memCache) {
        [imagesMap setValue:nil forKey:key];
    }
    return image;
}


@end
