

//
//  JLCell.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLCell.h"
#import "JLTableView.h"
#import "UIView+Addition_JL.h"
#import "JLSectionObject.h"

@interface JLCell ()

@property (nonatomic, strong) __kindof JLCellDataSource *jl_data;

@end

@implementation JLCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self layoutIfNeeded];
}

// 设置数据和渲染UI方法入口
- (void)jl_setData:(__kindof JLCellDataSource *)data {
    
    _jl_data = data;
}

// Tap事件传递
- (void)jl_tapCell:(__kindof JLCellDataSource *)data {
    
    if(self.jl_delegate != nil) {
        [self.jl_delegate jl_tableCellActionRespond:data cell:self];
    }
}

// 展开和折叠事件传递
- (void)jl_extendCell:(BOOL)extend autoExtend:(BOOL)autoExtend before:(void(^)(__kindof JLCell *cell, BOOL extended))before completion:(void(^)(__kindof JLCell *cell, BOOL extended))completion {
    
    __weak typeof(self) weakSelf = self;
    if (autoExtend == YES) {
        self.jl_data.jl_extended = !self.jl_data.jl_extended;
        if (before != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                before(weakSelf, weakSelf.jl_data.jl_extended);
            });
        }
        [self jl_reloadCell:UITableViewRowAnimationNone completion:^{
            completion == nil ? : completion(weakSelf, weakSelf.jl_data.jl_extended);
        }];
    }else{
        if (extend == YES){
            self.jl_data.jl_extended = YES;
            if (before != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    before(weakSelf, weakSelf.jl_data.jl_extended);
                });
            }
            [self jl_reloadCell:UITableViewRowAnimationNone completion:^{
                completion == nil ? : completion(weakSelf, weakSelf.jl_data.jl_extended);
            }];
        }else{
            if (before != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    before(weakSelf, weakSelf.jl_data.jl_extended);
                });
            }
            [self jl_reloadCell:UITableViewRowAnimationNone completion:^{
                completion == nil ? : completion(weakSelf, weakSelf.jl_data.jl_extended);
            }];
        }
    }
}

// 重新加载Cell
- (void)jl_reloadCell:(UITableViewRowAnimation)animation completion:(void(^)(void))completion {
    
    // 查找JLTableView
    JLTableView *tableView = [self jl_findView:[JLTableView class]];
    
    if (tableView) {
        // 定位JLCellDataSource后刷新
        NSUInteger section = 0;
        NSUInteger row = 0;
        if ([[tableView.jl_dataSource firstObject] isKindOfClass:[JLSectionObject class]]) {
            for (section = 0; section < [tableView.jl_dataSource count]; section++) {
                JLSectionObject *sectionObject = [tableView.jl_dataSource objectAtIndex:section];
                for (row = 0; row < [sectionObject.jl_cellDataSources count]; row++) {
                    JLCellDataSource *data = [sectionObject.jl_cellDataSources objectAtIndex:row];
                    if ([data isEqual:self.jl_data]) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                        [tableView.jl_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                    }
                }
            }
        }else if([[tableView.jl_dataSource firstObject] isKindOfClass:[JLCellDataSource class]]) {
            for (row = 0; row < [tableView.jl_dataSource count]; row++) {
                JLCellDataSource *data = [tableView.jl_dataSource objectAtIndex:row];
                if ([data isEqual:self.jl_data]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    [tableView.jl_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                }
            }
        }
    }
    if (completion != nil) {
        if (animation == UITableViewRowAnimationNone) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }
}

@end


@interface JLCellDataSource()

@end


@implementation JLCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jl_scrollable = YES;
        self.jl_enableDeletion = YES;
    }
    return self;
}

@end
