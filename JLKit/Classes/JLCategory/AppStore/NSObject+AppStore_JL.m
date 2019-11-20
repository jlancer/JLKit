//
//  NSObject+AppStore_JL.m
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+AppStore_JL.h"

@implementation NSObject (AppStore_JL)

// 跳转到某个app（AppleId）
- (void)jl_appStoreRedirect:(NSInteger)appID success:(void(^)(void))success failure:(void(^)(void))failure {
    
    [self jl_appStoreRedirect:appID isLocale:YES success:success failure:failure];
}

// 跳转到某个app（AppleId, isLocale）
- (void)jl_appStoreRedirect:(NSInteger)appID isLocale:(BOOL)isLocale success:(void(^)(void))success failure:(void(^)(void))failure {
    
    NSString *region = nil;
    if (@available(iOS 10.0, *)) {
        region = [NSLocale currentLocale].countryCode;
    }else if ([[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] != nil) {
        region = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    }else {
        region = JLAPPSTORE_MARKET_CN;
    }
    [self jl_appStoreRedirect:appID market:region success:success failure:failure];
}

// 跳转到某个app（AppleId、Region/Country Market）
- (void)jl_appStoreRedirect:(NSInteger)appID market:(NSString *)market success:(void(^)(void))success failure:(void(^)(void))failure {
    
    __weak typeof(self) weakSelf = self;
    NSString *url = JLAPPSTORE_URL(market, appID);
    [self jl_appStoreRedirectUrl:url success:success failure:^{
        [weakSelf jl_appStoreRedirectUrl:JLAPPSTORE_DEFAULT_URL success:success failure:failure];
    }];
}

// 跳转到某个app（Url）
- (void)jl_appStoreRedirectUrl:(NSString *)url success:(void(^)(void))success failure:(void(^)(void))failure {
    
    NSURL *appURL = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
        }else {
            [[UIApplication sharedApplication] openURL:appURL];
        }
        success == nil ? : success();
    }else{
        failure == nil ? : failure();
    }
}

// 是否安装了某个app
- (BOOL)jl_appIsInstalled:(NSString *)scheme {
    
    NSURL * app_scheme_url = [NSURL URLWithString:scheme];
    if (![[UIApplication sharedApplication] canOpenURL:app_scheme_url]) {
        return NO;
    }
    return YES;
}

// 跳转Setting
- (void)jl_appGoSetting {
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success){}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
