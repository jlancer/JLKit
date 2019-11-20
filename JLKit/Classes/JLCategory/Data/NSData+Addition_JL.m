//
//  NSData+Addition_JL.m
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSData+Addition_JL.h"

@implementation NSData (Addition_JL)

#pragma mark - Data转字符串

/**
 *  NSData转NSString
 */
- (NSString *) jl_dataToString {
    
    if ([self isKindOfClass:[NSData class]]) {
        const unsigned *bytes = [(NSData *)self bytes];
        return [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x", ntohl(bytes[0]), ntohl(bytes[1]), ntohl(bytes[2]), ntohl(bytes[3]), ntohl(bytes[4]), ntohl(bytes[5]), ntohl(bytes[6]), ntohl(bytes[7])];
    } else {
        return [[[[self description] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
}

#pragma mark - Gif Data 第一帧

/**
 *  NSData取得第一帧图片
 */
- (UIImage *) jl_imageFirstGifFramePicture {
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self, NULL);
    size_t count = CGImageSourceGetCount(source);
    if (count > 0) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CFRelease(source);
        return image;
    }
    CFRelease(source);
    return nil;
}

#pragma mark - 图片Data转Base64

/**
 *  NSData转成PNG或JPEG格式的base64码
 */
- (NSString *) jl_imageData2Base64 {
    
    NSString *base64 = [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

@end
