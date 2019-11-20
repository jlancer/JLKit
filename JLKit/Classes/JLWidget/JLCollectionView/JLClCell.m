

//
//  JLClCell.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLClCell.h"
#import "JLCollectionView.h"
#import "UIView+Addition_JL.h"

@interface JLClCell()

// UICollectionViewCell的数据模型
@property (nonatomic, strong) __kindof JLClCellDataSource *jl_data;

@end

@implementation JLClCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self layoutIfNeeded];
}

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLClCellDataSource *)data {
    
    _jl_data = data;
}

// Tap事件传递
- (void)jl_tapCell:(JLClCellDataSource *)data {
    
    if (self.jl_delegate != nil) {
        [self.jl_delegate jl_collectionCellActionRespond:data cell:self];
    }
}

// 展开和折叠事件传递
- (void)jl_extend:(JLClExtenedType)type extendedBlock:(void(^)(BOOL beforeReload, BOOL extended))extendedBlock {
    
    // TODO 展开和折叠事件传递
}

// 重新加载Cell
- (void)jl_reloadCell:(void(^)(void))completion {
    
    // TODO 重新加载Cell
}

@end


@implementation JLClCellDataSource

@end
