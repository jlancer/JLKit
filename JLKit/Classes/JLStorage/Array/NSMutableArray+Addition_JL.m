

//
//  NSMutableArray+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSMutableArray+Addition_JL.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Addition_JL)

/**
 *  NSMutableArray获取对象
 */
- (id)jl_mutableArrayObjectAtIndex:(NSUInteger)index {
    
    if (index >= 0 && index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

/**
 *  NSMutableArray增加对象
 */
- (void)jl_mutableArrayAddObject:(id)anObject {
    
    if (anObject != nil && ![anObject isKindOfClass:[NSNull class]]) {
        [self addObject:anObject];
    }
}

/**
 *  NSMutableArray插入对象
 */
- (void)jl_mutableArrayInsertObject:(id)anObject atIndex:(NSUInteger)index {
    
    if (index >= 0 && index <= self.count && anObject != nil && ![anObject isKindOfClass:[NSNull class]]) {
        [self insertObject:anObject atIndex:index];
    }
}

/**
 *  NSMutableArray删除对象（按对象）
 */
- (void)jl_mutableArrayRemoveObject:(id)object {
    
    if ([self count] >= 0) {
        [self removeObject:object];
    }
}

/**
 *  NSMutableArray删除对象（按序列）
 */
- (void)jl_mutableArrayRemoveObjectAtIndex:(NSUInteger)index {
    
    if (index >= 0 && index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

/**
 *  NSMutableArray替换对象
 */
- (void)jl_mutableArrayReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    
    if (index >= 0 && index < self.count && anObject != nil && ![anObject isKindOfClass:[NSNull class]]) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

/**
 *  NSMutableArray删除第一个对象
 */
- (void)jl_mutableArrayRemoveFirstObject {
    
    if ([self count] > 0) {
        [self removeObjectAtIndex:0];
    }
}

/**
 *  NSMutableArray删除最后一个对象
 */
- (void)jl_mutableArrayRemoveLastObject {
    
    if ([self count] > 0) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

/**
 *  NSMutableArray随机乱序
 */
- (void)jl_mutableArrayShuffle {
    
    for (NSInteger i = (NSInteger)[self count] - 1; i > 0; i--) {
        NSUInteger j = (NSUInteger)arc4random_uniform((uint32_t)i + 1);
        [(NSMutableArray *)self exchangeObjectAtIndex:j withObjectAtIndex:(NSUInteger)i];
    }
}

/**
 *  NSMutableArray倒序排列
 */
- (void)jl_mutableArrayReverse {
    
    if ([self count] >= 2) {
        for (int i = 0; i < self.count / 2; i++) {
            [self exchangeObjectAtIndex:i withObjectAtIndex:(self.count - 1 - i)];
        }
    }
}

/**
 *  添加的NSArray数组以去重的方式被添加的NSMutableArray(Self)数据
 */
- (void)jl_mutableArrayMergeAndRemoveDuplicateObjects:(NSArray *)array {
    
    NSSet *set = [NSSet setWithArray:self];
    for (id object in array) {
        if (![set containsObject:object]) {
            [(NSMutableArray *)self addObject:object];
        }
    }
}

/**
 *  NSMutableArray删除重复的对象
 */
- (void)jl_mutableArrayRemoveDuplicateObjects {
    
    [self setArray:[[NSOrderedSet orderedSetWithArray:self] array]];
}

/**
 *  取两个数组的交集
 */
- (void)jl_mutableArrayInterSectionWithArray:(NSArray *)array {
    
    NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithArray:self];
    [mutableSet intersectSet:[NSSet setWithArray:array]];
    [self removeAllObjects];
    [self addObjectsFromArray:[mutableSet array]];
}
    

/**
 *  NSMutableArray转NSArray
 */
- (NSArray *)jl_mutableArrayToArray {
    
    return [NSArray arrayWithArray:self];
}

/**
 *  按Mapping Block规则处理NSMutableArray
 */
- (void)jl_mutableArrayMappedUsingBlock:(id (^)(id object))block {
    
    if (block) {
        for (id object in self) {
            id replacement = block(object);
            if (replacement) {
                [self addObject:replacement];
            }
        }
    }
}

/**
 *  NSMutableArray是否为非空
 */
- (BOOL)jl_mutableArrayHasObject {
    
    if ([self count] > 0) {
        return YES;
    }
    return NO;
}

/**
 *  NSMutableArray是否为空
 */
- (BOOL)jl_mutableArrayIsEmpty {
    
    if ([self count] > 0) {
        return NO;
    }
    return YES;
}


@end
