//
//  JLTableHeaderFooterView.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

////////// ---------- View ----------//////////
@protocol JLHeaderViewDelegate <NSObject>
@required
// 点击HeaderFooter View的事件
-(void)jl_tableHeaderFooterViewActionRespond:(id)data view:(id)view;

@end

@interface JLTableHeaderFooterViewDataSource : NSObject

// HeaderFooterView的高度
@property (nonatomic, assign) CGFloat                 jl_height;

// HeaderFooterView展开后的高度
@property (nonatomic, assign) CGFloat                 jl_extendedHeight;

// HeaderFooterView是否展开状态
@property (nonatomic, assign) BOOL                    jl_extended;

@end

@protocol JLTableHeaderFooterViewDataSource <NSObject>

@end

@interface JLTableHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong, readonly) __kindof JLTableHeaderFooterViewDataSource *jl_data;

@property (nonatomic, weak) id <JLHeaderViewDelegate> delegate;

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLTableHeaderFooterViewDataSource *)data;

// Tap事件传递
- (void)jl_tapView:(__kindof JLTableHeaderFooterViewDataSource *)data;

@end

NS_ASSUME_NONNULL_END
