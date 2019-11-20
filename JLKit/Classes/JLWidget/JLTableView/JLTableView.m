

//
//  JLTableView.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLTableView.h"
#import <Masonry/Masonry.h>
#import "NSArray+Addition_JL.h"
#import "JLCell.h"
#import "JLSectionObject.h"
#import "NSMutableArray+JLTableView.h"

#define BACKGROUND_COLOR [UIColor whiteColor]

@interface JLTableView () <UITableViewDataSource, UITableViewDelegate, JLCellDelegate, JLHeaderViewDelegate>

// TableView
@property (nonatomic, strong) UITableView *jl_tableView;

// 数据源(设置数据源并刷新TableView)
@property (nonatomic, strong) NSMutableArray *jl_dataSource;

// 是否带Section Header View
@property (nonatomic, assign) BOOL jl_sectionEnabled;

// scrollview滚动到最上方静止状态的临界值(contentOffset)
@property (nonatomic, assign) CGFloat _jl_initY;
// scrollview滚动到最下方静止状态的临界值(contentOffset)
@property (nonatomic, assign) CGFloat _jl_endY;
// scrollview上次滚动的y值(contentOffset)
@property (nonatomic, assign) CGFloat _jl_lastY;

// Cell的编辑风格
@property (nonatomic, assign) UITableViewCellEditingStyle _jl_cellEditingStyle;

@end

@implementation JLTableView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self layoutIfNeeded];
}

/*************************
 *      系统初始化方法     *
 *************************/
// 初始化TableView（from code）
-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.jl_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height) style:UITableViewStylePlain];
        self.jl_tableView.delegate = self;
        self.jl_tableView.dataSource = self;
        [self addSubview:self.jl_tableView];
        __weak typeof(self) weakSelf = self;
        [self.jl_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        // 禁止显示滚动条
        self.jl_tableView.showsVerticalScrollIndicator = NO;
        self.jl_tableView.showsHorizontalScrollIndicator = NO;
        // 默认分割线贴边
        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8) {
            [self.jl_tableView setLayoutMargins:UIEdgeInsetsZero];
        }else if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
            [self.jl_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        // 允许滚动回顶部
        self.jl_tableView.scrollsToTop = YES;
        // 设置估高(need to explicit set estimatedRowHeight to 0 if you are using frame layout for cell under iOS11)
        self.jl_tableView.estimatedRowHeight = 0;
        // 初始化内部变量
        self.jl_dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

// 初始化TableView（from xib）
-(id)initWithCoder:(NSCoder *)coder {
    
    if (self = [super initWithCoder:coder]) {
        self.jl_tableView = [[UITableView alloc] initWithCoder:coder];
        self.jl_tableView.delegate = self;
        self.jl_tableView.dataSource = self;
        [self addSubview:self.jl_tableView];
        __weak typeof(self) weakSelf = self;
        [self.jl_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        // 禁止显示滚动条
        self.jl_tableView.showsVerticalScrollIndicator = NO;
        self.jl_tableView.showsHorizontalScrollIndicator = NO;
        // 默认分割线贴边
        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8) {
            [self.jl_tableView setLayoutMargins:UIEdgeInsetsZero];
        }else if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
            [self.jl_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        // 允许滚动回顶部
        self.jl_tableView.scrollsToTop = YES;
        // 设置估高(need to explicit set estimatedRowHeight to 0 if you are using frame layout for cell under iOS11)
        self.jl_tableView.estimatedRowHeight = 0;
        // 初始化内部变量
        self.jl_dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

/*************************
 *        设置属性        *
 *************************/
- (void)setjl_editingStyle:(JLCellEditingStyle)jl_editingStyle {
    
    _jl_editingStyle = jl_editingStyle;
    switch (jl_editingStyle) {
        case JLCellEditingStyleInsert:
        {
            self.jl_tableView.editing = YES;
            self._jl_cellEditingStyle = UITableViewCellEditingStyleInsert;
            break;
        }
        case JLCellEditingStyleMultiSelection:
        {
            self.jl_tableView.editing = YES;
            self._jl_cellEditingStyle = UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
            break;
        }
        case JLCellEditingStyleDeletionSwipe:
        case JLCellEditingStyleDeletionSwipeWConfirm:
        {
            self.jl_tableView.editing = NO;
            self._jl_cellEditingStyle = UITableViewCellEditingStyleDelete;
            break;
        }
        case JLCellEditingStyleDeletionExplicit:
        case JLCellEditingStyleDeletionExplicitWConfirm:
        {
            self.jl_tableView.editing = YES;
            self._jl_cellEditingStyle = UITableViewCellEditingStyleDelete;
            break;
        }
        case JLCellEditingStyleMove:
        {
            self.jl_tableView.editing = YES;
            self._jl_cellEditingStyle = UITableViewCellEditingStyleNone;
            break;
        }
        case JLCellEditingStyleNone:
        default:
        {
            self.jl_tableView.editing = NO;
            self._jl_cellEditingStyle = UITableViewCellEditingStyleNone;
            break;
        }
    }
}

- (void)setjl_seperatorStyle:(UITableViewCellSeparatorStyle)jl_seperatorStyle {

    _jl_seperatorStyle = jl_seperatorStyle;
    self.jl_tableView.separatorStyle = jl_seperatorStyle;
}

/*************************
 *   生成 - Table/Data   *
 *************************/
// 生成JLTableView（默认）
+ (JLTableView *)jl_createDefaultTableView {
    
    return [JLTableView jl_createTableView:CGRectZero editStyle:JLCellEditingStyleNone seperatorStyle:UITableViewCellSeparatorStyleNone backgroundColor:[UIColor clearColor] tableViewBackgroundColor:BACKGROUND_COLOR];
}

// 生成JLTableView（自定义）
+ (JLTableView *)jl_createTableView:(CGRect)frame editStyle:(JLCellEditingStyle)editStyle seperatorStyle:(UITableViewCellSeparatorStyle)seperatorStyle backgroundColor:(UIColor *)backgroundColor tableViewBackgroundColor:(UIColor *)tableViewBackgroundColor {
    
    JLTableView *tableView = [[JLTableView alloc] initWithFrame:frame];
    // 保存和设置属性
    tableView.jl_editingStyle = editStyle;
    tableView.jl_seperatorStyle = seperatorStyle;
    if (backgroundColor != nil) {
        tableView.backgroundColor = backgroundColor;
    }else {
        tableView.backgroundColor = BACKGROUND_COLOR;
    }
    if (tableViewBackgroundColor != nil) {
        tableView.jl_tableView.backgroundColor = tableViewBackgroundColor;
    }
    // 返回JLTableView实例
    return tableView;
}

// 添加数据
- (void)jl_addDataSource:(id)cellDataSource {
    
    if (cellDataSource != nil) {
        [self.jl_dataSource addObject:cellDataSource];
    }
}

- (void)jl_addDataSourceArray:(NSArray *)cellDataSourceArray {
    
    if (cellDataSourceArray != nil) {
        [self.jl_dataSource addObjectsFromArray:cellDataSourceArray];
    }
}

// 重新刷新数据源
- (void)jl_refresh {
    
    [self performSelectorOnMainThread:@selector(_refresh) withObject:nil waitUntilDone:YES];
}

- (void)_refresh {
    
    // Check DataSource
    BOOL scrollEnabled = YES;
    _jl_sectionEnabled = NO;
    if (self.jl_dataSource != nil) {
        id first = [self.jl_dataSource firstObject];
        if ([first isKindOfClass:[JLSectionObject class]]) {
            _jl_sectionEnabled = YES;
            if (((JLSectionObject *)first).jl_cellDataSources.count == 1) {
                JLCellDataSource *firstCellData = ((JLSectionObject *)first).jl_cellDataSources.firstObject;
                scrollEnabled = firstCellData.jl_scrollable;
            }
        }else if ([first isKindOfClass:[JLCellDataSource class]]) {
            if (self.jl_dataSource.count == 1) {
                JLCellDataSource *firstCellData = self.jl_dataSource.firstObject;
                scrollEnabled = firstCellData.jl_scrollable;
            }
        }
    }
    // Reload
    [self.jl_tableView reloadData];
    // Scrollable
    self.jl_tableView.scrollEnabled = scrollEnabled;
}

// 设置数据源
- (void)jl_refresh:( NSMutableArray *_Nonnull )dataSource {
    
    @synchronized(self) {
        [self.jl_dataSource removeAllObjects];
        [self.jl_dataSource addObjectsFromArray:dataSource];
        [self jl_refresh];
    }
}

/***************************************
 * 代理：TableView的Delegate和DataSource *
 ***************************************/
#pragma mark - Table view delegate & data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_jl_sectionEnabled) {
        return [self.jl_dataSource count];
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_jl_sectionEnabled) {
        JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
        return [self jl_visibleCellsCount:sectionObject.jl_cellDataSources];
    }else {
        return [self jl_visibleCellsCount:self.jl_dataSource];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // BaseCellDataSource
    JLCellDataSource *cellData = [self jl_dataSourceByIndexPath:indexPath];
    // 越界处理
    if (cellData == nil) {
        return nil;
    }
    // 获取Cell名
    NSString *cellClassName;
    if ([cellData isKindOfClass:[JLCellDataSource class]]) {
        cellClassName = [NSString stringWithUTF8String:object_getClassName(cellData)];
        cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
    }
    JLCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell) {
        // 注册Cell(第一次注册的时候)
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(cellClassName)];
        [tableView registerNib:[UINib nibWithNibName:cellClassName bundle:bundle] forCellReuseIdentifier:cellClassName];
        cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    }
    /* 设置Cell的Accessory的类型
     UITableViewCellAccessoryNone
     UITableViewCellAccessoryDisclosureIndicator
     UITableViewCellAccessoryDetailDisclosureButton __TVOS_PROHIBITED
     UITableViewCellAccessoryCheckmark
     UITableViewCellAccessoryDetailButton
     cell.accessoryType = UITableViewCellAccessoryNone;
     */
    // Cell的代理
    cell.jl_delegate = self;
    // 设置Cell是有点击效果
    if (cellData.jl_tapEffect == JLTableViewCellTapEffectNone) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        /* 这种方式会导致其它UI的颜色设置全部失效 */
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = BACKGROUND_COLOR;
    }
    // ContentView的背景色优先级高
    if (cellData.jl_contentViewBackgroundColor) {
        cell.contentView.backgroundColor = cellData.jl_contentViewBackgroundColor;
    }
    if(cellData.jl_backgroundColor) {
        cell.backgroundColor = cellData.jl_backgroundColor;
    }
    // 传值给Cell
    [cell jl_setData:cellData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLCellDataSource *data = [self jl_dataSourceByIndexPath:indexPath];
    // 越界处理
    if (data == nil) {
        return;
    }
    // 非多选的Editing模式，当TapEffect也不是默认，那么自动取消选择是为了不让Cell点击后选中。
    if (self.jl_editingStyle != JLCellEditingStyleMultiSelection) {
        if (data.jl_tapEffect == JLTableViewCellTapEffectNone) {
            
        }else {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    JLCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.jl_editingStyle == JLCellEditingStyleMultiSelection) {
        // 多重选择
        data.jl_enableMultiSelection = YES;
        self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeMultiSelected, section, row, data, cell, nil, nil);
    }else {
        // 点击Cell
        self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeTapped, section, row, data, cell, nil, nil);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLCellDataSource *data = [self jl_dataSourceByIndexPath:indexPath];
    // 越界处理
    if (data == nil) {
        return;
    }
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (self.jl_editingStyle == JLCellEditingStyleMultiSelection) {
        // 多重选择
        JLCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        data.jl_enableMultiSelection = NO;
        self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeMultiSelected, section, row, data, cell, nil, nil);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLCellDataSource *cellData = [self jl_dataSourceByIndexPath:indexPath];
    // 越界处理
    if (cellData == nil) {
        return 0.0;
    }
    if (cellData.jl_extended) {
        return cellData.jl_extendedHeight;
    }else {
        return cellData.jl_height;
    }
}

// 是否可以删除、插入和选择
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLCellDataSource *cellData = [self jl_dataSourceByIndexPath:indexPath];
    // 越界处理
    if (cellData == nil) {
        return NO;
    }
    return (self.jl_editingStyle != JLCellEditingStyleNone) || cellData.jl_enableDeletion;
}

//删除风格    :UITableViewCellEditingStyleDelete （默认风格）  当tableView.editing=YES时，显示删除  /  当tableView.editing=NO时，隐藏删除，滑动出现  ||| 相应方法：commitEditingStyle
//插入风格    :UITableViewCellEditingStyleInsert  当tableView.editing=YES生效  ||| 相应方法：commitEditingStyle
//无风格      :UITableViewCellEditingStyleNone
//多组选中风格 :UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete  ||| 相应方法：didSelectRowAtIndexPath
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 先判断Cell是否控制允许删除选项
    if (_jl_sectionEnabled) {
        JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:[indexPath section]];
        JLCellDataSource *cellData = [sectionObject.jl_cellDataSources objectAtIndex:[indexPath row]];
        if (cellData.jl_enableDeletion == NO) {
            return UITableViewCellEditingStyleNone;
        }
    }else {
        JLCellDataSource *cellData = [self.jl_dataSource objectAtIndex:[indexPath row]];
        if (cellData.jl_enableDeletion == NO) {
            return UITableViewCellEditingStyleNone;
        }
    }
    // 其次，返回Cell Editing Style
    return __jl_cellEditingStyle;
}

// 当TableView的Cell的编辑风格为UITableViewCellEditingStyleDelete 或 UITableViewCellEditingStyleInsert时，响应事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    JLCellDataSource *data = [self jl_dataSourceByIndexPath:indexPath];
    // 越界处理
    if (data == nil) {
        return;
    }
    JLCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (self.jl_policy) {
            case JLCellDeletionPolicyRemove:
            {
                NSInteger row = [indexPath row];
                NSInteger section = [indexPath section];
                if (self.jl_editingStyle == JLCellEditingStyleDeletionExplicitWConfirm ||
                    self.jl_editingStyle == JLCellEditingStyleDeletionSwipeWConfirm) {
                }else {
                    // 从DataSource中删除
                    BOOL deleteSection = NO;
                    if (_jl_sectionEnabled) {
                        JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
                        [sectionObject.jl_cellDataSources removeObjectAtIndex:row];
                        if ([sectionObject.jl_cellDataSources count] == 0) {
                            [self.jl_dataSource removeObjectAtIndex:section];
                            deleteSection = YES;
                        }
                    }else {
                        [self.jl_dataSource removeObjectAtIndex:row];
                    }
                    // 删除动画
                    if (deleteSection) {
                        [self.jl_tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:self.jl_rowAnimation];
                    }else {
                        [self.jl_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:self.jl_rowAnimation];
                    }
                }
            }
                break;
            case JLCellDeletionPolicyHidden:
            {
                // 删除(将Cell的可视禁止参数调为YES)
                // 只是标记位设置隐藏
                data.jl_hidden = YES;
                // 重新加载
                [self.jl_tableView reloadData];
            }
                break;
        }
        // 删除代理方法
        if (self.jl_editingStyle == JLCellEditingStyleDeletionExplicitWConfirm ||
            self.jl_editingStyle == JLCellEditingStyleDeletionSwipeWConfirm) {
            self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeDeletedWConfirm, section, row, data, cell, nil, nil);
        }else {
            self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeDeleted, section, row, data, cell, nil, nil);
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // 插入
        self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeInserted, section, row, data, cell, nil, nil);
    }
}

// 返回当前Cell是否可以移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLCellDataSource *cellData = [self jl_dataSourceByIndexPath:indexPath];
    BOOL allowMove = (self.jl_editingStyle == JLCellEditingStyleMove) && (cellData != nil) && cellData.jl_enableMoving;
    return allowMove;
}

// 执行移动操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Cell移动(从哪个位置移动到某个位置)
    if (_jl_sectionEnabled) {
        if ([fromIndexPath section] == [toIndexPath section]) {
            NSInteger fromIndex = [fromIndexPath row];
            NSInteger toIndex = [toIndexPath row];
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:[fromIndexPath section]];
            if (fromIndex != toIndex) {
                if(fromIndex < toIndex) {
                    JLCellDataSource *tempCellDataSource = [sectionObject.jl_cellDataSources objectAtIndex:fromIndex];
                    for (int i = (int)fromIndex; i < toIndex; i++) {
                        sectionObject.jl_cellDataSources[i] = sectionObject.jl_cellDataSources[i+1];
                    }
                    sectionObject.jl_cellDataSources[toIndex] = tempCellDataSource;
                }else {
                    JLCellDataSource *tempCellDataSource = [sectionObject.jl_cellDataSources objectAtIndex:fromIndex];
                    for (int i = (int)fromIndex; i > toIndex; i--) {
                        sectionObject.jl_cellDataSources[i] = sectionObject.jl_cellDataSources[i-1];
                    }
                    sectionObject.jl_cellDataSources[toIndex] = tempCellDataSource;
                }
                JLCellDataSource *fromCellData = [self jl_dataSourceByIndexPath:toIndexPath];
                JLCell *fromCell = [tableView cellForRowAtIndexPath:toIndexPath];
                JLCellDataSource *toCellData = [self jl_dataSourceByIndexPath:fromIndexPath];
                JLCell *toCell = [tableView cellForRowAtIndexPath:fromIndexPath];
                self.jl_moveBlock == nil ? : self.jl_moveBlock(self, fromIndexPath, toIndexPath, fromCellData, fromCell, toCellData, toCell );
            }
        }else {
            JLCellDataSource *fromCellData = [self jl_dataSourceByIndexPath:fromIndexPath];
            JLCellDataSource *toCellData = [self jl_dataSourceByIndexPath:toIndexPath];
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:[toIndexPath section]];
            [sectionObject.jl_cellDataSources jl_tableview_insert:fromCellData at:toCellData append:NO];
            sectionObject = [self.jl_dataSource objectAtIndex:[fromIndexPath section]];
            [sectionObject.jl_cellDataSources removeObjectAtIndex:[fromIndexPath row]];
            fromCellData = [self jl_dataSourceByIndexPath:toIndexPath];
            JLCell *fromCell = [tableView cellForRowAtIndexPath:toIndexPath];
            toCellData = [self jl_dataSourceByIndexPath:fromIndexPath];
            JLCell *toCell = [tableView cellForRowAtIndexPath:fromIndexPath];
            self.jl_moveBlock == nil ? : self.jl_moveBlock(self, fromIndexPath, toIndexPath, fromCellData, fromCell, toCellData, toCell );
        }
    }else {
        NSInteger fromIndex = [fromIndexPath row];
        NSInteger toIndex = [toIndexPath row];
        if (fromIndex != toIndex) {
            if(fromIndex < toIndex) {
                JLCellDataSource *tempCellDataSource = [self.jl_dataSource objectAtIndex:fromIndex];
                for (int i = (int)fromIndex; i < toIndex; i++) {
                    self.jl_dataSource[i] = self.jl_dataSource[i+1];
                }
                self.jl_dataSource[toIndex] = tempCellDataSource;
            }else {
                JLCellDataSource *tempCellDataSource = [self.jl_dataSource objectAtIndex:fromIndex];
                for (int i = (int)fromIndex; i > toIndex; i--) {
                    self.jl_dataSource[i] = self.jl_dataSource[i-1];
                }
                self.jl_dataSource[toIndex] = tempCellDataSource;
            }
            JLCellDataSource *fromCellData = [self.jl_dataSource objectAtIndex:toIndex];
            JLCell *fromCell = [tableView cellForRowAtIndexPath:toIndexPath];
            JLCellDataSource *toCellData = [self.jl_dataSource objectAtIndex:fromIndex];
            JLCell *toCell = [tableView cellForRowAtIndexPath:fromIndexPath];
            self.jl_moveBlock == nil ? : self.jl_moveBlock(self, fromIndexPath, toIndexPath, fromCellData, fromCell, toCellData, toCell );
        }
    }
}

// 处理Cell间的分割线偏移的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] < 0 || [indexPath row] >= [self.jl_dataSource count]) {
        return;
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

// Header View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!_jl_sectionEnabled) {
        return nil;
    }
    JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
    JLTableHeaderFooterViewDataSource *headerFooterData = sectionObject.jl_headerViewDataSource;
    NSString *viewClassName = nil;
    if ([headerFooterData isKindOfClass:[JLTableHeaderFooterViewDataSource class]]) {
        viewClassName = [NSString stringWithUTF8String:object_getClassName(headerFooterData)];
        viewClassName = [viewClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
    }
    JLTableHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewClassName];
    if (view == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(viewClassName)];
        [tableView registerNib:[UINib nibWithNibName:viewClassName bundle:bundle] forHeaderFooterViewReuseIdentifier:viewClassName];
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewClassName];
    }
    [view jl_setData:headerFooterData];
    view.delegate = self;
    return view;
}

// Header View Height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_jl_sectionEnabled) {
        JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
        if (sectionObject.jl_headerViewDataSource == nil) {
            return 0.0;
        }else {
            return sectionObject.jl_headerViewDataSource.jl_height;
        }
    }
    return 0.0f;
}

// Footer View Height
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // This will create a "invisible" footer
    return 0.0f;
}

// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (self.jl_indexesBlock != nil) {
        return self.jl_indexesBlock(self);
    }
    return nil;
}

// tell table which section corresponds to section title/index (e.g. "B",1))
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if (self.jl_indexBlock != nil) {
        return self.jl_indexBlock(self, title, index);
    }
    return 0;
}

/***************************
 *  代理：scrollView滚动事件 *
 ***************************/
#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.jl_scrollBlock == nil) {
        return;
    }
    __jl_endY = scrollView.contentSize.height - scrollView.bounds.size.height;
    // MFLog(@"%f",scrollView.contentOffset.y);
    // 完全交由子类实现
    self.jl_scrollBlock(scrollView, JLScrollBlockTypeScroll, 0, NO);
    CGFloat height = 0.0;
    if (scrollView.contentOffset.y >= __jl_initY && scrollView.contentOffset.y < __jl_endY) {
        // 当大于第一个临界值，并且，小于第二个临界值
        height = scrollView.contentOffset.y - __jl_lastY;
        if (height > 0) {
            // 往下拉
            self.jl_scrollBlock(scrollView, JLScrollBlockTypeMoveDown, height, NO);
        }else if (height < 0) {
            // 往上拉
            self.jl_scrollBlock(scrollView, JLScrollBlockTypeMoveUp, height, NO);
        }
    }else if(scrollView.contentOffset.y < __jl_initY) {
        // 当小于第一临界值（表示开始进入下拉刷新准备状态）
        height = __jl_initY - scrollView.contentOffset.y;
        self.jl_scrollBlock(scrollView, JLScrollBlockTypeRefreshing, height, NO);
        
    }else if (scrollView.contentOffset.y >= __jl_endY) {
        height = scrollView.contentOffset.y - __jl_endY;
        self.jl_scrollBlock(scrollView, JLScrollBlockTypeLoading, height, NO);
    }
    // 最后、记录下本次的contentOffset.y
    __jl_lastY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLScrollBlockTypeDecelerateWillBegin, 0, NO);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLScrollBlockTypeDecelerateDidEnd, 0, decelerate);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLScrollBlockTypeDecelerateWillBegin, 0, NO);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLScrollBlockTypeDecelerateDidEnd, 0, NO);
}

/************************************
 * 代理：Cell和HeaderView的点击事件代理 *
 ************************************/
#pragma mark - JLTableCell Delegate
-(void)jl_tableCellActionRespond:(id)data cell:(id)cell {
    
    if (cell == nil || data == nil) {
        return;
    }
    NSIndexPath *indexPath = [self.jl_tableView indexPathForCell:cell];
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeCustomizedTapped, section, row, data, cell, nil, nil);
}

#pragma mark - JLTableHeaderFooterView Delegate
- (void)jl_tableHeaderFooterViewActionRespond:(id)data view:(id)view {
    
    if (_jl_sectionEnabled == NO) {
        return;
    }
    if (view == nil || data == nil) {
        return;
    }
    for (int section = 0; section < [self.jl_dataSource count]; section++) {
        JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
        id headerFooterData = sectionObject.jl_headerViewDataSource;
        if (headerFooterData == nil) {
            continue;
        }
        if ([data isEqual:headerFooterData]) {
            self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLActionBlockTypeCustomizedTapped, section, -1, nil, nil, data, view);
            break;
        }
    }
}

/************************************
 *          Scroll 动作             *
 ************************************/
#pragma mark - Scroll 动作
// 滚动到某个indexPath
- (void)jl_scrollToIndexPath:(NSIndexPath *)indexPath position:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    
    JLCellDataSource *cellData = [self jl_dataSourceByIndexPath:indexPath];
    // 越界处理
    if (cellData == nil) {
        return;
    }
    [self.jl_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

// 滚动到某个JLCellDataSource
- (void)jl_scrollToCellDataSource:(__kindof JLCellDataSource *)cellDataSource position:(UITableViewScrollPosition)position animated:(BOOL)animated {
    
    if (_jl_sectionEnabled) {
        for (int section = 0; section < [self.jl_dataSource count]; section++) {
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
            for (int row = 0; row < [sectionObject.jl_cellDataSources count]; row++) {
                JLCellDataSource *cellData = [sectionObject.jl_cellDataSources objectAtIndex:row];
                if ([cellData isEqual:cellDataSource]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    [self.jl_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
                    break;
                }
            }
        }
    }else {
        for (int i = 0; i < [self.jl_dataSource count]; i++) {
            JLCellDataSource *cellData = [self.jl_dataSource objectAtIndex:i];
            if ([cellData isEqual:cellDataSource]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.jl_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
                break;
            }
        }
    }
}

// 滚动到第一个CellDataSource的类型
- (void)jl_scrollToTheFirstCellClass:(Class)dataSourceClass position:(UITableViewScrollPosition)position animated:(BOOL)animated {
    for (int i = 0; i < [self.jl_dataSource count]; i++) {
        JLCellDataSource *cellDS = [self.jl_dataSource objectAtIndex:i];
        if ([cellDS isMemberOfClass:dataSourceClass]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.jl_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
            break;
        }
    }
}

/******************************
 *           内部方法          *
 ******************************/
// 计算DataSource中没有disabled的个数
- (int)jl_visibleCellsCount:(NSArray *)cellDataSources {
    
    int cnt = 0;
    for (JLCellDataSource *ds in cellDataSources) {
        if (ds.jl_hidden == NO) {
            cnt++;
        }
    }
    return cnt;
}

// 根据cellData获取实际对应到TableView的Row Index
- (int)jl_visibleIndex:(NSArray *)cellDataSources cellData:(__kindof JLCellDataSource *)cellData {
    
    for (int i = 0, j = -1; i < [cellDataSources count]; i++) {
        JLCellDataSource *ds = [cellDataSources objectAtIndex:i];
        if (ds.jl_hidden == NO) {
            j++;
        }
        if ([ds isEqual:cellData]) {
            return j;
        }
    }
    return NOT_FOUND_INDEX;
}

// 根据cellData的类型获取实际对应到第一个TableView的Row Index
- (int)jl_visibleIndex:(NSArray *)cellDataSources cellClass:(id)cellClass {
    
    for (int i = 0, j = -1; i < [cellDataSources count]; i++) {
        JLCellDataSource *ds = [cellDataSources objectAtIndex:i];
        
        if (ds.jl_hidden == NO) {
            j++;
        }
        
        if ([ds isMemberOfClass:cellClass]) {
            return j;
        }
    }
    return NOT_FOUND_INDEX;
}

// 根据Index获得Cell
- (__kindof JLCell *)jl_cellForRow:(NSInteger)row section:(NSInteger)section {
    
    if (row < 0 || section < 0) {
        return nil;
    }
    return [self.jl_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

// 根据DataSource获得Cell
- (__kindof JLCell *)jl_cellForDataSource:(__kindof JLCellDataSource *)cellDataSource {
    
    if (_jl_sectionEnabled) {
        for (int section = 0 ; section < [self.jl_dataSource count]; section++) {
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
            int row = [self jl_visibleIndex:sectionObject.jl_cellDataSources cellData:cellDataSource];
            if (row != NOT_FOUND_INDEX) {
                return [self jl_cellForRow:row section:section];
            }
        }
    }else {
        int row = [self jl_visibleIndex:self.jl_dataSource cellData:cellDataSource];
        if (row != NOT_FOUND_INDEX) {
            return [self jl_cellForRow:row section:0];
        }
    }
    return nil;
}

// 根据DataSource的类型获得Cell （若存在多个，仅返回第一个cell）
- (__kindof JLCell *)jl_cellForClass:(id)cellClass {
    
    if (_jl_sectionEnabled) {
        for (int section = 0 ; section < [self.jl_dataSource count]; section++) {
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
            int row = [self jl_visibleIndex:sectionObject.jl_cellDataSources cellClass:cellClass];
            if (row != NOT_FOUND_INDEX) {
                return [self jl_cellForRow:row section:section];
            }
        }
    }else {
        int row = [self jl_visibleIndex:self.jl_dataSource cellClass:cellClass];
        if (row != NOT_FOUND_INDEX) {
            return [self jl_cellForRow:row section:0];
        }
    }
    return nil;
}

// 根据DataSource的类型获得Cells
- (NSMutableArray<JLCell> *)jl_cellsForClass:(id)cellClass {
    
    NSMutableArray<JLCell> *ret = nil;
    if (_jl_sectionEnabled) {
        for (int section = 0 ; section < [self.jl_dataSource count]; section++) {
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
            for (int i = 0, j = -1; i < [sectionObject.jl_cellDataSources count]; i++) {
                JLCellDataSource *ds = [sectionObject.jl_cellDataSources objectAtIndex:i];
                if (ds.jl_hidden == NO) {
                    j++;
                }
                if ([ds isMemberOfClass:cellClass]) {
                    if (!ret) {
                        ret = (NSMutableArray<JLCell> *)[[NSMutableArray alloc] init];
                    }
                    id cell = [self jl_cellForRow:j section:section];
                    if (cell) {
                        [ret addObject:cell];
                    }
                }
            }
        }
    }else {
        for (int i = 0, j = -1; i < [self.jl_dataSource count]; i++) {
            JLCellDataSource *ds = [self.jl_dataSource objectAtIndex:i];
            if (ds.jl_hidden == NO) {
                j++;
            }
            
            if ([ds isMemberOfClass:cellClass]) {
                if (!ret) {
                    ret = (NSMutableArray<JLCell> *)[[NSMutableArray alloc] init];
                }
                id cell = [self jl_cellForRow:j section:0];
                if (cell) {
                    [ret addObject:cell];
                }
            }
        }
    }
    return ret;
}

// 根据Index获得DataSource
- (JLCellDataSource *)jl_dataSourceForRow:(NSInteger)row {
    
    return [self.jl_dataSource objectAtIndex:row];
}

// 根据DataSource的类型获得DataSource （若存在多个，仅返回第一个DataSource）
- (JLCellDataSource *)jl_dataSourceForClass:(id)cellClass {
    
    for (int i = 0; i < [self.jl_dataSource count]; i++) {
        JLCellDataSource *ds = [self.jl_dataSource objectAtIndex:i];
        if ([ds isMemberOfClass:cellClass]) {
            return ds;
        }
    }
    return nil;
}

// 根据DataSource的类型获得DataSources
- (NSMutableArray<JLCellDataSource> *)jl_dataSourcesForClass:(id)cellClass {
    
    NSMutableArray<JLCellDataSource> *ret = nil;
    for (int i = 0; i < [self.jl_dataSource count]; i++) {
        JLCellDataSource *ds = [self.jl_dataSource objectAtIndex:i];
        if ([ds isMemberOfClass:cellClass]) {
            if (!ret) {
                ret = (NSMutableArray<JLCellDataSource> *)[[NSMutableArray alloc] init];
            }
            [ret addObject:ds];
        }
    }
    return ret;
}

// 检查indexPath的合法性
- (__kindof JLCellDataSource *)jl_dataSourceByIndexPath:(NSIndexPath *)indexPath {
    
    if (self.jl_dataSource == nil || [self.jl_dataSource count] == 0) {
        return nil;
    }
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (_jl_sectionEnabled) {
        if (section < 0 || section >= [self.jl_dataSource count]) {
            return nil;
        }
        JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
        if (row < 0 || row >= [sectionObject.jl_cellDataSources count]) {
            return nil;
        }
        return [self jl_visibleDataSource:sectionObject.jl_cellDataSources row:row];
    }else {
        if (row < 0 || row >= [self.jl_dataSource count]) {
            return nil;
        }
        return [self jl_visibleDataSource:self.jl_dataSource row:row];
    }
    return nil;
}

// 获取第row个非jl_hidden的Cell
- (__kindof JLCellDataSource *)jl_visibleDataSource:(NSArray *)datas row:(NSInteger)row {
    
    for (int i = 0, j = -1; i < [datas count]; i++) {
        JLCellDataSource *data = [datas objectAtIndex:i];
        if (data.jl_hidden == NO) {
            j++;
        }
        if (row == j) {
            return [datas objectAtIndex:i];
        }
    };
    return nil;
}


// 根据Index重新加载Cell
- (void)jl_reloadCellForRow:(NSInteger)row section:(NSInteger)section {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.jl_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 根据DataSource重新加载Cell
- (void)jl_reloadCellForDataSource:(__kindof JLCellDataSource *)cellDataSource {
    
    if (_jl_sectionEnabled) {
        for (int section = 0; section < [self.jl_dataSource count]; section++) {
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
            int row = [self jl_visibleIndex:sectionObject.jl_cellDataSources cellData:cellDataSource];
            if (row != NOT_FOUND_INDEX) {
                [self jl_reloadCellForRow:row section:section];
                break;
            }
        }
    }else {
        int row = [self jl_visibleIndex:self.jl_dataSource cellData:cellDataSource];
        [self jl_reloadCellForRow:row section:0];
    }
}

// 根据DataSource的类型重新加载所有的Cells
- (void)jl_reloadCellsForClass:(id)cellClass {
    
    NSMutableArray *indexPaths = nil;
    if (_jl_sectionEnabled) {
        for (int section = 0 ; section < [self.jl_dataSource count]; section++) {
            JLSectionObject *sectionObject = [self.jl_dataSource objectAtIndex:section];
            for (int i = 0, j = -1; i < [sectionObject.jl_cellDataSources count]; i++) {
                JLCellDataSource *ds = [sectionObject.jl_cellDataSources objectAtIndex:i];
                if (ds.jl_hidden == NO) {
                    j++;
                }
                if ([ds isMemberOfClass:cellClass]) {
                    if (!indexPaths) {
                        indexPaths = [[NSMutableArray alloc] init];
                    }
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:section];
                    [indexPaths addObject:indexPath];
                }
            }
        }
    }else {
        for (int i = 0, j = -1; i < [self.jl_dataSource count]; i++) {
            JLCellDataSource *ds = [self.jl_dataSource objectAtIndex:i];
            if (ds.jl_hidden == NO) {
                j++;
            }
            if ([ds isMemberOfClass:cellClass]) {
                if (!indexPaths) {
                    indexPaths = [[NSMutableArray alloc] init];
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
                [indexPaths addObject:indexPath];
            }
        }
    }
    [self.jl_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:self.jl_rowAnimation];
}

@end
