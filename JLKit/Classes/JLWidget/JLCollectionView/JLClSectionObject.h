//
//  JLClSectionObject.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLClView.h"
#import "JLClCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLClSectionObject : NSObject

// HeaderView的DataSource
@property (nonatomic, strong) __kindof JLClHeaderViewDataSource  *jl_headerViewDataSource;

// FooterView的DataSource
@property (nonatomic, strong) __kindof JLClFooterViewDataSource  *jl_footerViewDataSource;

// UICollectionViewCell的模型数组
@property (nonatomic, strong) NSMutableArray<JLClCellDataSource> *jl_cellDataSources;

@end

@protocol JLClSectionObject <NSObject>

@end

NS_ASSUME_NONNULL_END
