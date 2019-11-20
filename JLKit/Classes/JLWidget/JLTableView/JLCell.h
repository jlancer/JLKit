//
//  JLCell.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

////////// ---------- Cell ----------//////////
/**
 *  Enumeration
 *  UITableViewCell的Tap效果
 */
typedef NS_ENUM(NSInteger, JLTableViewCellTapEffect) {
    
    // UITableViewCell没有选中效果
    JLTableViewCellTapEffectNone,
    
    // UITableViewCell的选中效果是自定义的
    JLTableViewCellTapEffectOrigin
};

@protocol JLCellDelegate<NSObject>

@required
// 点击UITableViewCell的事件
-(void)jl_tableCellActionRespond:(id)data cell:(id)cell;

@end

@interface JLCellDataSource : NSObject

// UITableViewCell或HeaderFooterView的高度
@property (nonatomic, assign) CGFloat jl_height;

// UITableViewCell展开后的高度
@property (nonatomic, assign) CGFloat jl_extendedHeight;

// UITableViewCell是否展开状态
@property (nonatomic, assign) BOOL jl_extended;

// 颜色
@property (nonatomic, strong) UIColor *jl_backgroundColor;                // Cell的背景色
@property (nonatomic, strong) UIColor *jl_contentViewBackgroundColor;     // Cell的ContentView的背景色（除去左右侧的空间颜色）

// Tap效果
@property (nonatomic, assign) JLTableViewCellTapEffect jl_tapEffect;

// 可显示、隐藏效果
@property (nonatomic, assign) BOOL jl_hidden;

// 控制删除和移动
@property (nonatomic, assign) BOOL jl_enableDeletion;
@property (nonatomic, assign) BOOL jl_enableMoving;

// MultiSelect状态
@property (nonatomic, assign) BOOL jl_enableMultiSelection;

// Render标记
@property (nonatomic, assign) BOOL jl_rendered;

// 标记Hash（用于判断内容是否更新过）
@property (nonatomic, assign) NSUInteger jl_hash;

// 标记MD5（用于判断内容是否更新过）
@property (nonatomic, copy) NSString *jl_md5;

// Scrollable - TableView仅刷新单个Cell时候，该参数起效，多个Cell时候，Scrollable默认为YES
@property (nonatomic, assign) BOOL jl_scrollable;

@end

@protocol JLCellDataSource <NSObject>

@end

@interface JLCell : UITableViewCell

// CellDataSource, 用于展现UI的Model
@property (nonatomic, strong, readonly) __kindof JLCellDataSource *jl_data;

// JLCell的delegate
@property (nonatomic, weak)   id <JLCellDelegate> jl_delegate;

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLCellDataSource *)data;

// Tap事件传递
- (void)jl_tapCell:(__kindof JLCellDataSource *)data;

// 展开和折叠事件传递
- (void)jl_extendCell:(BOOL)extend autoExtend:(BOOL)autoExtend before:(void(^)(__kindof JLCell *cell, BOOL extended))before completion:(void(^)(__kindof JLCell *cell, BOOL extended))completion;

// 重新加载Cell
- (void)jl_reloadCell:(UITableViewRowAnimation)animation completion:(void(^)(void))completion;

@end

@protocol JLCell <NSObject>

@end

NS_ASSUME_NONNULL_END
