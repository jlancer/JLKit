//
//  JLStorage.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>
#import <JSONModel/JSONModel.h>
#import <YYModel/YYModel.h>

#define YYModelContainerPropertyGenericClass(dict) \
+ (NSDictionary *)modelContainerPropertyGenericClass { \
    return dict; \
}

#define YYModelCustomPropertyMapper(dict) \
+ (NSDictionary *)modelCustomPropertyMapper { \
    return dict; \
}

NS_ASSUME_NONNULL_BEGIN

@interface JLStorage : NSObject

#pragma mark - Plist Storage

// 存储JSONModel对象到plist
+ (void)saveJsonmodel:(id)object key:(NSString *)key ;
// 存储JSONModel对象到plist(UserDefault)
+ (void)saveJsonmodel:(id)object key:(NSString *)key userDefault:(NSUserDefaults *)userDefault;

// plist中加载JSONModel对象
+ (id)valueJsonmodel:(NSString *)objectClassName key:(NSString *)key;
// plist中加载JSONModel对象(UserDefault)
+ (id)valueJsonmodel:(NSString *)objectClassName key:(NSString *)key userDefault:(NSUserDefaults *)userDefault;

// 存储AnyObjecy对象到plist
+ (void)saveAnyObject:(id)anyObject;
// 存储AnyObjecy对象到plist
+ (void)saveAnyObject:(id)anyObject key:(NSString *)key;
// 存储AnyObjecy对象到plist(UserDefault)
+ (void)saveAnyObject:(id)anyObject key:(NSString *)key userDefault:(NSUserDefaults *)userDefault;

// plist中加载AnyObjecy对象
+ (id)valueAnyObject:(Class)classType;
// plist中加载AnyObjecy对象
+ (id)valueAnyObject:(Class)classType key:(nullable NSString *)key;
// plist中加载AnyObjecy对象(UserDefault)
+ (id)valueAnyObject:(Class)classType key:(nullable NSString *)key userDefault:(NSUserDefaults *)userDefault;

// 存储NSString、NSNumber等对象到plist
+ (void)saveNSObject:(id)object key:(NSString *)key;
// 存储NSString、NSNumber等对象到plist(UserDefault)
+ (void)saveNSObject:(id)object key:(NSString *)key userDefault:(NSUserDefaults *)userDefault;

// plist中加载NSString、NSNumber等对象
+ (id)valueNSObject:(NSString *)key;
// plist中加载NSString、NSNumber等对象(UserDefault)
+ (id)valueNSObject:(NSString *)key userDefault:(NSUserDefaults *)userDefault;

// plist是否存在某个key
+ (BOOL)isExistKey:(NSString *)key;
// plist是否存在某个key(UserDefault)
+ (BOOL)isExistKey:(NSString *)key userDefault:(NSUserDefaults *)userDefault;

// plist中删除某个key
+ (void)clearObject:(NSString *)key;
// plist中删除某个key(UserDefault)
+ (void)clearObject:(NSString *)key userDefault:(NSUserDefaults *)userDefault;

// 清空全部plist
+ (void)clearPlist;
// 清空全部plist(UserDefault)
+ (void)clearPlist:(NSUserDefaults *)userDefault;

// 清空除[excepts]以外plist
+ (void)clearPlistExcept:(NSArray *)excepts;
// 清空除[excepts]以外plist(UserDefault)
+ (void)clearPlistExcept:(NSArray *)excepts userDefault:(NSUserDefaults *)userDefault;

#pragma mark - File Storage（Document,适合存储重要数据）

// 存储NSData对象到Document目录
+ (void)writeDocumentData:(NSData *)data name:(NSString *)name;

// 获取文件的Document的文件
+ (id)readDocumentData:(NSString *)name;

// 获取Document文件的路径
+ (NSString *)getDocumentFilePath:(NSString *)name;

// 判断文件是否存在
+ (BOOL)isExistFile:(NSString *)filepath;


#pragma mark - AppData

// 获取沙盒Document的文件目录。[Bundle/Documents]
// 最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据。
+ (NSString *)documentDirectory;

// 获取沙盒Library的文件目录。[Bundle/Library]
+ (NSString *)libraryDirectory;

// 获取沙盒Caches的文件目录。[Bundle/Library/Preferences]
// iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据。
+ (NSString *)cachesDirectory;

// 获取沙盒Preference的文件目录。[Bundle/Library/Caches]
// iTunes同步该应用时会同步此文件夹中的内容，通常保存应用的设置信息。
+ (NSString *)preferencePanesDirectory;

// NSTemporaryDirectory。[Bundle/tmp]
// iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除。
+ (NSString *)temporaryDirectory;

#pragma mark - Bundle

// Main Bundle
+ (NSBundle *)mainBundle;

// Main Bundle Path
+ (NSString *)mainBundlePath;

// Main Bundle File Path
+ (NSString *)mainBundleResource:(NSString *)resource type:(NSString *)type;

// Main Bundle File Data
+ (NSData *)mainBundleResourceData:(NSString *)resource type:(NSString *)type;

// Pod Bundle
+ (NSBundle *)podBundle:(Class)classType;

// Pod Bundle Path
+ (NSString *)podBundlePath:(Class)classType;

// Pod Bundle File Path
+ (NSString *)podBundleResource:(NSString *)resource type:(NSString *)type class:(Class)classType;

// Pod Bundle File Data
+ (NSData *)podBundleResourceData:(NSString *)resource type:(NSString *)type class:(Class)classType;

// Pod Image Types
+ (NSArray *)podBundleSupportedImageTypes;

// Pod Bundle Image
+ (UIImage *)podImage:(NSString *)name class:(Class)classType;

#pragma mark - Cache

// 返回path路径下文件的文件大小。
+ (double)sizeWithFilePath:(NSString *)path;

// 删除path路径下的文件。
+ (void)clearCachesWithFilePath:(NSString *)path;

// 获取categoryName的缓存大小
+ (double)getCacheSize:(NSString *)categoryName;

// 删除categoryName的缓存
+ (void)clearCache:(NSString *)categoryName;

// 获取默认缓存大小
+ (double)getCacheSize;

// 删除默认缓存
+ (void)clear;

@end

NS_ASSUME_NONNULL_END
