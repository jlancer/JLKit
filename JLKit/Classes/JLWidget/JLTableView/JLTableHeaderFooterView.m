
//
//  JLTableHeaderFooterView.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLTableHeaderFooterView.h"

@interface JLTableHeaderFooterView ()

@property (nonatomic, strong) __kindof JLTableHeaderFooterViewDataSource *jl_data;

@end

@implementation JLTableHeaderFooterView

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLTableHeaderFooterViewDataSource *)data {
    
    self.jl_data = data;
}

// Tap事件传递
- (void)jl_tapView:(__kindof JLTableHeaderFooterViewDataSource *)data {
    
    if(self.delegate != nil) {
        [self.delegate jl_tableHeaderFooterViewActionRespond:data view:self];
    }
}

@end

@implementation JLTableHeaderFooterViewDataSource

@end
