//
//  JLCollectionView.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLClSectionObject.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JLCollectionView 类型声明
/**************************************************************
 **********         JLCollectionView 类型声明         **********
 **************************************************************/

@class JLCollectionView;

/**
 *  Enumeration
 *  UICollectionViewCell和HeaderFooterView的点击事件
 */
typedef NS_ENUM(NSInteger,JLClActionBlockType) {
    // UICollectionView Cell被触击
    JLClActionBlockTypeTapped,
    
    // UICollectionView Cell上的控件被触击
    JLClActionBlockTypeCustomizedTapped
};

/**
 *  Enumeration
 *  UICollectionView的滚动事件
 */
typedef NS_ENUM(NSInteger, JLClScrollBlockType) {
    // Scroll
    JLClScrollBlockTypeScroll,
    
    // Refreshing Component
    JLClScrollBlockTypeRefreshing,
    
    // Loading Component
    JLClScrollBlockTypeLoading,
    
    // Move Up
    JLClScrollBlockTypeMoveUp,
    
    // Move Down
    JLClScrollBlockTypeMoveDown,
    
    // Drag Will Begin
    JLClScrollBlockTypeDragWillBegin,
    
    // Drag Did End
    JLClScrollBlockTypeDragDidEnd,
    
    // Decelerate Will Begin
    JLClScrollBlockTypeDecelerateWillBegin,
    
    // Decelerate Did End
    JLClScrollBlockTypeDecelerateDidEnd,
};

/**
 *  Enumeration
 *  UICollectionView的编辑移动方式
 */
typedef NS_ENUM(NSInteger, JLClMoveCellType) {
    // 交换方式为插入
    JLClMoveCellTypeInsert,
    
    // 交换方式为交换
    JLClMoveCellTypeSwap
};

typedef void (^JLCollectionActionBlock)(JLCollectionView *collectionView, JLClActionBlockType type, NSInteger section, NSInteger item,  __kindof NSObject *cellData, __kindof UIView *cell);

typedef void (^JLCollectionScrollBlock)(UIScrollView *scrollView, JLClScrollBlockType type, CGFloat height, BOOL willDecelerate);

typedef void (^JLCollectionMoveBlock)(JLCollectionView *collectionView, NSIndexPath *fromIndex, NSIndexPath *toIndex, __kindof JLClCellDataSource *fromCellData, __kindof JLClCell *fromCell, __kindof JLClCellDataSource *toCellData, __kindof JLClCell *toCell);

typedef BOOL (^JLCollectionMoveShouldShakeBlock)(void);

typedef void (^JLCollectionMoveFinishedBlock)(void);

@interface JLCollectionView : UIView

#pragma mark - JLCollectionView 成员变量定义
/**************************************************************
 ***********      JLCollectionView 成员变量定义       ***********
 **************************************************************/
/**
 * [Optional]
 * 是否允许下拉
 * 默认NO
 */
@property (nonatomic, assign) BOOL                           jl_disablePullingHeader;


/**
 * [Optional]
 * 瀑布列数列数
 * 默认 1
 */
@property(nonatomic, assign) NSUInteger                      jl_waterfallColumns;

/**
 * [Optional]
 * Cell点击事件回调
 */
@property (nonatomic, copy) JLCollectionActionBlock          jl_actionBlock;

/**
 * [Optional]
 * Cell滚动事件回调
 */
@property (nonatomic, copy) JLCollectionScrollBlock          jl_scrollBlock;

/**
 * [Optional]
 * Cell移动事件回调
 */
@property (nonatomic, copy) JLCollectionMoveBlock            jl_moveBlock;


/**
 * [Optional]
 * Cell移动事件回调（是否可以Shake）
 */
@property (nonatomic, copy) JLCollectionMoveShouldShakeBlock jl_moveShouldShakeBlock;


/**
 * [Optional]
 * Cell移动事件回调（移动完成后）
 */
@property (nonatomic, copy) JLCollectionMoveFinishedBlock    jl_moveFinishedBlock;

// CollectionView
@property (nonatomic, strong, readonly) UICollectionView     *jl_collectionView;

// 数据源(设置数据源并刷新CollectionView)
@property (nonatomic, strong, readonly) NSMutableArray       *jl_dataSource;

// 是否带Section Header View
@property(nonatomic, assign, readonly) BOOL                  jl_sectionEnabled;

#pragma mark - JLCollectionView 成员方法定义
/**************************************************************
 ***********      JLCollectionView 成员方法定义       ***********
 **************************************************************/
// 生成JLCollectionView（默认）
+ (JLCollectionView *)jl_createDefaultCollectionView:(NSArray *)registerClasses waterfallColumns:(NSUInteger)waterfallColumns;

// 生成JLCollectionView（自定义）
+ (JLCollectionView *)jl_createCollectionView:(CGRect)frame backgroundColor:(UIColor *)backgroundColor collectionViewBackgroundColor:(UIColor *)collectionViewBackgroundColor sectionInset:(UIEdgeInsets)sectionInset minimumLineSpace:(CGFloat)minimumLineSpace minimumInteritemSpace:(CGFloat)minimumInteritemSpace headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight registerClasses:(NSArray *)registerClasses waterfallColumns:(NSUInteger)waterfallColumns stickyHeader:(BOOL)stickyHeader;

// 添加数据
- (void)jl_addDataSource:(id)cellDataSource;

- (void)jl_addDataSourceArray:(NSArray *)cellDataSourceArray;

// 重新刷新数据源
- (void)jl_refresh;

// 重新刷新数据源（带参数WaterfallColumns）
- (void)jl_refresh:(NSUInteger)waterfallColumns;

// 重新刷新数据源（带参数WaterfallColumns, Animation）
- (void)jl_refresh:(NSUInteger)waterfallColumns animation:(BOOL)animation;

// 重新刷新数据源（带参数WaterfallColumns, Animation, DataSource）
- (void)jl_refresh:(NSUInteger)waterfallColumns animation:(BOOL)animation dataSource:(NSArray *)dataSource;

// 更新部分参数（sectionInsets，minimumLineSpace和minimumInteritemSpace）
- (void)jl_updateSectionInsets:(UIEdgeInsets)sectionInsets minimumLineSpace:(CGFloat)minimumLineSpace minimumInteritemSpace:(CGFloat)minimumInteritemSpace;

@end


@interface JLCollectionView (Move)

// 设置Cell移动交换
- (void)jl_setCollectionCellMovable:(BOOL)movable type:(JLClMoveCellType)type;

@end

NS_ASSUME_NONNULL_END
