
//
//  JLClView.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLClView.h"
#import "JLCollectionView.h"
#import "UIView+Addition_JL.h"

// View

@interface JLClView()

// HeaderFooterView的数据模型
@property (nonatomic, strong) __kindof JLClViewDataSource *jl_data;

@end

@implementation JLClView

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLClViewDataSource *)data {
    
    self.jl_data = data;
}

// Tap事件传递
- (void)jl_tapView:(__kindof JLClViewDataSource *)data {
    
    if (self.jl_delegate != nil) {
        [self.jl_delegate jl_collectionHeaderFooterViewActionRespond:data view:self];
    }
}

@end

@implementation JLClHeaderView

@end

@implementation JLClFooterView

@end

// DataSource
@implementation JLClViewDataSource

@end

@implementation JLClHeaderViewDataSource

@end

@implementation JLClFooterViewDataSource

@end
