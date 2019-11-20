//
//  NSMutableArray+JSON_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (JSON_JL)

// NSMutableArray(包含字符串、JSONModel类型、任意类型)转JSON
- (NSString *)jl_mutableArrayToJson;

@end

NS_ASSUME_NONNULL_END
