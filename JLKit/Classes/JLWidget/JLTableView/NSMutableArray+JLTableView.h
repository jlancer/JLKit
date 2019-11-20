//
//  NSMutableArray+JLTableView.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (JLTableView)

// 数据源中删除某个数据
- (void)jl_tableview_remove:(id)dataSource;

// 数据源中添加某个数据
- (void)jl_tableview_append:(id)dataSource;

// 数据源中插入数据源
- (void)jl_tableview_insert:(id)dataSource at:(id)aDataSource append:(BOOL)append;

// 数据源中第一个JLCellDataSource数据
- (JLCellDataSource *)jl_tableview_first;

@end

NS_ASSUME_NONNULL_END
