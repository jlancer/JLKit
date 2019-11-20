


//
//  NSArray+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSArray+Addition_JL.h"
#import <objc/runtime.h>

@implementation NSArray (Addition_JL)

/**
 *  NSArray获取对象
 */
- (id)jl_arrayObjectAtIndex:(NSUInteger)index {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return [((NSMutableArray *)self) jl_mutableArrayObjectAtIndex:index];
    }else {
        if (index >= 0 && index < self.count) {
            return [self objectAtIndex:index];
        }
        return nil;
    }
}

/**
 *  NSArray增加对象
 */
- (NSMutableArray *)jl_arrayAddObject:(id)anObject {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayAddObject:anObject];
        return (NSMutableArray *)self;
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray jl_mutableArrayAddObject:anObject];
        return mutableArray;
    }
}

/**
 *  NSArray插入对象
 */
- (NSMutableArray *)jl_arrayInsertObject:(id)anObject atIndex:(NSUInteger)index {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayInsertObject:anObject atIndex:index];
        return (NSMutableArray *)self;
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray jl_mutableArrayInsertObject:anObject atIndex:index];
        return mutableArray;
    }
}

/**
 *  NSArray删除对象（按对象）
 */
- (NSMutableArray *)jl_arrayRemoveObject:(id)object {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayRemoveObject:object];
        return (NSMutableArray *)self;
    }else {
        if ([self count] == 0) {
            return [NSMutableArray new];
        }else {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
            [mutableArray removeObject:object];
            return mutableArray;
        }
    }
}

/**
 *  NSArray删除对象（按序列）
 */
- (NSMutableArray *)jl_arrayRemoveObjectAtIndex:(NSUInteger)index {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayRemoveObjectAtIndex:index];
        return (NSMutableArray *)self;
    }else {
        if ([self count] == 0) {
            return [NSMutableArray new];
        } else if (index < 0 || index >= [self count]) {
            // 越界
            return [NSMutableArray arrayWithArray:self];
        }else {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
            [mutableArray removeObjectAtIndex:index];
            return mutableArray;
        }
    }
}

/**
 *  NSArray替换对象
 */
- (NSMutableArray *)jl_arrayReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayReplaceObjectAtIndex:index withObject:object];
        return (NSMutableArray *)self;
    }else {
        if ([self count] == 0) {
            // 数据为空
            return [NSMutableArray new];
        }else {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
            [mutableArray replaceObjectAtIndex:index withObject:object];
            return mutableArray;
        }
    }
}

/**
 *  NSArray删除第一个对象
 */
- (NSMutableArray *)jl_arrayRemoveFirstObject {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayRemoveFirstObject];
        return (NSMutableArray *)self;
    }else {
        if ([self count] == 0) {
            // 数据为空
            return [NSMutableArray new];
        }else if ([self count] == 1) {
            return [NSMutableArray new];
        }else {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
            [mutableArray removeObjectAtIndex:0];
            return mutableArray;
        }
    }
}

/**
 *  NSArray删除最后一个对象
 */
- (NSMutableArray *)jl_arrayRemoveLastObject {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayRemoveLastObject];
        return (NSMutableArray *)self;
    }else {
        if ([self count] == 0) {
            // 数据为空
            return [NSMutableArray new];
        }else if ([self count] == 1) {
            return [NSMutableArray new];
        }else {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
            [mutableArray removeLastObject];
            return mutableArray;
        }
    }
}

/**
 *  NSArray随机乱序
 */
- (NSMutableArray *)jl_arrayShuffle {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayShuffle];
        return (NSMutableArray *)self;
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray jl_mutableArrayShuffle];
        return mutableArray;
    }
}

/**
 *  NSArray倒序排列
 */
- (NSMutableArray *)jl_arrayReverse {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayReverse];
        return (NSMutableArray *)self;
    }else {
        return [NSMutableArray arrayWithArray:[[self reverseObjectEnumerator] allObjects]];
    }
}

/**
 *  添加的NSArray数组以去重的方式被添加的NSArray(Self)数据
 */
- (NSMutableArray *)jl_arrayMergeAndRemoveDuplicateObjects:(NSArray *)array {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayMergeAndRemoveDuplicateObjects:array];
        return (NSMutableArray *)self;
    }else {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
        [mutableArray jl_mutableArrayMergeAndRemoveDuplicateObjects:array];
        return mutableArray;
    }
}

/**
 *  NSArray删除重复的对象
 */
- (NSMutableArray *)jl_arrayRemoveDuplicateObjects {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayRemoveDuplicateObjects];
        return (NSMutableArray *)self;
    }else {
        return [NSMutableArray arrayWithArray:[[NSOrderedSet orderedSetWithArray:self] array]];
    }
}

/**
 *  取两个数组的交集
 */
- (NSMutableArray *)jl_arrayInterSectionWithArray:(NSArray *)array {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayInterSectionWithArray:array];
        return (NSMutableArray *)self;
    }else {
        NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithArray:self];
        [mutableSet intersectSet:[NSSet setWithArray:array]];
        return [NSMutableArray arrayWithArray:[mutableSet array]];
    }
}

/**
 *  NSArray转NSMutableArray
 */
- (NSMutableArray *)jl_arrayToMutableArray {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return (NSMutableArray *)self;
    }else {
        return [NSMutableArray arrayWithArray:self];
    }
}

/**
 *  按Mapping Block规则生成NSArray
 */
- (NSMutableArray *)jl_arrayMappedUsingBlock:(id (^)(id object))block {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) jl_mutableArrayMappedUsingBlock:block];
        return (NSMutableArray *)self;
    }else {
        if (block) {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[self count]];
            for (id object in self) {
                id replacement = block(object);
                if (replacement) {
                    [mutableArray addObject:replacement];
                }
            }
            return mutableArray;
        }else {
            return [NSMutableArray arrayWithArray:self];
        }
    }
}

/**
 *  NSArray是否为非空
 */
- (BOOL)jl_arrayHasObject {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return [((NSMutableArray *)self) jl_mutableArrayHasObject];
    }else {
        if ([self count] > 0) {
            return YES;
        }
        return NO;
    }
}

/**
 *  NSArray是否为空
 */
- (BOOL)jl_arrayIsEmpty {
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return [((NSMutableArray *)self) jl_mutableArrayIsEmpty];
    }else {
        if ([self count] > 0) {
            return NO;
        }
        return YES;
    }
}

@end
