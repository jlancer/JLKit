//
//  JLSectionObject.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLTableHeaderFooterView.h"
#import "JLCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLSectionObject : NSObject

@property (nonatomic, strong) __kindof JLTableHeaderFooterViewDataSource  *jl_headerViewDataSource;           /* Header View的DataSource */
@property (nonatomic, strong) NSMutableArray<JLCellDataSource>            *jl_cellDataSources;                /* Cell的DataSource数组 */

@end

@protocol JLSectionObject <NSObject>

@end

NS_ASSUME_NONNULL_END
