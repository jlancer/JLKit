


//
//  NSArray+JSON_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSArray+JSON_JL.h"
#import <MJExtension/MJExtension.h>
#import <JSONModel/JSONModel.h>

@implementation NSArray (JSON_JL)

// NSArray(包含字符串、JSONModel类型、任意类型)转JSON
- (NSString *)jl_arrayToJson {
    
    if ([self count] == 0) {
        return nil;
    }
    NSMutableString *ret = [[NSMutableString alloc] initWithString:@"["];
    for (int i = 0; i < self.count; i++) {
        JSONModel *obj = [self objectAtIndex:i];
        if (i == self.count - 1) {
            if ([obj isKindOfClass:[NSString class]]) {
                [ret appendFormat:@"\"%@\"]", obj];
            }else if ([obj isKindOfClass:[JSONModel class]]) {
                [ret appendFormat:@"%@]", [obj toJSONString]];
            }else if ([obj isKindOfClass:[NSObject class]]) {
                [ret appendFormat:@"%@]", [obj mj_JSONString]];
            }
        }else {
            if ([obj isKindOfClass:[NSString class]]) {
                [ret appendFormat:@"\"%@\",", obj];
            }else if ([obj isKindOfClass:[JSONModel class]]) {
                [ret appendFormat:@"%@,", [obj toJSONString]];
            }else if ([obj isKindOfClass:[NSObject class]]) {
                [ret appendFormat:@"%@,", [obj mj_JSONString]];
            }
        }
    }
    return ret;
}

@end
