//
//  JLNetwork.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCellularData.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 网络状态发生变化
 **/
#define jl_NOTIFY_NETWORK_AVAILABLE   @"jl_NOTIFY_NETWORK_AVAILABLE"
#define jl_NOTIFY_NETWORK_UNAVAILABLE @"jl_NOTIFY_NETWORK_UNAVAILABLE"

typedef NS_ENUM (NSInteger, JLNetworkStatus) {
    JLNetworkStatusUnknown,    // 网络状态：未知
    JLNetworkStatusDisconnect, // 网络状态：连接
    JLNetworkStatusViaWWAN,    // 网络状态：2G/3G/4G
    JLNetworkStatusViaWiFi     // 网络状态：WIFI
};

@interface JLPublicIPData : NSObject

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *isp;
@property (nonatomic, copy) NSString *country_id;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *region_id;
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *county_id;
@property (nonatomic, copy) NSString *isp_id;

@end

@interface JLPublicIPObject : NSObject

@property (nonatomic, assign) int code;
@property (nonatomic, strong) JLPublicIPData *data;

@end

@interface JLCarrierObject : NSObject

@property (nonatomic, copy) NSString *mcc;  // 国家码
@property (nonatomic, copy) NSString *mnc;  // 网络码 如：01
@property (nonatomic, copy) NSString *isoCountryCode;  // 国家简称
@property (nonatomic, assign) BOOL allowsVOIP;  // 是否支持VOIP
@property (nonatomic, copy) NSString *carrierName;  // 运营商名称，中国联通
// 0 - 未知  1 - 中国移动  2 - 中国联通  3 - 中国电信  4 - 中国铁通
@property (nonatomic, assign) NSUInteger carrierType;
@property (nonatomic, copy) NSString *radioAccessTechnology;  // 无线连接技术，如CTRadioAccessTechnologyLTE
@property (nonatomic, copy) NSString *netconnType; // 无线连接技术，俗称
// 0 - 未知  1 - 2G  2 - 3G  3 - 4G  4 - 5G
@property (nonatomic, assign) NSUInteger radioAccessTechnologyType;

@end

@interface JLNetwork : NSObject

/**
 *  是否有网络(带block)
 */
+ (void)jl_networkAvailable:(void(^)(BOOL success))block;

/**
 *  是否有网络
 */
+ (BOOL)jl_networkAvailable;

/**
 *  网络状态
 */
+ (JLNetworkStatus)jl_networkStatus;

/**
 *  获取WIFI的名称
 */
+ (NSString *)jl_wiFiName;

/**
 *  获取网络（WIFI/3G/4G）的权限
 */
+ (void)jl_getNetworkAuthorizationStatus:(void(^)(CTCellularDataRestrictedState state))status;

/**
 * 获取设备当前网络IP地址
 */
+ (NSString *)jl_getIPAddress:(BOOL)preferIPv4;

/**
 * 验证IP地址格式
 */
+ (BOOL)jl_isValidatIP:(NSString *)ipAddress;

/**
 * 获取IP地址组
 */
+ (NSDictionary *)jl_getIPs;

/**
 * 获取设备物理地址(iOS7以下有效)
 */
+ (nullable NSString *)jl_getMacAddress;

/**
 * 获取某个device的IP地址
 */
+ (nonnull NSString *)jl_currentIPAddressOf:(nonnull NSString *)device;

/**
 * IP地址转换
 */
+ (nullable NSString *)jl_IPv4Ntop:(in_addr_t)addr;

/**
 * IP地址转换
 */
+ (in_addr_t)jl_IPv4Pton:(nonnull NSString *)IPAddr;

/**
 *  获取外网IP
 */
+ (JLPublicIPObject *)jl_getPublicAddressThruAlibaba;

/**
 *  外网IP是否是中国的
 *  阿里巴巴
 */
+ (BOOL)jl_isChinaIPThruAlibaba;

/**
 *  网络运营商
 */
+ (JLCarrierObject *)jl_carrier;

@end

NS_ASSUME_NONNULL_END
