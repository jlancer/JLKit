
//
//  UIImage+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import "Macro.h"
#import "UIImage+Addition_JL.h"
#import "NSString+Addition_JL.h"

@implementation UIImage (Addition_JL)

#pragma mark - 裁切、截屏

/**
 *  获得图片（指定区域）
 */
- (UIImage *)jl_imageCropRect:(CGRect)rect {
    
    CGImageRef sourceImageRef = self.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale, rect.size.width * self.scale, rect.size.height * self.scale));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

/**
 *  获得图片（指定比例区域）
 */
- (UIImage *)jl_imageCropBeginPointRatio:(CGPoint)beginPointRatio endPointRatio:(CGPoint)endPointRatio {
    
    CGRect rect = CGRectMake(self.size.width * beginPointRatio.x, self.size.height * beginPointRatio.y, self.size.width * (endPointRatio.x - beginPointRatio.x), self.size.height * (endPointRatio.y - beginPointRatio.y));
    return [self jl_imageCropRect:rect];
}

/**
 *  裁剪图片（指定区域）
 */
- (UIImage *)jl_imageCropRect:(CGRect)rect sameRation:(BOOL)sameRatio {
    
    if (sameRatio) {
        CGRect myImageRect = rect;
        float cropRatio = rect.size.width / rect.size.height;
        float imageRatio = self.size.width / self.size.height;
        if (cropRatio == imageRatio) {
            return self;
        }else if (cropRatio > imageRatio) {
            // 裁剪高度
            CGFloat width = self.size.width;
            CGFloat height = self.size.width * cropRatio;
            CGFloat x = self.size.width * ( rect.size.width / self.size.width );
            CGFloat y = self.size.height * ( rect.size.width / self.size.width );
            myImageRect = CGRectMake(x, y, width, height);
        }else {
            // 裁剪宽度
            CGFloat height = self.size.height;
            CGFloat width = self.size.height / cropRatio;
            CGFloat x = self.size.width * ( rect.size.width / self.size.width );
            CGFloat y = self.size.height * ( rect.size.width / self.size.width );
            myImageRect = CGRectMake(x, y, width, height);
        }
        CGImageRef imageRef = self.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
        return [UIImage imageWithCGImage:subImageRef];
    }else {
        CGRect myImageRect = rect;
        UIImage *bigImage= self;
        CGImageRef imageRef = bigImage.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
        CGSize size;
        size.width = rect.size.width;
        size.height = rect.size.height;
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, myImageRect, subImageRef);
        UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        return smallImage;
    }
}

/**
 *  截图UIView（对每个继承自UIView的对象都适用）
 */
+ (UIImage *)jl_imageCaptureView:(UIView *)view {
    
    CGRect rect = view.frame;
    // UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  截图UIView（对每个继承自UIView的对象都适用）
 */
+ (UIImage *)jl_imageCaptureView:(UIView *)view opaque:(BOOL)opaque {
    
    CGRect rect = view.frame;
    // UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  截屏（指定UIView，正方形，无损）
 */
+ (UIImage *)jl_imageCaptureView:(UIView *)view rect:(CGSize)rect {
    
    CGRect squareViewrect = view.frame;
    CGFloat max = rect.height >= rect.width ? rect.height : rect.width;
    squareViewrect.size.width = max;
    squareViewrect.size.height = max;
    // UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(squareViewrect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  截全屏（指定UIViewController）
 */
+ (UIImage *)jl_imageCaptureController:(UIViewController *)viewController {
    
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    // UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [viewController.navigationController.view.layer renderInContext:context];
    // [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  截全屏(NSData)
 */
+ (NSData *)jl_imageDataCaptureScreen {
    
    return UIImagePNGRepresentation([self jl_imageCaptureScreen]);
}

/**
 *  截全屏(UIImage)
 */
+ (UIImage *)jl_imageCaptureScreen {
    
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    }else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, - M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        
        @try {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }@catch (NSException *ex) {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
        
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 压缩

/**
 *  压缩图片，宽度固定，返回Image（调整尺寸减少像素，降低像素质量）
 */
- (UIImage *)jl_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte width:(CGFloat)width {
    
    NSData *data = [self jl_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte width:width];
    if (data != nil) {
        return [UIImage imageWithData:data];
    }
    return nil;
}

/**
 *  压缩图片，尺寸固定，返回Image（调整尺寸减少像素，降低像素质量）
 */
- (UIImage *)jl_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte size:(CGSize)size {
    
    NSData *data = [self jl_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte size:size];
    if (data != nil) {
        return [UIImage imageWithData:data];
    }
    return nil;
}

/**
 *  压缩图片，宽度固定，返回Data（调整尺寸减少像素，降低像素质量）
 */
- (NSData *)jl_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte width:(CGFloat)width {
    
    return [self jl_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte size:CGSizeMake(width, width * (self.size.height / self.size.width))];
}

/**
 *  压缩图片，尺寸固定，返回Data（调整尺寸减少像素，降低像素质量）
 */
- (NSData *)jl_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte size:(CGSize)size {
    
    UIImage *adjustImage = self;
    if (size.width < adjustImage.size.width ) {
        adjustImage = [self jl_imageAdjustSize:size];
    }
    return [adjustImage jl_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte];
}

/**
 *  压缩图片，输出Image（降低像素质量）
 */
- (UIImage *)jl_imageCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte {
    
    NSData *compressedData = [self jl_imageDataCompressQuality:compressionQuality lessThanMegaByte:mbyte];
    if (compressedData != nil) {
        return [UIImage imageWithData:compressedData];
    }
    return nil;
}

/**
 *  压缩图片，输出Data（降低像素质量）
 */
- (NSData *)jl_imageDataCompressQuality:(CGFloat)compressionQuality lessThanMegaByte:(CGFloat)mbyte {
    
    NSData *imageData = UIImageJPEGRepresentation(self, compressionQuality);
    if (imageData == nil) {
        // 不是JPEG格式，不支持压缩
        return UIImagePNGRepresentation(self);
    }
    if (mbyte <= 0 || compressionQuality <= 0 || compressionQuality > 1.0) {
        // 压缩目标限值和压缩比例设置错误
        return imageData;
    }
    NSUInteger bytesPerMB = 1024 * 1024;
    if ( imageData.length  / (bytesPerMB * mbyte) < 1) {
        // 在压缩范围内
        return imageData;
    }else if (compressionQuality < 0.05) {
        // 压缩超出极限压缩比
        return imageData;
    }
    
    // 默认再压缩为0.7倍
    CGFloat compressedRate = 0;
    if ( imageData.length  / (bytesPerMB * mbyte) > 40) {
        // 实际值/目标值 > 40
        compressedRate = compressionQuality * 0.2;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 20) {
        // 实际值/目标值 > 20
        compressedRate = compressionQuality * 0.3;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 10) {
        // 实际值/目标值 > 10
        compressedRate = compressionQuality * 0.4;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 5) {
        // 实际值/目标值 > 5
        compressedRate = compressionQuality * 0.5;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 4) {
        // 实际值/目标值 > 4
        compressedRate = compressionQuality * 0.6;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 3) {
        // 实际值/目标值 > 3
        compressedRate = compressionQuality * 0.65;
    }else if ( imageData.length  / (bytesPerMB * mbyte) > 2) {
        // 实际值/目标值 > 2
        compressedRate = compressionQuality * 0.7;
    }else {
        // 实际值/目标值 其它值
        compressedRate = compressionQuality * 0.8;
    }
    imageData = UIImageJPEGRepresentation(self, compressedRate);
    if ( imageData.length  / (bytesPerMB * mbyte) < 1) {
        // 在压缩范围内
        return imageData;
    }else if (compressedRate < 0.05) {
        // 压缩超出极限压缩比
        return imageData;
    }else {
        return [self jl_imageDataCompressQuality:compressedRate lessThanMegaByte:mbyte];
    }
}

/**
 *  等比率调整图片（减少像素）
 */
- (UIImage *)jl_imageAdjustScale:(float)scale {
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  等比率调整图片，图片方向（减少像素）
 */
- (UIImage *)jl_imageAdjustScale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    
    CGImageRef imageRef = self.CGImage;
    UIImage *tmpImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    return tmpImage;
}

/**
 *  自定义长宽调整图片（减少像素）
 */
- (UIImage *)jl_imageAdjustSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

/**
 *  自定义长宽调整图片,可裁切图片（减少像素）
 */
- (UIImage *)jl_imageAdjustSize:(CGSize)size cropped:(BOOL)cropped {
    
    if (cropped) {
        UIImage *sourceImage = self;
        UIImage *newImage = nil;
        CGSize  imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = size.width;
        CGFloat targetHeight = size.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        if (CGSizeEqualToSize(imageSize, size) == NO) {
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
            if (widthFactor > heightFactor) {
                scaleFactor = widthFactor;
            }else {
                scaleFactor = heightFactor;
            }
            scaledWidth= width * scaleFactor;
            scaledHeight = height * scaleFactor;
            if (widthFactor > heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
        UIGraphicsBeginImageContext(size);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width= scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        [sourceImage drawInRect:thumbnailRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil) MFLog(@"could not scale image");
        UIGraphicsEndImageContext();
        return newImage;
    }else {
        return [self jl_imageAdjustSize:size];
    }
}

#pragma mark - 图片类型

/**
 *  判断图片类型
 */
+ (JLImageType)jl_imageType:(NSData *)imageData {
    
    if (imageData == nil || ![imageData isKindOfClass:[NSData class]]) {
        return JLImageTypeUnknown;
    }
    
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return JLImageTypeJPEG;
        case 0x89:
            return JLImageTypePNG;
        case 0x47:
            return JLImageTypeGIF;
        case 0x49:
        case 0x4D:
            return JLImageTypeTIFF;
        case 0x52:
            if ([imageData length] < 12) {
                return JLImageTypeUnknown;
            }
            NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return JLImageTypeWEBP;
            }
            return JLImageTypeUnknown;
    }
    return JLImageTypeUnknown;
}

/**
 *  判断图片类型
 */
- (JLImageType)jl_imageType {
    
    NSData *imageData = UIImagePNGRepresentation(self);
    if (imageData == nil) {
        imageData = UIImageJPEGRepresentation(self, 1.0);
    }
    return [[self class] jl_imageType:imageData];
}

#pragma mark - 转码

/**
 *  UIImage转成PNG或JPEG格式的base64码
 */
- (NSString *)jl_image2Base64 {
    
    NSString *base64 = [self jl_image2Base64_JPEG];
    if (base64) {
        return base64;
    }
    return [self jl_image2Base64_PNG];
}

/**
 *  UIImage转成PNG格式的base64码
 */
- (NSString *)jl_image2Base64_PNG {
    
    NSData *data = UIImagePNGRepresentation(self);
    NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}


/**
 *  UIImage转成JPEG格式的base64码
 */
- (NSString *)jl_image2Base64_JPEG {
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

#pragma mark - 颜色

/**
 *  根据颜色，输出10*10的图片
 */
+ (UIImage *)jl_imageWithColor:(UIColor *)color {
    
    return [[self class] jl_imageWithColor:color size:CGSizeMake(10, 10)];
}

/**
 *  根据指定大小和颜色，输出图片
 */
+ (UIImage *)jl_imageWithColor:(UIColor *)color size:(CGSize)size {
    
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,
                                       color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}

/**
 *  获取UIImage的主色
 */
- (UIColor *)jl_imageMainColor {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    // 第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(self.size.width/2, self.size.height/2);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,   //bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    // 第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData(context);
    if (data == NULL) return nil;
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4 * ( x * y );
            int red   = data[offset];
            int green = data[offset+1];
            int blue  = data[offset+2];
            int alpha = data[offset+3];
            if (alpha > 0) {
                NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
                [cls addObject:clr];
            }
        }
    }
    CGContextRelease(context);
    // 第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *maxColor = nil;
    NSUInteger maxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil ) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < maxCount ) continue;
        maxCount = tmpCount;
        maxColor = curColor;
    }
    if (maxColor == nil) return nil;
    int r = [[maxColor objectAtIndex:0] intValue];
    int g = [[maxColor objectAtIndex:1] intValue];
    int b = [[maxColor objectAtIndex:2] intValue];
    int a = [[maxColor objectAtIndex:3] intValue];
    return [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a/255.0f)];
}

#pragma mark - 二维码

/**
 *  根据文字输出二维码图片
 */
+ (UIImage *)jl_imageQR:(NSString *)text width:(CGFloat)width {
    
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3.设置数据
    NSData *infoData = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKey:@"inputMessage"];
    // 4.生成二维码, 缩放
    CIImage *ciImage = filter.outputImage;
    CGRect extent = CGRectIntegral(ciImage.extent);
    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(width / CGRectGetWidth(extent), width / CGRectGetWidth(extent))];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    return image;
}

/**
 *  根据文字logo图输出二维码图片
*/
+ (UIImage *)jl_imageQR:(NSString *)url size:(CGFloat)size logo:(UIImage *)logo {
    // 1. 创建一个二维码滤镜实例(CIFilter)

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    // 滤镜恢复默认设置

    [filter setDefaults];

    // 2. 给滤镜添加数据

    NSString *string = url;

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    // 使用KVC的方式给filter赋值

    [filter setValue:data forKeyPath:@"inputMessage"];

    // 3. 生成二维码

    CIImage *image = [filter outputImage];

    // 转成高清格式
    
    UIImage *qrcode = [UIImage jl_createNonInterpolatedUIImageFormCIImage:image withSize:size];

    // 添加logo

    qrcode = [UIImage jl_drawImage:logo inImage:qrcode];
    
    return qrcode;
}

+ (UIImage *)jl_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {

    CGRect extent = CGRectIntegral(image.extent);

    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;

    size_t width = CGRectGetWidth(extent) * scale;

    size_t height = CGRectGetHeight(extent) * scale;

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();

    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);

    CIContext *context = [CIContext contextWithOptions:nil];

    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];

    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);

    CGContextScaleCTM(bitmapRef, scale, scale);

    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片

    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);

    CGContextRelease(bitmapRef);

    CGImageRelease(bitmapImage);

    return [UIImage imageWithCGImage:scaledImage];

}


+ (UIImage *)jl_drawImage:(UIImage *)newImage inImage:(UIImage *)sourceImage {

    CGSize imageSize; //画的背景 大小

    imageSize = [sourceImage size];

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);

    [sourceImage drawAtPoint:CGPointMake(0, 0)];

    //获得 图形上下文

    CGContextRef context=UIGraphicsGetCurrentContext();

    //画 自己想要画的内容(添加的图片)

    CGContextDrawPath(context, kCGPathStroke);

    // 注意logo的尺寸不要太大,否则可能无法识别

    CGRect rect = CGRectMake(imageSize.width / 2 - 25, imageSize.height / 2 - 25, 50, 50);

    //  CGContextAddEllipseInRect(context, rect);

    CGContextClip(context);

    [newImage drawInRect:rect];

    //返回绘制的新图形

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;

}

/**
 *  根据文字图片输出带图片、带颜色的二维码图片
*/
+ (UIImage *)jl_imageQR:(NSString *)codeString andSize:(CGSize)size andBackColor:(UIColor *)backColor andFrontColor:(UIColor *)frontColor andCenterImage:(UIImage *)centerImage {
    
    NSData *stringData = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    //放大并绘制二维码 (上面生成的二维码很小，需要放大)
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    UIImage *colorCodeImage = codeImage;
    if (frontColor && backColor) {
        //绘制颜色
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                           keysAndValues:
                                 @"inputImage",[CIImage imageWithCGImage:codeImage.CGImage],
                                 @"inputColor0",[CIColor colorWithCGColor:frontColor == nil ? [UIColor clearColor].CGColor: frontColor.CGColor],
                                 @"inputColor1",[CIColor colorWithCGColor: backColor == nil ? [UIColor blackColor].CGColor : backColor.CGColor],
                                 nil];
        
        colorCodeImage = [UIImage imageWithCIImage:colorFilter.outputImage];
    }
    
    //中心添加图片
    if (centerImage != nil) {
        
        UIGraphicsBeginImageContext(colorCodeImage.size);
        
        [colorCodeImage drawInRect:CGRectMake(0, 0, colorCodeImage.size.width, colorCodeImage.size.height)];
        
        UIImage *image = centerImage;
        
        CGFloat imageW = 25;
        CGFloat imageX = (colorCodeImage.size.width - imageW) * 0.5;
        CGFloat imgaeY = (colorCodeImage.size.height - imageW) * 0.5;
        
        [image drawInRect:CGRectMake(imageX, imgaeY, imageW, imageW)];
        
        UIImage *centerImageCode = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return centerImageCode;
    }
    return colorCodeImage;
}

#pragma mark - 文字Logo

/**
 *  根据文字输出图片
 */
+ (UIImage *)jl_imageWithText:(NSString *)text {
    
    return [self jl_imageWithText:text font:[UIFont systemFontOfSize:14.0] color:[UIColor whiteColor] kern:0.0 backgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] square:YES];
}

/**
 *  根据文字、字体、颜色、部分字体属性kern，backgroundColor，是否正方形等规则输出图片
 */
+ (UIImage *)jl_imageWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color kern:(CGFloat)kern backgroundColor:(UIColor *)backgroundColor square:(BOOL)square {
    
    // 生产Text View
    CGSize size = [text jl_size:font kern:kern space:0.0 linebreakmode:NSLineBreakByTruncatingTail limitedlineHeight:0 renderSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGRect frame = CGRectZero;
    if (square) {
        if (w > h) {
            frame = CGRectMake(0, 0, w + 5.0, w + 5.0);
        }else{
            frame = CGRectMake(0, 0, h + 5.0, h + 5.0);
        }
    }else{
        frame = CGRectMake(0, 0, w + 10.0, h + 10.0);
    }
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if (backgroundColor) {
        view.backgroundColor = backgroundColor;
    }else {
        view.backgroundColor = [UIColor blackColor];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.attributedText = text.typeset.font([font fontName], [font pointSize]).kern(kern).string;
    [view addSubview:label];
    // Image
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 2.0);
    // UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    CGImageRef tImageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    UIImage *image = [UIImage imageWithCGImage:tImageRef scale:1.0 orientation:UIImageOrientationUp];
    return image;
}

#pragma mark - 水印

/**
 *  按起始点，添加带alpha的图片的水印
 */
- (UIImage *)jl_imageWaterMarkWithImage:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha {
    
    return [self jl_imageWaterMarkWithString:nil point:CGPointZero attribute:nil image:image imagePoint:imgPoint alpha:alpha];
}

/**
 *  按范围，添加带alpha的图片的水印
 */
- (UIImage *)jl_imageWaterMarkWithImage:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha {
    
    return [self jl_imageWaterMarkWithString:nil rect:CGRectZero attribute:nil image:image imageRect:imgRect alpha:alpha];
}

/**
 *  按起始点，添加带属性的字符串
 */
- (UIImage *)jl_imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attribute {
    
    return [self jl_imageWaterMarkWithString:str point:strPoint attribute:attribute image:nil imagePoint:CGPointZero alpha:0];
}

/**
 *  按范围，添加带属性的字符串
 */
- (UIImage *)jl_imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attribute {
    
    return [self jl_imageWaterMarkWithString:str rect:strRect attribute:attribute image:nil imageRect:CGRectZero alpha:0];
}

/**
 *  按起始点，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)jl_imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attribute image:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawAtPoint:imgPoint blendMode:kCGBlendModeNormal alpha:alpha];
    }
    if (str) {
        [str drawAtPoint:strPoint withAttributes:attribute];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

/**
 *  按范围，添加带属性的字符串和带alpha的图片的合成水印
 */
- (UIImage *)jl_imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attribute image:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:alpha];
    }
    if (str) {
        [str drawInRect:strRect withAttributes:attribute];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#pragma mark - 高斯模糊
- (UIImage *)jl_gaussBlur:(CGFloat)blurRadius {

    // Context
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:self.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blurRadius) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (UIImage *)jl_boxBlur:(CGFloat)blur {
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

#pragma mark - 测试
- (void)jl_debugShow:(CGRect)frame {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = self;
    [MF_KEY_WINDOW addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    MF_WEAK_OBJECT(imageView)
    [imageView setUserInteractionEnabled:YES];
    [imageView bk_whenTapped:^{
        [weakimageView removeFromSuperview];
    }];
}

@end
