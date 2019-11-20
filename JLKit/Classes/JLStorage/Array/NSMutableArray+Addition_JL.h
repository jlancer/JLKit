//
//  NSMutableArray+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
*
*  NSMutableArray扩展方法
*  所有方法都是操作安全的
*  线程安全请配合SafeMutableArray
*
*/

@interface NSMutableArray (Addition_JL)

/**
 *  NSMutableArray获取对象
 */
- (id)jl_mutableArrayObjectAtIndex:(NSUInteger)index;

/**
 *  NSMutableArray增加对象
 */
- (void)jl_mutableArrayAddObject:(id)anObject;

/**
 *  NSMutableArray插入对象
 */
- (void)jl_mutableArrayInsertObject:(id)anObject atIndex:(NSUInteger)index;

/**
 *  NSMutableArray删除对象（按对象）
 */
- (void)jl_mutableArrayRemoveObject:(id)object;

/**
 *  NSMutableArray删除对象（按序列）
 */
- (void)jl_mutableArrayRemoveObjectAtIndex:(NSUInteger)index;

/**
 *  NSMutableArray替换对象
 */
- (void)jl_mutableArrayReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

/**
 *  NSMutableArray删除第一个对象
 */
- (void)jl_mutableArrayRemoveFirstObject;

/**
 *  NSMutableArray删除最后一个对象
 */
- (void)jl_mutableArrayRemoveLastObject;

/**
 *  NSMutableArray随机乱序
 */
- (void)jl_mutableArrayShuffle;

/**
 *  NSMutableArray倒序排列
 */
- (void)jl_mutableArrayReverse;

/**
 *  添加的NSArray数组以去重的方式被添加的NSMutableArray(Self)数据
 */
- (void)jl_mutableArrayMergeAndRemoveDuplicateObjects:(NSArray *)array;

/**
 *  NSMutableArray删除重复的对象
 */
- (void)jl_mutableArrayRemoveDuplicateObjects;

/**
 *  取两个数组的交集
 */
- (void)jl_mutableArrayInterSectionWithArray:(NSArray *)array;

/**
 *  NSMutableArray转NSArray
 */
- (NSArray *)jl_mutableArrayToArray;

/**
 *  按Mapping Block规则处理NSMutableArray
 */
- (void)jl_mutableArrayMappedUsingBlock:(id (^)(id object))block;

/**
 *  NSMutableArray是否为非空
 */
- (BOOL)jl_mutableArrayHasObject;

/**
 *  NSMutableArray是否为空
 */
- (BOOL)jl_mutableArrayIsEmpty;

@end

NS_ASSUME_NONNULL_END
