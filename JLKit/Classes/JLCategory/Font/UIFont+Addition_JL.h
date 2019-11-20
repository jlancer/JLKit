//
//  UIFont+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Addition_JL)

/**
 *  存放在Document文件夹里以name名称加载字体
 */
+ (UIFont *)jl_fontFromDocumentFileName:(NSString *)name size:(CGFloat)size;

/**
 *  下载url的字体文件，以name名称存放在Document文件夹
 */
+ (void)jl_fontDownloadToDocument:(NSString *)url name:(NSString *)name completion:(void(^)(BOOL success, NSString *filePath))completion;

/**
 *  加载path的TTF、OTF文件，输出size大小的字体
 */
+ (UIFont *)jl_fontTTF_OTF_FromDocumentPath:(NSString *)path size:(CGFloat)size;

/**
 *  加载path的TTC文件，输出size大小的字体集
 */
+ (NSArray *)jl_fontTTCArrayFromDocumentPath:(NSString *)path size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
