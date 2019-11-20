

//
//  JLNetwork.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLNetwork.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <resolv.h>
#import <net/if.h>
#import <netdb.h>
#import <netinet/ip.h>
#import <net/ethernet.h>
#import <net/if_dl.h>
#import <sys/sysctl.h>
#import <sys/ioctl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define MDNS_PORT       5353
#define QUERY_NAME      "_apple-mobdev2._tcp.local"
#define DUMMY_MAC_ADDR  @"02:00:00:00:00:00"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation JLPublicIPData

@end

@implementation JLPublicIPObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [[JLPublicIPData alloc] init];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [JLPublicIPData class]};
}

@end

@implementation JLCarrierObject

@end

@interface JLNetwork()

// 网络状态
@property (nonatomic, assign) JLNetworkStatus networkStatus;
@property (nonatomic, strong) id cellularData;

@end

@implementation JLNetwork

#pragma mark - Public Method

+ (id)shared {
    static JLNetwork *SINGLETON = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id)allocWithZone:(NSZone *)zone {
    return [self shared];
}

- (id)copy {
    return [[JLNetwork alloc] init];
}

- (id)mutableCopy {
    return [[JLNetwork alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        self.networkStatus = JLNetworkStatusViaWWAN;
        [self _startNetworkMonitoring];
    }
    return self;
}

#pragma mark - Public

/**
 *  是否有网络(带block)
 */
+ (void)jl_networkAvailable:(void(^)(BOOL success))block {
    
    BOOL ret = [JLNetwork jl_networkAvailable];
    block == nil ? : block(ret);
}

/**
 *  是否有网络
 */
+ (BOOL)jl_networkAvailable {
    
    JLNetwork *instance = [JLNetwork shared];
    if (instance.networkStatus == JLNetworkStatusDisconnect) {
        return NO;
    }
    return YES;
}

/**
 *  网络状态
 */
+ (JLNetworkStatus)jl_networkStatus {
    
    JLNetwork *instance = [JLNetwork shared];
    return instance.networkStatus;
}

/**
 *  获取WIFI的名称
 */
+ (NSString *)jl_wiFiName {
    
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

/**
 *  获取网络（WIFI/3G/4G）的权限
 */
+ (void)jl_getNetworkAuthorizationStatus:(void(^)(CTCellularDataRestrictedState state))status {
    
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        JLNetwork *instance = [JLNetwork shared];
        instance.cellularData = cellularData;
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            status == nil ? : status(state);
        };
    }else {
        status == nil ? : status(kCTCellularDataRestrictedStateUnknown);
    }
}

/**
 * 获取设备当前网络IP地址
 */
+ (NSString *)jl_getIPAddress:(BOOL)preferIPv4 {
    
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self jl_getIPs];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        address = addresses[key];
        //筛选出IP地址格式
        if([JLNetwork jl_isValidatIP:address]) *stop = YES;
    }];
    return address ? address : @"0.0.0.0";
}

/**
 * 验证IP地址格式
 */
+ (BOOL)jl_isValidatIP:(NSString *)ipAddress {
    
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        return firstMatch;
    }
    return NO;
}

/**
 * 获取IP地址组
 */
+ (NSDictionary *)jl_getIPs {
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

/**
 * 获取设备物理地址(iOS7以下有效)
 */
+ (nullable NSString *)jl_getMacAddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

/**
 * 获取某个device的IP地址
 */
+ (nonnull NSString *)jl_currentIPAddressOf:(nonnull NSString *)device {
    
    struct ifaddrs *addrs;
    NSString *ipAddress = nil;
    if(getifaddrs(&addrs) != 0) {
        return nil;
    }
    
    //get ipv4 address
    for(struct ifaddrs *addr = addrs ; addr ; addr = addr->ifa_next) {
        if(!strcmp(addr->ifa_name, [device UTF8String])) {
            if(addr->ifa_addr) {
                struct sockaddr_in *in_addr = (struct sockaddr_in *)addr->ifa_addr;
                if(in_addr->sin_family == AF_INET) {
                    ipAddress = [self jl_IPv4Ntop:in_addr->sin_addr.s_addr];
                    break;
                }
            }
        }
    }
    freeifaddrs(addrs);
    return ipAddress;
}

/**
 * IP地址转换
 */
+ (nullable NSString *)jl_IPv4Ntop:(in_addr_t)addr {
    
    char buffer[INET_ADDRSTRLEN] = {0};
    return inet_ntop(AF_INET, &addr, buffer, sizeof(buffer)) ?
    [NSString stringWithUTF8String:buffer] : nil;
}

/**
 * IP地址转换
 */
+ (in_addr_t)jl_IPv4Pton:(nonnull NSString *)IPAddr {
    
    in_addr_t network = INADDR_NONE;
    return inet_pton(AF_INET, [IPAddr UTF8String], &network) == 1 ?
    network : INADDR_NONE;
}

/**
 *  获取外网IP
 */
+ (JLPublicIPObject *)jl_getPublicAddressThruAlibaba {
    
    @try {
        NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
        NSData *data = [NSData dataWithContentsOfURL:ipURL];
        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (ipDic && [ipDic[@"code"] intValue] == 0) {//获取成功
            JLPublicIPObject *object = [[JLPublicIPObject alloc] init];
            object.code = 0;
            object.data.ip = ipDic[@"data"][@"ip"];
            object.data.county = ipDic[@"data"][@"country"];
            object.data.area = ipDic[@"data"][@"area"];
            object.data.region = ipDic[@"data"][@"region"];
            object.data.city = ipDic[@"data"][@"city"];
            object.data.county = ipDic[@"data"][@"county"];
            object.data.isp = ipDic[@"data"][@"isp"];
            object.data.country_id = ipDic[@"data"][@"country_id"];
            object.data.area_id = ipDic[@"data"][@"area_id"];
            object.data.region_id = ipDic[@"data"][@"region_id"];
            object.data.city_id = ipDic[@"data"][@"city_id"];
            object.data.county_id = ipDic[@"data"][@"county_id"];
            object.data.isp_id = ipDic[@"data"][@"isp_id"];
            return object;
        }
    } @catch (NSException *exception) {
        return nil;
    }
    return nil;
}

/**
 *  外网IP是否是中国的
 *  阿里巴巴
 */
+ (BOOL)jl_isChinaIPThruAlibaba {
    
    JLPublicIPObject *ipObject = [[self class] jl_getPublicAddressThruAlibaba];
    if (ipObject != nil && ([ipObject.data.country_id isEqualToString:@"CN"] || [ipObject.data.country isEqualToString:@"中国"] )) {
        return YES;
    }
    return NO;
}

/**
 *  网络运营商
 */
+ (JLCarrierObject *)jl_carrier {
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    // 国家码和网络码查询
    // https://en.wikipedia.org/wiki/Mobile_country_code
    JLCarrierObject *carrierObject = [[JLCarrierObject alloc] init];
    carrierObject.mcc = [carrier mobileCountryCode];
    carrierObject.mnc = [carrier mobileNetworkCode];
    carrierObject.carrierName = [carrier carrierName];
    carrierObject.isoCountryCode = [carrier isoCountryCode];
    carrierObject.allowsVOIP = [carrier allowsVOIP];
    carrierObject.radioAccessTechnology = info.currentRadioAccessTechnology;
    if ([carrierObject.mcc isEqualToString:@"460"]) {
        switch ([carrierObject.mnc intValue]) {
                case 0:
                case 2:
                case 4:
                case 7:
                case 8:
            {
                carrierObject.carrierType = 1;
                break;
            }
                case 1:
                case 6:
                case 9:
            {
                carrierObject.carrierType = 2;
                break;
            }
                break;
                case 3:
                case 5:
                case 11:
            {
                carrierObject.carrierType = 3;
                break;
            }
            case 20:
            {
                carrierObject.carrierType = 4;
                break;
            }
            default:
                break;
        }
    }
    if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        
        carrierObject.netconnType = @"GPRS";
        carrierObject.radioAccessTechnologyType = 0;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        
        carrierObject.netconnType = @"2.75G EDGE";
        carrierObject.radioAccessTechnologyType = 1;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyWCDMA"]) {
        
        carrierObject.netconnType = @"3G";
        carrierObject.radioAccessTechnologyType = 2;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
        
        carrierObject.netconnType = @"3.5G HSDPA";
        carrierObject.radioAccessTechnologyType = 2;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
        
        carrierObject.netconnType = @"3.5G HSUPA";
        carrierObject.radioAccessTechnologyType = 2;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
        
        carrierObject.netconnType = @"2G";
        carrierObject.radioAccessTechnologyType = 1;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]) {
        
        carrierObject.netconnType = @"3G";
        carrierObject.radioAccessTechnologyType = 2;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]) {
        
        carrierObject.netconnType = @"3G";
        carrierObject.radioAccessTechnologyType = 2;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
        
        carrierObject.netconnType = @"3G";
        carrierObject.radioAccessTechnologyType = 2;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
        
        carrierObject.netconnType = @"HRPD";
        carrierObject.radioAccessTechnologyType = 2;
    }else if ([carrierObject.radioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
        
        carrierObject.netconnType = @"4G";
        carrierObject.radioAccessTechnologyType = 3;
    }else {
        
        carrierObject.netconnType = @"Unknown";
        carrierObject.radioAccessTechnologyType = 0;
    }
    return carrierObject;
}

#pragma mark - Private

// 开启监视网络
- (void)_startNetworkMonitoring {
    
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // Un known
                weakSelf.networkStatus = JLNetworkStatusUnknown;
                [[NSNotificationCenter defaultCenter] postNotificationName:jl_NOTIFY_NETWORK_UNAVAILABLE object:nil userInfo:@{@"name":@"unknown"}];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                // Disconnect
                weakSelf.networkStatus = JLNetworkStatusDisconnect;
                [[NSNotificationCenter defaultCenter] postNotificationName:jl_NOTIFY_NETWORK_UNAVAILABLE object:nil userInfo:@{@"name":@"notreachable"}];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // WIFI
                weakSelf.networkStatus = JLNetworkStatusViaWiFi;
                [[NSNotificationCenter defaultCenter] postNotificationName:jl_NOTIFY_NETWORK_AVAILABLE object:nil userInfo:@{@"name":@"wifi"}];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                // Services Network
                weakSelf.networkStatus = JLNetworkStatusViaWWAN;
                [[NSNotificationCenter defaultCenter] postNotificationName:jl_NOTIFY_NETWORK_AVAILABLE object:nil userInfo:@{@"name":@"wwan"}];
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


@end
