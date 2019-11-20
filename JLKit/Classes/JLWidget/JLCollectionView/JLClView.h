//
//  JLClView.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLClCell.h"

NS_ASSUME_NONNULL_BEGIN

@class JLClView,JLClViewDataSource;

@protocol JLClViewDelegate <NSObject>

@required
// 点击HeaderFooter View的事件
-(void)jl_collectionHeaderFooterViewActionRespond:(__kindof JLClViewDataSource *)data view:(__kindof JLClView *)view;

@end

// Common HeaderFooter View DataSource
@interface JLClViewDataSource : NSObject

// HeaderFooterView的高度
@property (nonatomic, assign) CGFloat                 jl_height;

// HeaderFooterView展开后的高度
@property (nonatomic, assign) CGFloat                 jl_extendedHeight;

// HeaderFooterView是否展开状态
@property (nonatomic, assign) BOOL                    jl_extended;

@end

// Header View DataSource
@interface JLClHeaderViewDataSource : JLClViewDataSource

@end

// Footer View DataSource
@interface JLClFooterViewDataSource : JLClViewDataSource

@end

// Common HeaderFooter View
@interface JLClView : UICollectionReusableView

// HeaderFooterView的数据模型
@property (nonatomic, strong, readonly) __kindof JLClViewDataSource *jl_data;

// HeaderFooterView的点击事件代理
@property (nonatomic, assign) id<JLClViewDelegate> jl_delegate;

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLClViewDataSource *)data;

// Tap事件传递
- (void)jl_tapView:(__kindof JLClViewDataSource *)data;

@end

// Header View
@interface JLClHeaderView : JLClView

@end

// Footer View
@interface JLClFooterView : JLClView

@end


NS_ASSUME_NONNULL_END
