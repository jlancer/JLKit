

//
//  NSMutableArray+JSON_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSMutableArray+JSON_JL.h"
#import "NSArray+JSON_JL.h"

@implementation NSMutableArray (JSON_JL)

// NSMutableArray(包含字符串、JSONModel类型、任意类型)转JSON
- (NSString *)jl_mutableArrayToJson {
    
    return [[NSArray arrayWithArray:self] jl_arrayToJson];
}

@end
