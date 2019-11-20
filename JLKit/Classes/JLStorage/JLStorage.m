//
//  JLStorage.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLStorage.h"

#define Cache_Category_Default   @"default"
#define Cache_Category_SnapShots @"Snapshots"

@implementation JLStorage

#pragma mark - Plist Storage

// 存储JSONModel对象到plist
+ (void)saveJsonmodel:(id)object key:(NSString *)key {
    
    [self saveJsonmodel:object key:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// 存储JSONModel对象到plist(UserDefault)
+ (void)saveJsonmodel:(id)object key:(NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    if (key == nil) {
        return;
    }
    if (object == nil) {
        [userDefault removeObjectForKey:key];
    }else{
        NSString *_data = nil;
        _data = [object mj_JSONString];
        [userDefault setObject:_data forKey:key];
    }
    [userDefault synchronize];
}

// plist中加载JSONModel对象
+ (id)valueJsonmodel:(NSString *)objectClassName key:(NSString *)key {
    
    return [self valueJsonmodel:objectClassName key:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// plist中加载JSONModel对象(UserDefault)
+ (id)valueJsonmodel:(NSString *)objectClassName key:(NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    NSError *jserror;
    id object;
    NSString *_dataStr = [userDefault objectForKey:key];
    if (!_dataStr) {
        object = [[NSClassFromString(objectClassName) alloc] init];
        return object;
    }
    object = [[NSClassFromString(objectClassName) alloc] initWithString:_dataStr error:&jserror];
    if (!object) {
        object = [[NSClassFromString(objectClassName) alloc] init];
    }
    return object;
}

// 存储AnyObjecy对象到plist
+ (void)saveAnyObject:(id)anyObject {
    
    [self saveAnyObject:anyObject key:nil];
}

// 存储AnyObjecy对象到plist
+ (void)saveAnyObject:(id)anyObject key:(NSString *)key {
    
    [self saveAnyObject:anyObject key:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// 存储AnyObjecy对象到plist(UserDefault)
+ (void)saveAnyObject:(id)anyObject key:(NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    if (anyObject == nil && key == nil) {
        return;
    }else if (anyObject == nil) {
        [userDefault removeObjectForKey:key];
    }else {
        NSString *_key = key;
        if (key == nil) {
            _key = NSStringFromClass([anyObject class]);
        }
        if ([anyObject isKindOfClass:[NSString class]] ||
            [anyObject isKindOfClass:[NSNumber class]]) {
            [JLStorage saveNSObject:anyObject key:_key];
        }else {
            NSString *jsonStr = [anyObject yy_modelToJSONString];
            [userDefault setObject:jsonStr forKey:_key];
            [userDefault synchronize];
        }
    }
}

// plist中加载AnyObjecy对象
+ (id)valueAnyObject:(Class)classType {
    
    return [self valueAnyObject:classType key:nil];
}

// plist中加载AnyObjecy对象
+ (id)valueAnyObject:(Class)classType key:(nullable NSString *)key {
    
    return [self valueAnyObject:classType key:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// plist中加载AnyObjecy对象(UserDefault)
+ (id)valueAnyObject:(Class)classType key:(nullable NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    NSString *_key = key != nil ? key : NSStringFromClass(classType);
    if (classType == [NSString class] ||
        classType == [NSNumber class]) {
        return [JLStorage valueNSObject:_key];
    }else {
        NSString *jsonStr = [userDefault objectForKey:_key];
        if (jsonStr.length > 0) {
            id object = [classType yy_modelWithJSON:jsonStr];
            return object;
        }
    }
    return nil;
}

// 存储NSString、NSNumber等对象到plist
+ (void)saveNSObject:(id)object key:(NSString *)key {
    
    [self saveNSObject:object key:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// 存储NSString、NSNumber等对象到plist(UserDefault)
+ (void)saveNSObject:(id)object key:(NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    [userDefault setObject:object forKey:key];
    [userDefault synchronize];
}

// plist中加载NSString、NSNumber等对象
+ (id)valueNSObject:(NSString *)key {
    
    return [self valueNSObject:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// plist中加载NSString、NSNumber等对象(UserDefault)
+ (id)valueNSObject:(NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    return [userDefault objectForKey:key];
}

// plist是否存在某个key
+ (BOOL)isExistKey:(NSString *)key {
    
    return [self isExistKey:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// plist是否存在某个key(UserDefault)
+ (BOOL)isExistKey:(NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    id object = [userDefault objectForKey:key];
    if (object) {
        return YES;
    }
    return NO;
}

// plist中删除某个key
+ (void)clearObject:(NSString *)key {
    
    [self clearObject:key userDefault:[NSUserDefaults standardUserDefaults]];
}

// plist中删除某个key(UserDefault)
+ (void)clearObject:(NSString *)key userDefault:(NSUserDefaults *)userDefault {
    
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}

// 清空全部plist
+ (void)clearPlist {
    
    [self clearPlist:[NSUserDefaults standardUserDefaults]];
}

// 清空全部plist(UserDefault)
+ (void)clearPlist:(NSUserDefaults *)userDefault {
    
    NSDictionary *dictionary = [userDefault dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        [userDefault removeObjectForKey:key];
        [userDefault synchronize];
    }
}

// 清空除[excepts]以外plist
+ (void)clearPlistExcept:(NSArray *)excepts {
    
    [self clearPlistExcept:excepts userDefault:[NSUserDefaults standardUserDefaults]];
}

// 清空除[excepts]以外plist(UserDefault)
+ (void)clearPlistExcept:(NSArray *)excepts userDefault:(NSUserDefaults *)userDefault {
    
    NSDictionary *dictionary = [userDefault dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        if (![excepts containsObject:key]) {
            [userDefault removeObjectForKey:key];
            [userDefault synchronize];
        }
    }
}

#pragma mark - File Storage（Document,适合存储重要数据）

// 存储NSData对象到文件
+ (void)writeDocumentData:(NSData *)data name:(NSString *)name {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)[0];
    NSString *fileName = [documentPath stringByAppendingPathComponent:name];
    [data writeToFile:fileName atomically:YES];
}

// 获取文件的NSData
+ (id)readDocumentData:(NSString *)name {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)[0];
    NSString *fileName = [documentPath stringByAppendingPathComponent:name];
    NSData *data = [NSData dataWithContentsOfFile:fileName options:0 error:NULL];
    return data;
}

// 获取文件的路径
+ (NSString *)getDocumentFilePath:(NSString *)name {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES)[0];
    NSString *fileName = [documentPath stringByAppendingPathComponent:name];
    return fileName;
}

// 判断文件是否存在
+ (BOOL)isExistFile:(NSString *)filepath {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

#pragma mark - AppData

// 获取沙盒Document的文件目录。[Bundle/Documents]
// 最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据。
+ (NSString *)documentDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// 获取沙盒Library的文件目录。[Bundle/Library]
+ (NSString *)libraryDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

// 获取沙盒Caches的文件目录。[Bundle/Library/Preferences]
// iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据。
+ (NSString *)cachesDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

// 获取沙盒Preference的文件目录。[Bundle/Library/Caches]
// iTunes同步该应用时会同步此文件夹中的内容，通常保存应用的设置信息。
+ (NSString *)preferencePanesDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

// NSTemporaryDirectory。[Bundle/tmp]
// iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除。
+ (NSString *)temporaryDirectory {
    
    return NSTemporaryDirectory();
}

#pragma mark - Bundle

// Main Bundle
+ (NSBundle *)mainBundle {
    
    return [NSBundle mainBundle];
}

// Main Bundle Path
+ (NSString *)mainBundlePath {
    
    return [[[self class] mainBundle] bundlePath];
}

// Main Bundle File Path
+ (NSString *)mainBundleResource:(NSString *)resource type:(NSString *)type {
    
    return [[[self class] mainBundle] pathForResource:resource ofType:type];
}

// Main Bundle File Data
+ (NSData *)mainBundleResourceData:(NSString *)resource type:(NSString *)type {
    
    NSString *filePath = [[self class] mainBundleResource:resource type:type];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

// Pod Bundle
+ (NSBundle *)podBundle:(Class)classType {
    
    NSBundle *bundle = [NSBundle bundleForClass:classType];
    return bundle;
}

// Pod Bundle Path
+ (NSString *)podBundlePath:(Class)classType {
    
    return [[[self class] podBundle:classType] bundlePath];
}

// Pod Bundle File Path
+ (NSString *)podBundleResource:(NSString *)resource type:(NSString *)type class:(Class)classType {
    
    return [[self podBundle:classType] pathForResource:resource ofType:type];
}

// Pod Bundle File Data
+ (NSData *)podBundleResourceData:(NSString *)resource type:(NSString *)type class:(Class)classType {
    
    NSString *filePath = [[self class] podBundleResource:resource type:type class:classType];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

// Pod Image Types
+ (NSArray *)podBundleSupportedImageTypes {
    
    return @[@"png", @"jpg", @"jpeg", @"gif"];
}

// Pod Bundle Image
+ (UIImage *)podImage:(NSString *)name class:(Class)classType {
    
    UIImage *image = nil;
    for (NSString *type in [self podBundleSupportedImageTypes]) {
        image = [[UIImage imageWithContentsOfFile:[[self podBundle:classType] pathForResource:name ofType:type]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        if (image) return  image;
    }
    // 根据Scale确定资源名称
    int scale = (int)[[UIScreen mainScreen] scale];
    NSString *resourceName = [NSString stringWithFormat:@"%@@%dx", name, scale];
    for (NSString *type in [self podBundleSupportedImageTypes]) {
        NSBundle *bundle = [self podBundle:classType];
        NSString *path = [bundle pathForResource:resourceName ofType:type];
        image = [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        if (image) return image;
    }
    // 固定以1倍确定资源名称
    resourceName = [NSString stringWithFormat:@"%@@1x",name];
    for (NSString *type in [self podBundleSupportedImageTypes]) {
        image = [[UIImage imageWithContentsOfFile:[[self podBundle:classType] pathForResource:resourceName ofType:type]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        if (image) return image;
    }
    return nil;
}

#pragma mark - Cache

// 返回path路径下文件的文件大小。
+ (double)sizeWithFilePath:(NSString *)path {
    
    // 1.获得文件夹管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 3.判断是否为文件夹
    if (dir) {
        // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [mgr subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [mgr attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1000 * 1000.0);
    } else {
        // 文件
        NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1000 * 1000.0);
    }
}

// 删除path路径下的文件。
+ (void)clearCachesWithFilePath:(NSString *)path {
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr removeItemAtPath:path error:nil];
}

// 获取categoryName的缓存大小
+ (double)getCacheSize:(NSString *)categoryName {
    
    double cacheSize = 0.0;
    NSString *cachePath = [JLStorage cachesDirectory];
    NSString *cleanCachePath = [NSString stringWithFormat:@"%@/%@",cachePath,categoryName];
    cacheSize += [JLStorage sizeWithFilePath:cleanCachePath];
    return cacheSize;
}

// 删除categoryName的缓存
+ (void)clearCache:(NSString *)categoryName {

    NSString *cachePath = [JLStorage cachesDirectory];
    NSString *cleanCachePath = [NSString stringWithFormat:@"%@/%@",cachePath,categoryName];
    [JLStorage clearCachesWithFilePath:cleanCachePath];
}

// 获取默认缓存大小
+ (double)getCacheSize {

    double cacheSize = 0.0;
    cacheSize += [JLStorage getCacheSize:Cache_Category_Default] + [JLStorage getCacheSize:Cache_Category_SnapShots];
    return cacheSize;
}

// 删除默认缓存
+ (void)clear {

    [JLStorage clearCache:Cache_Category_Default];
    [JLStorage clearCache:Cache_Category_SnapShots];
}


@end
