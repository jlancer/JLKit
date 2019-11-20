//
//  JLClCell.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLClExtenedType) {
    
    // 自动展开和收缩
    JLClExtenedTypeAuto,
    
    // 展开
    JLClExtenedTypeExtend,
    
    // 收起
    JLClExtenedTypeCollapse
};

@class JLClCell,JLClCellDataSource;

@protocol JLClCellDelegate <NSObject>

@required

// UICollectionViewCell的点击事件代理
- (void)jl_collectionCellActionRespond:(__kindof JLClCellDataSource *)data cell:(__kindof JLClCell *)cell;

@end

@interface JLClCellDataSource : NSObject

// UICollectionViewCell的大小
@property (nonatomic, assign) CGSize jl_size;

// UICollectionViewCell是否可以移动
@property (nonatomic, assign) BOOL jl_disableMovable;

@end

@protocol JLClCellDataSource <NSObject>

@end

@interface JLClCell : UICollectionViewCell

// UICollectionViewCell的数据模型（只读）
@property (nonatomic, strong, readonly) __kindof JLClCellDataSource *jl_data;

// UICollectionViewCell的点击事件代理
@property (nonatomic, weak) id<JLClCellDelegate> jl_delegate;

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLClCellDataSource *)data;

// Tap事件传递
- (void)jl_tapCell:(JLClCellDataSource *)data;

// 展开和折叠事件传递
- (void)jl_extend:(JLClExtenedType)type extendedBlock:(void(^)(BOOL beforeReload, BOOL extended))extendedBlock;

// 重新加载Cell
- (void)jl_reloadCell:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
