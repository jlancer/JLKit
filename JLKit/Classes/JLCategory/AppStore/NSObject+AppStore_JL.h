//
//  NSObject+AppStore_JL.h
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define JLAPPSTORE_MARKET_CN       @"cn"
#define JLPPSTORE_MARKET_USA      @"us"
#define JLAPPSTORE_DEFAULT_URL     @"itms-apps://appsto.re/cn/Geex4.i"
#define JLAPPSTORE_URL(mk,id)      [NSString stringWithFormat:@"itms-apps://itunes.apple.com/%@/app/id%zd?mt=8", mk, id]

@interface NSObject (AppStore_JL)

// 跳转到某个app（AppleId）
- (void)jl_appStoreRedirect:(NSInteger)appID success:(void(^)(void))success failure:(void(^)(void))failure;

// 跳转到某个app（AppleId, isLocale）
- (void)jl_appStoreRedirect:(NSInteger)appID isLocale:(BOOL)isLocale success:(void(^)(void))success failure:(void(^)(void))failure;

// 跳转到某个app（AppleId、Region/Country Market）
- (void)jl_appStoreRedirect:(NSInteger)appID market:(NSString *)market success:(void(^)(void))success failure:(void(^)(void))failure;

// 跳转到某个app（Url）
- (void)jl_appStoreRedirectUrl:(NSString *)url success:(void(^)(void))success failure:(void(^)(void))failure;

// 是否安装了某个app
- (BOOL)jl_appIsInstalled:(NSString *)scheme;

@end

NS_ASSUME_NONNULL_END
