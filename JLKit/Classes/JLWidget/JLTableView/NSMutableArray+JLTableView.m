//
//  NSMutableArray+JLTableView.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSMutableArray+JLTableView.h"
#import "NSArray+Addition_JL.h"
#import "JLSectionObject.h"

@implementation NSMutableArray (JLTableView)

// 数据源中删除某个数据
- (void)jl_tableview_remove:(id)dataSource {
    
    if ([self count] == 0) {
        return;
    }
    if ([[self firstObject] isKindOfClass:[JLSectionObject class]]) {
        
        id deleteSectionData = nil;
        for (JLSectionObject *sectionData in self) {
            if ([sectionData.jl_cellDataSources containsObject:dataSource]) {
                [sectionData.jl_cellDataSources removeObject:dataSource];
                if ([sectionData.jl_cellDataSources count] == 0) {
                    deleteSectionData = sectionData;
                }
                break;
            }
        }
        if (deleteSectionData != nil) {
            [self removeObject:deleteSectionData];
        }
    }else if ([[self firstObject] isKindOfClass:[JLCellDataSource class]]) {
        
        [self removeObject:dataSource];
        
    }
}

// 数据源中添加某个数据
- (void)jl_tableview_append:(id)dataSource {
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [self addObject:dataSource];
    }
}

// 数据源中插入数据源
- (void)jl_tableview_insert:(id)dataSource at:(id)aDataSource append:(BOOL)append {
    if ([self count] == 0) {
        return;
    }
    if ([[self firstObject] isKindOfClass:[JLSectionObject class]]) {
        
        for (JLSectionObject *sectionData in self) {
            if ([sectionData.jl_cellDataSources containsObject:aDataSource]) {
                
                NSUInteger index = [sectionData.jl_cellDataSources indexOfObject:aDataSource];
                if (!append) {
                    [sectionData.jl_cellDataSources insertObject:dataSource atIndex:index];
                }else{
                    [sectionData.jl_cellDataSources insertObject:dataSource atIndex:index+1];
                }
                
                break;
            }
        }
    }else if ([[self firstObject] isKindOfClass:[JLCellDataSource class]]) {
        
        NSUInteger index = [self indexOfObject:aDataSource];
        if (!append) {
            [self insertObject:dataSource atIndex:index];
        }else{
            [self insertObject:dataSource atIndex:index+1];
        }
        
    }
}

// 数据源中第一个JLCellDataSource数据
- (JLCellDataSource *)jl_tableview_first {
    if ([self count] == 0) {
        return nil;
    }
    if ([[self firstObject] isKindOfClass:[JLSectionObject class]]) {
        
        JLSectionObject *firstSectionObject = [self firstObject];
        return [firstSectionObject.jl_cellDataSources firstObject];
        
    }else if ([[self firstObject] isKindOfClass:[JLCellDataSource class]]) {
        return [self firstObject];
    }
    return nil;
}

@end
