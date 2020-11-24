//
//  APIConfig.m
//  JLKit
//
//  Created by wangjian on 2020/11/24.
//  Copyright © 2020 wangjian. All rights reserved.
//

#import "APIConfig.h"

/**
 在项目中获取git信息
 注意配置好之后，需要Clean一遍项目,不然会报错GitCommitBranch不存在
 1、在Info.plist增加GitCommitBranch（名字自定，表达清晰即可）项，用于记录分支名称
 2、在 Xcode(TARGETS项目target) - Build Phases - New Run Script Phase，增加脚本配置，用于获取git信息并更新到Info.plist中, 脚本代码如下：

 #当前的分支
 git_branch=$(git symbolic-ref --short -q HEAD)

 #获取App安装包下的info.plist文件路径
 info_plist="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/Info.plist"

 #利用PlistBuddy改变info.plist的值
 /usr/libexec/PlistBuddy -c "Set :'GitCommitBranch'    '${git_branch}'"                 "${info_plist}"

 */
const static NSString *kTestRegx = @"^(dev|feature).*$";
const static NSString *kProductionRegx = @"^master";

@interface APIConfig()

@property (nonatomic, copy) NSString *baseURL;

@property (nonatomic, assign) APIEnvironmentType env;

@property (nonatomic, strong) NSPredicate *testPredicate;
@property (nonatomic, strong) NSPredicate *productionPredicate;

@end

@implementation APIConfig

#pragma mark -Public Methods

+ (APIEnvironmentType)getEnviroment {
#ifdef JLDEBUG
    return [APIConfig shared].env;
#else
    return APIEnvironmentTypeProduction;
#endif
    return APIEnvironmentTypeProduction;
}

+ (NSString *)baseURL {
#ifdef JLDEBUG
    return [APIConfig shared].baseURL;
#else
    return HOST_PROD;
#endif
    return HOST_PROD;
}

// 当前WEB HOST URL
+ (NSString *)webBaseURL {
#ifdef WWDEBUG
    return @"https://m.test.com/";
#else
    return @"https://m.production.com/";
#endif
    return @"https://m.production.com/";
}

+ (void)setEnviroment:(APIEnvironmentType)env url:(NSString *)url {
    [APIConfig shared].env = env;
    [[APIConfig shared] updateConfig];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@(env) forKey:@"SWAGGERENV"];
    if (url.length > 0) {
        [userDefault setObject:url forKey:@"SWAGGERURL"];
    }
    [userDefault synchronize];
}

// 用户自定义URL
+ (NSString *)customizeURL {
    
    NSString *customUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"SWAGGERURL"];
    return customUrl;
}

#pragma mark -life cycle

+ (APIConfig *)shared {
    
    static APIConfig *_config = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[APIConfig alloc] init];
        [_config commonInit];
    });
    return _config;
}

- (void)commonInit {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SWAGGERENV"]) {
        self.env = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SWAGGERENV"] intValue];
    } else {
        _testPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kTestRegx];
        _productionPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kProductionRegx];

        [self envForCurrentBranch];
    }
    [self updateConfig];
}

/**
 根据分支名称，进行正则匹配，指定环境
 */
- (void)envForCurrentBranch {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * branch = infoDict[@"GitCommitBranch"];
    
    if ([self.testPredicate evaluateWithObject:branch]) {
        //测试
        self.env = APIEnvironmentTypeTest;
    }
    else if ([self.productionPredicate evaluateWithObject:branch]) {
        //生产环境
        self.env = APIEnvironmentTypeProduction;
    }
    else {
        //自定义
        self.env = APIEnvironmentTypeCustomize;
    }
}

- (void)updateConfig {
    /**
     * 对根据环境变化的参数进行配置
     */
    switch (self.env) {
        case APIEnvironmentTypeTest:
            self.baseURL = HOST_DEV;
            break;
            
        case APIEnvironmentTypeProduction:
            self.baseURL = HOST_PROD;
            break;
            
        case APIEnvironmentTypeCustomize:
            self.baseURL = [APIConfig customizeURL];
            break;
            
        default:
            self.baseURL = HOST_DEV;
            break;
    }
}

@end
