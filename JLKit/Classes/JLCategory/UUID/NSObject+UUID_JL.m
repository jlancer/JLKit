
//
//  NSObject+UUID_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSObject+UUID_JL.h"
#import <AdSupport/AdSupport.h>

@implementation NSObject (UUID_JL)

/**
 *  IDFA UUID
 */
+ (NSString *)jl_uuidIDFA {
    
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

/**
 *  IDFA UUID （Without Line）
 */
+ (NSString *)jl_uuidIDFANoLine {

    return [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 *  IDFV UUID
 */
+ (NSString *)jl_uuidIDFV {
    
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *deviceUDID = [[myDevice identifierForVendor] UUIDString];
    return deviceUDID;
}

/**
 *  IDFV UUID （Without Line）
 */
+ (NSString *)jl_uuidIDFVNoLine {
    
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *deviceUDID = [[myDevice identifierForVendor] UUIDString];
    return [deviceUDID stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 *  随机UUID
 */
+ (NSString *)jl_uuidRandom {
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

/**
 *  随机UUID( + TimeStamp )
 */
+ (NSString *)jl_uuidRandomTimestamp {
    
    NSDate *dateNow = [NSDate date];
    long long now = (long long)[dateNow timeIntervalSince1970];
    return [NSString stringWithFormat:@"%@_%lld", [self jl_uuidRandom], now];
}

@end
