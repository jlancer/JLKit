//
//  NSDictionary+JSON_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON_JL)

// 字典转JSON
- (NSString *)jl_dictionaryToJSON;

@end

NS_ASSUME_NONNULL_END
