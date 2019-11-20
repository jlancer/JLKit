//
//  JLTableView.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLCell.h"
#import "JLTableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@class JLTableView;

////////// ---------- TableView ----------//////////
/**
 *  NOT FOUND INDEX
 */
#define NOT_FOUND_INDEX (-1)

/**
 *  Enumeration
 *  UITableViewCell的式样
 */
typedef NS_ENUM(NSInteger, JLCellEditingStyle) {
    // 无编辑
    JLCellEditingStyleNone,
    
    // 显式删除
    JLCellEditingStyleDeletionExplicit,
    
    // 滑动删除
    JLCellEditingStyleDeletionSwipe,
    
    // 显式删除(确认是否删除)
    JLCellEditingStyleDeletionExplicitWConfirm,
    
    // 滑动删除(确认是否删除)
    JLCellEditingStyleDeletionSwipeWConfirm,
    
    // 插入
    JLCellEditingStyleInsert,
    
    // 多选
    JLCellEditingStyleMultiSelection,
    
    // 移动
    JLCellEditingStyleMove
};

/**
 *  Enumeration
 *  UITableViewCell的删除策略
 */
typedef NS_ENUM(NSInteger,JLCellDeletionPolicy) {
    // (默认)删除数据源， removed from tbDataSource
    JLCellDeletionPolicyRemove,
    
    // 隐藏，visible = NO
    JLCellDeletionPolicyHidden
};

/**
 *  Enumeration
 *  UITableViewCell和HeaderFooterView的点击事件
 */
typedef NS_ENUM(NSInteger,JLActionBlockType) {
    
    // Cell被触击
    JLActionBlockTypeTapped,
    
    // Cell上的控件被触击
    JLActionBlockTypeCustomizedTapped,
    
    // Cell被删除（滑动删除、显式删除）
    JLActionBlockTypeDeleted,
    
    // Cell被删除（滑动删除、显式删除前确认）
    JLActionBlockTypeDeletedWConfirm,
    
    // Cell被添加（添加的内容需要自己添加）
    JLActionBlockTypeInserted,
    
    // Cell被多选（或取消多选）
    JLActionBlockTypeMultiSelected
};

/**
 *  Enumeration
 *  UITableView的滚动事件
 */
typedef NS_ENUM(NSInteger, JLScrollBlockType) {
    // Scroll
    JLScrollBlockTypeScroll,
    
    // Refreshing Component
    JLScrollBlockTypeRefreshing,
    
    // Loading Component
    JLScrollBlockTypeLoading,
    
    // Move Up
    JLScrollBlockTypeMoveUp,
    
    // Move Down
    JLScrollBlockTypeMoveDown,
    
    // Drag Will Begin
    JLScrollBlockTypeDragWillBegin,
    
    // Drag Did End
    JLScrollBlockTypeDragDidEnd,
    
    // Decelerate Will Begin
    JLScrollBlockTypeDecelerateWillBegin,
    
    // Decelerate Did End
    JLScrollBlockTypeDecelerateDidEnd,
};

/**
 *  Enumeration
 *  UITableViewCell的展开和收起的状态
 */
typedef NS_ENUM(NSInteger, JLExtenedType) {
    
    // 自动展开和收缩
    JLExtenedTypeAuto,
    
    // 展开
    JLExtenedTypeExtend,
    
    // 收缩
    JLExtenedTypeCollapse
};

/**
 * Block
 * Cell点击事件回调
 */
typedef void       (^JLTableViewActionBlock)(__weak JLTableView *tableView, JLActionBlockType type, NSInteger section, NSInteger row, __kindof JLCellDataSource *cellData, __kindof JLCell *cell, __kindof JLTableHeaderFooterViewDataSource *headerFooterData, __kindof JLTableHeaderFooterView *headerFooter);

/**
 * Block
 * Cell滚动事件回调
 */
typedef void       (^JLTableViewScrollBlock)(__weak UIScrollView *scrollView, JLScrollBlockType type, CGFloat height, BOOL willDecelerate);

/**
 *  Block
 *  UITableViewCell、HeaderFooterView的点击回调事件定义
 */
typedef void       (^JLTableViewMoveBlock)(__weak JLTableView *tableView, NSIndexPath *fromIndex, NSIndexPath *toIndex, __kindof JLCellDataSource *fromCellData, __kindof JLCell *fromCell, __kindof JLCellDataSource *toCellData, __kindof JLCell *toCell);

/**
 * Block
 * Cell Indexes事件回调
 * 设置Indexes数组，return list of section titles to display in section index view (e.g. "ABCD...Z#")
 */
typedef NSArray*   (^JLTableViewIndexesBlock)(__weak JLTableView *tableView);

/**
 * Block
 * Cell Index事件回调
 * 设置点击Index返回Section位置，tell table which section corresponds to section title/index (e.g. "B",1))
 */
typedef NSUInteger (^JLTableViewIndexBlock)(__weak JLTableView *tableView, NSString *title, NSUInteger index);


@interface JLTableView : UIView

/*******************************
 *     JLTableView Data定义    *
 *******************************/
/**
 * [Optional]
 * Cell编辑式样
 * 默认是jl_CellEditingStyle_None
 */
@property (nonatomic, assign) JLCellEditingStyle jl_editingStyle;

/**
 * [Optional]
 * Cell的分割属性
 * 默认UITableViewCellSeparatorStyleNone
 */
@property (nonatomic, assign) UITableViewCellSeparatorStyle jl_seperatorStyle;

/**
 * [Optional]
 * Cell插入、删除等刷新的动画
 * 默认UITableViewRowAnimationFade
 */
@property (nonatomic, assign) UITableViewRowAnimation jl_rowAnimation;

/**
 * [Optional]
 * Cell删除策略
 * 默认是jl_CellDeletion_Policy_Hidden
 */
@property (nonatomic, assign) JLCellDeletionPolicy jl_policy;

/*************************
 *          Block        *
 *************************/
// 点击\滚动\移动事件回调
@property (nonatomic, copy) JLTableViewActionBlock  jl_actionBlock;
@property (nonatomic, copy) JLTableViewScrollBlock  jl_scrollBlock;
@property (nonatomic, copy) JLTableViewMoveBlock    jl_moveBlock;
// Indexes和Index的事件回调
@property (nonatomic, copy) JLTableViewIndexesBlock jl_indexesBlock;
@property (nonatomic, copy) JLTableViewIndexBlock   jl_indexBlock;

// TableView
@property (nonatomic, strong, readonly) UITableView *jl_tableView;

// 数据源(设置数据源并刷新tableView)
@property (nonatomic, strong, readonly) NSMutableArray *jl_dataSource;

// 是否带Section Header View
@property (nonatomic, assign, readonly) BOOL jl_sectionEnabled;

/*************************
 *   生成 - Table/Data   *
 *************************/
// 生成JLTableView（默认）
+ (JLTableView *)jl_createDefaultTableView;

// 生成JLTableView（自定义）
+ (JLTableView *)jl_createTableView:(CGRect)frame editStyle:(JLCellEditingStyle)editStyle seperatorStyle:(UITableViewCellSeparatorStyle)seperatorStyle backgroundColor:(UIColor *)backgroundColor tableViewBackgroundColor:(UIColor *)tableViewBackgroundColor;

// 添加数据
- (void)jl_addDataSource:(id)cellDataSource;

- (void)jl_addDataSourceArray:(NSArray *)cellDataSourceArray;

// 重新刷新数据源
- (void)jl_refresh;
- (void)jl_refresh:(NSMutableArray *)dataSource;


/************************************
 *          Scroll 动作             *
 ************************************/
#pragma mark - Scroll 动作
// 滚动到某个indexPath
- (void)jl_scrollToIndexPath:(NSIndexPath *)indexPath position:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

// 滚动到某个JLCellDataSource
- (void)jl_scrollToCellDataSource:(__kindof JLCellDataSource *)cellDataSource position:(UITableViewScrollPosition)position animated:(BOOL)animated;

// 滚动到第一个CellDataSource的类型
- (void)jl_scrollToTheFirstCellClass:(Class)dataSourceClass position:(UITableViewScrollPosition)position animated:(BOOL)animated;


/******************************
 *           内部方法          *
 ******************************/
// 计算DataSource中没有disabled的个数
- (int)jl_visibleCellsCount:(NSArray *)cellDataSources;
// 根据cellData获取实际对应到TableView的Row Index
- (int)jl_visibleIndex:(NSArray *)cellDataSources cellData:(__kindof JLCellDataSource *)cellData;
// 根据cellData的类型获取实际对应到第一个TableView的Row Index
- (int)jl_visibleIndex:(NSArray *)cellDataSources cellClass:(id)cellClass;

// 根据Index获得Cell
- (__kindof JLCell *)jl_cellForRow:(NSInteger)row section:(NSInteger)section;
// 根据DataSource获得Cell
- (__kindof JLCell *)jl_cellForDataSource:(__kindof JLCellDataSource *)cellDataSource;
// 根据DataSource的类型获得Cell （若存在多个，仅返回第一个cell）
- (__kindof JLCell *)jl_cellForClass:(id)cellClass;
// 根据DataSource的类型获得Cells
- (NSMutableArray<JLCell> *)jl_cellsForClass:(id)cellClass;

// 根据Index获得DataSource
- (JLCellDataSource *)jl_dataSourceForRow:(NSInteger)row;
// 根据DataSource的类型获得DataSource （若存在多个，仅返回第一个DataSource）
- (JLCellDataSource *)jl_dataSourceForClass:(id)cellClass;
// 根据DataSource的类型获得DataSources
- (NSMutableArray<JLCellDataSource> *)jl_dataSourcesForClass:(id)cellClass;

// 检查indexPath的合法性
- (__kindof JLCellDataSource *)jl_dataSourceByIndexPath:(NSIndexPath *)indexPath;
// 获取第row个非jl_hidden的Cell
- (__kindof JLCellDataSource *)jl_visibleDataSource:(NSArray *)datas row:(NSInteger)row;

// 根据Index重新加载Cell
- (void)jl_reloadCellForRow:(NSInteger)row section:(NSInteger)section;
// 根据DataSource重新加载Cell
- (void)jl_reloadCellForDataSource:(__kindof JLCellDataSource *)cellDataSource;
// 根据DataSource的类型重新加载所有的Cells
- (void)jl_reloadCellsForClass:(id)cellClass;

@end

NS_ASSUME_NONNULL_END
