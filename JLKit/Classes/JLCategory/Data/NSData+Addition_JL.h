//
//  NSData+Addition_JL.h
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Addition_JL)

#pragma mark - Data转字符串

/**
 *  NSData转NSString
 */
- (NSString *) jl_dataToString;

#pragma mark - Gif Data 第一帧

/**
 *  NSData取得第一帧图片
 */
- (UIImage *) jl_imageFirstGifFramePicture;

#pragma mark - 图片Data转Base64

/**
 *  NSData转成PNG或JPEG格式的base64码
 */
- (NSString *) jl_imageData2Base64;

@end

NS_ASSUME_NONNULL_END
