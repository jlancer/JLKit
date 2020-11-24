//
//  APIConfig.h
//  JLKit
//
//  Created by wangjian on 2020/11/24.
//  Copyright © 2020 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

///TODO: - 发布到线上前「注释JLDEBUG」
// 设置接口A/B环境
#define JLDEBUG

#define HOST_A              @"https://www.production.com/"       // 生产
#define HOST_B              @"https://www.test.com/"        // 测试

#define HOST_PROD           HOST_A
#define HOST_DEV            HOST_B

typedef NS_ENUM(NSInteger, APIEnvironmentType) {
    APIEnvironmentTypeTest = 0, //开发/测试环境
    APIEnvironmentTypeProduction, //生产环境
    APIEnvironmentTypeCustomize //自定义环境
};

NS_ASSUME_NONNULL_BEGIN

@interface APIConfig : NSObject

// 当前环境
+ (APIEnvironmentType)getEnviroment;

// 当前HOST URL
+ (NSString *)baseURL;

// 当前WEB HOST URL
+ (NSString *)webBaseURL;

/**
 自定义环境，一步实现应用内环境切换 及 方便开发调试

 @param env 要切换到的环境
 */
+ (void)setEnviroment:(APIEnvironmentType)env url:(NSString *)url;

// 用户自定义URL
+ (NSString *)customizeURL;

@end

NS_ASSUME_NONNULL_END
