

//
//  UIFont+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/10/29.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIFont+Addition_JL.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

@implementation UIFont (Addition_JL)

/**
 *  存放在Document文件夹里以name名称加载字体
 */
+ (UIFont *)jl_fontFromDocumentFileName:(NSString *)name size:(CGFloat)size {
    
    if ([[self class] _isExistFile:[[self class] _getDocumentFilePath:name]]) {
        return [UIFont jl_fontTTF_OTF_FromDocumentPath:[[self class] _getDocumentFilePath:name] size:size];
    }
    return nil;
}

/**
 *  下载url的字体文件，以name名称存放在Document文件夹
 */
+ (void)jl_fontDownloadToDocument:(NSString *)url name:(NSString *)name completion:(void(^)(BOOL success, NSString *filePath))completion {
    
    if ([url length] == 0 || [name length] == 0) {
        completion(NO, nil);
        return;
    }
    if ([[self class] _isExistFile:[[self class] _getDocumentFilePath:name]]) {
        completion(YES, [[self class] _getDocumentFilePath:name]);
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && [data length] > 0) {
            // 下载成功
            [[self class] _writeDocumentData:data name:name];
            completion == nil ? : completion(YES, [[self class] _getDocumentFilePath:name]);
        }else{
            // 下载失败
            completion == nil ? : completion(NO, nil);
        }
    }];
    [task resume];
}

/**
 *  加载path的TTF、OTF文件，输出size大小的字体
 */
+ (UIFont *)jl_fontTTF_OTF_FromDocumentPath:(NSString *)path size:(CGFloat)size {
    
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

/**
 *  加载path的TTC文件，输出size大小的字体集
 */
+ (NSArray *)jl_fontTTCArrayFromDocumentPath:(NSString *)path size:(CGFloat)size {
    
    CFStringRef fontPath = CFStringCreateWithCString(NULL, [path UTF8String], kCFStringEncodingUTF8);
    CFURLRef fontUrl = CFURLCreateWithFileSystemPath(NULL, fontPath, kCFURLPOSIXPathStyle, 0);
    CFArrayRef fontArray = CTFontManagerCreateFontDescriptorsFromURL(fontUrl);
    CTFontManagerRegisterFontsForURL(fontUrl, kCTFontManagerScopeNone, NULL);
    NSMutableArray *customFontArray = [NSMutableArray array];
    for (CFIndex i = 0 ; i < CFArrayGetCount(fontArray); i++) {
        CTFontDescriptorRef  descriptor = CFArrayGetValueAtIndex(fontArray, i);
        CTFontRef fontRef = CTFontCreateWithFontDescriptor(descriptor, size, NULL);
        NSString *fontName = CFBridgingRelease(CTFontCopyName(fontRef, kCTFontPostScriptNameKey));
        UIFont *font = [UIFont fontWithName:fontName size:size];
        [customFontArray addObject:font];
    }
    return customFontArray;
}

#pragma mark - Private
+ (BOOL)_isExistFile:(NSString *)filepath {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+ (NSString *)_getDocumentFilePath:(NSString *)name {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)[0];
    NSString *fileName = [documentPath stringByAppendingPathComponent:name];
    return fileName;
}

+ (void)_writeDocumentData:(NSData *)data name:(NSString *)name {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)[0];
    NSString *fileName = [documentPath stringByAppendingPathComponent:name];
    [data writeToFile:fileName atomically:YES];
}


@end
