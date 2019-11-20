//
//  NSArray+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Addition_JL.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Addition_JL)

/**
 *  NSArray获取对象
 */
- (id)jl_arrayObjectAtIndex:(NSUInteger)index;

/**
 *  NSArray增加对象
 */
- (NSMutableArray *)jl_arrayAddObject:(id)anObject;

/**
 *  NSArray插入对象
 */
- (NSMutableArray *)jl_arrayInsertObject:(id)anObject atIndex:(NSUInteger)index;

/**
 *  NSArray删除对象（按对象）
 */
- (NSMutableArray *)jl_arrayRemoveObject:(id)object;

/**
 *  NSArray删除对象（按序列）
 */
- (NSMutableArray *)jl_arrayRemoveObjectAtIndex:(NSUInteger)index;

/**
 *  NSArray替换对象
 */
- (NSMutableArray *)jl_arrayReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object;

/**
 *  NSArray删除第一个对象
 */
- (NSMutableArray *)jl_arrayRemoveFirstObject;

/**
 *  NSArray删除最后一个对象
 */
- (NSMutableArray *)jl_arrayRemoveLastObject;

/**
 *  NSArray随机乱序
 */
- (NSMutableArray *)jl_arrayShuffle;

/**
 *  NSArray倒序排列
 */
- (NSMutableArray *)jl_arrayReverse;

/**
 *  添加的NSArray数组以去重的方式被添加的NSArray(Self)数据
 */
- (NSMutableArray *)jl_arrayMergeAndRemoveDuplicateObjects:(NSArray *)array;

/**
 *  NSArray删除重复的对象
 */
- (NSMutableArray *)jl_arrayRemoveDuplicateObjects;

/**
 *  取两个数组的交集
 */
- (NSMutableArray *)jl_arrayInterSectionWithArray:(NSArray *)array;

/**
 *  NSArray转NSMutableArray
 */
- (NSMutableArray *)jl_arrayToMutableArray;

/**
 *  按Mapping Block规则生成NSArray
 */
- (NSMutableArray *)jl_arrayMappedUsingBlock:(id (^)(id object))block;

/**
 *  NSArray是否为非空
 */
- (BOOL)jl_arrayHasObject;

/**
 *  NSArray是否为空
 */
- (BOOL)jl_arrayIsEmpty;

@end

NS_ASSUME_NONNULL_END
