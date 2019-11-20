

//
//  JLCollectionView.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLCollectionView.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "NSArray+Addition_JL.h"
#import "JLClCell.h"
#import "JLClView.h"
#import "JLClSectionObject.h"

#define angelToRandian(x)  ( (x) / 180.0 * M_PI)
#define COLOR_F3F3F9       [UIColor colorWithRed:(243.0/255.0) green:(243.0/255.0) blue:(249.0/255.0) alpha:1.0]

@interface JLCollectionView () <CHTCollectionViewDelegateWaterfallLayout, JLClCellDelegate, JLClViewDelegate>

// CollectionView
@property (nonatomic, strong) UICollectionView *jl_collectionView;

// 数据源(设置数据源并刷新CollectionView)
@property (nonatomic, strong) NSMutableArray   *jl_dataSource;

// 是否带Section Header View
@property(nonatomic, assign) BOOL              jl_sectionEnabled;

// UICollectionCell的注册类
@property(nonatomic, strong) NSArray           *_jl_registerCellClasses;

// Sticky
@property (nonatomic, assign) BOOL             _jl_sticky;

// Backgroudn, Frame, Height, Spaceing等属性
@property(nonatomic, assign) UIEdgeInsets      _jl_sectionInsets;

@property(nonatomic, assign) CGFloat           _jl_headerHeight;

@property(nonatomic, assign) CGFloat           _jl_footerHeight;

@property(nonatomic, assign) CGFloat           _jl_minimumLineSpace;

@property(nonatomic, assign) CGFloat           _jl_minimumInteritemSpace;

@end

@implementation JLCollectionView

#pragma mark - JLCollectionView 系统函数
/**************************************************************
 ***********       JLCollectionView 系统函数         ***********
 **************************************************************/
- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self layoutIfNeeded];
}

// 初始化UICollectionView（from code）
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.jl_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height) collectionViewLayout:collectionViewLayout];
        [self initCommon:self.jl_collectionView];
    }
    return self;
}

// 初始化UICollectionView（from xib）
-(id)initWithCoder:(NSCoder *)coder {
    
    if (self = [super initWithCoder:coder]) {
        
        self.jl_collectionView = [[UICollectionView alloc] initWithCoder:coder];
        [self initCommon:self.jl_collectionView];
    }
    return self;
}

- (void)initCommon:(UICollectionView *)collectionView {
    
    // 默认
    self._jl_sectionInsets = UIEdgeInsetsZero;
    self._jl_headerHeight  = 0.0;
    self._jl_footerHeight  = 0.0;
    self._jl_minimumLineSpace = 0.0;
    self._jl_minimumInteritemSpace = 0.0;
    // 设置autoresizingMask
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    // 设置代理
    collectionView.dataSource = (id<UICollectionViewDataSource>)self;
    collectionView.delegate   = (id<UICollectionViewDelegate>)self;
    // 禁止显示滚动条
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    __weak typeof(self) weakSelf = self;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    // 默认分割线贴边
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [collectionView setLayoutMargins:UIEdgeInsetsZero];
    }
    // 默认点击状态栏滚动到顶部
    collectionView.scrollsToTop = YES;
}

- (void)dealloc {
    
    [_jl_dataSource removeAllObjects];
    _jl_collectionView.delegate = nil;
    _jl_collectionView.dataSource = nil;
}

#pragma mark - JLCollectionView 成员方法定义
/**************************************************************
 ***********      JLCollectionView 成员方法定义       ***********
 **************************************************************/
+ (JLCollectionView *)jl_createDefaultCollectionView:(NSArray *)registerClasses waterfallColumns:(NSUInteger)waterfallColumns {
    
    return [JLCollectionView jl_createCollectionView:CGRectZero backgroundColor:nil collectionViewBackgroundColor:COLOR_F3F3F9 sectionInset:UIEdgeInsetsZero minimumLineSpace:0.0 minimumInteritemSpace:0.0 headerHeight:0.0 footerHeight:0.0 registerClasses:registerClasses waterfallColumns:waterfallColumns stickyHeader:NO];
}

// 生成JLCollectionView（自定义UI和ConfigureBlock）
+ (JLCollectionView *)jl_createCollectionView:(CGRect)frame backgroundColor:(UIColor *)backgroundColor collectionViewBackgroundColor:(UIColor *)collectionViewBackgroundColor sectionInset:(UIEdgeInsets)sectionInset minimumLineSpace:(CGFloat)minimumLineSpace minimumInteritemSpace:(CGFloat)minimumInteritemSpace headerHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight registerClasses:(NSArray *)registerClasses waterfallColumns:(NSUInteger)waterfallColumns stickyHeader:(BOOL)stickyHeader {
    
    JLCollectionView *view = nil;
    // 加载UIColloection View
    stickyHeader = NO;
    if (stickyHeader) {
        // Not Support
    }else{
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.columnCount             = waterfallColumns;
        layout.sectionInset            = sectionInset;
        layout.headerHeight            = headerHeight;
        layout.footerHeight            = footerHeight;
        layout.minimumColumnSpacing    = minimumLineSpace;
        layout.minimumInteritemSpacing = minimumInteritemSpace;
        view = [[JLCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    }
    // 保存和设置属性
    view._jl_minimumLineSpace        = minimumLineSpace;
    view._jl_minimumInteritemSpace   = minimumInteritemSpace;
    view._jl_sectionInsets           = sectionInset;
    view._jl_headerHeight            = headerHeight;
    view._jl_footerHeight            = footerHeight;
    view._jl_registerCellClasses     = registerClasses;
    view._jl_sticky                  = stickyHeader;
    // waterfallColumns
    view.jl_waterfallColumns         = waterfallColumns;
    // 设置背景颜色
    if (backgroundColor) {
        view.backgroundColor = backgroundColor;
    }
    if (collectionViewBackgroundColor) {
        view.jl_collectionView.backgroundColor = collectionViewBackgroundColor;
    }
    for (Class class in registerClasses) {
        // 判断是否包含HeaderView或者FooterView
        if ([class isSubclassOfClass:[JLClView class]]) {
            view.jl_sectionEnabled = YES;
        }
        NSString *identifier = NSStringFromClass(class);
        if ([class isSubclassOfClass:[JLClCell class]]) {
            [view.jl_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        }else if([class isSubclassOfClass:[JLClHeaderView class]]) {
            if (view._jl_sticky) {
                [view.jl_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
            }else{
                [view.jl_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:identifier];
            }
        }else if ([class isSubclassOfClass:[JLClFooterView class]]) {
            if (view._jl_sticky) {
                [view.jl_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
            }else{
                [view.jl_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:identifier];
            }
        }
    }
    // 初始化内部变量
    view.jl_dataSource = [NSMutableArray array];
    return view;
}

- (void)setjl_waterfallColumns:(NSUInteger)jl_waterfallColumns {
    
    _jl_waterfallColumns = jl_waterfallColumns;
    if (self.jl_collectionView != nil && self.jl_collectionView.collectionViewLayout != nil && [self.jl_collectionView.collectionViewLayout isKindOfClass:[CHTCollectionViewWaterfallLayout class]]) {
        CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.jl_collectionView.collectionViewLayout;
        layout.columnCount = jl_waterfallColumns;
    }
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
    
    [self jl_refresh:self.jl_waterfallColumns animation:NO dataSource:self.jl_dataSource];
}

// 重新刷新数据源（带参数WaterfallColumns）
- (void)jl_refresh:(NSUInteger)waterfallColumns {
    
    [self jl_refresh:waterfallColumns animation:NO dataSource:self.jl_dataSource];
}

// 重新刷新数据源（带参数WaterfallColumns, Animation）
- (void)jl_refresh:(NSUInteger)waterfallColumns animation:(BOOL)animation {
    
    [self jl_refresh:waterfallColumns animation:animation dataSource:self.jl_dataSource];
}

// 重新刷新数据源（带参数WaterfallColumns, Animation, DataSource）
- (void)jl_refresh:(NSUInteger)waterfallColumns animation:(BOOL)animation dataSource:(NSArray *)dataSource {
    
    NSAssert(waterfallColumns > 0, @"WaterfallColumns MUST be Positive");
    NSAssert(dataSource != nil, @"DataSource Was Not Initialized");
    // WaterfallColumns
    self.jl_waterfallColumns = waterfallColumns;
    // Check DataSource
    if (_jl_dataSource != nil && [_jl_dataSource count] > 0) {
        id object = [_jl_dataSource objectAtIndex:0];
        if([object isKindOfClass:[JLClSectionObject class]]){
            self.jl_sectionEnabled = YES;
        }else{
            self.jl_sectionEnabled = NO;
        }
    }else{
        self.jl_sectionEnabled = NO;
    }
    __weak typeof(self) weakSelf = self;
    // Reload
    if (animation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.jl_collectionView reloadData];
        });
    }else{
        [UIView performWithoutAnimation:^{
            [weakSelf.jl_collectionView reloadData];
        }];
    }
}

// 更新部分参数（sectionInsets，minimumLineSpace和minimumInteritemSpace）
- (void)jl_updateSectionInsets:(UIEdgeInsets)sectionInsets minimumLineSpace:(CGFloat)minimumLineSpace minimumInteritemSpace:(CGFloat)minimumInteritemSpace {
    
    self._jl_sectionInsets         = sectionInsets;
    self._jl_minimumLineSpace      = minimumLineSpace;
    self._jl_minimumInteritemSpace = minimumInteritemSpace;
}

#pragma mark - UICollectionView的代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (_jl_sectionEnabled) {
        return [_jl_dataSource count];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_jl_sectionEnabled) {
        JLClSectionObject *sectionObject = [_jl_dataSource objectAtIndex:section];
        return [sectionObject.jl_cellDataSources count];
    }
    return [_jl_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_jl_dataSource count] == 0) {
        return nil;
    }
    JLClCellDataSource *cellData = nil;
    if (_jl_sectionEnabled) {
        JLClSectionObject *sectionObject = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:[indexPath section]];
        cellData = (sectionObject == nil || sectionObject.jl_cellDataSources == nil || [sectionObject.jl_cellDataSources count] == 0) ? nil : [sectionObject.jl_cellDataSources objectAtIndex:[indexPath row]];
    }else{
        cellData = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:[indexPath row]];
    }
    NSString *cellClassName;
    if ([cellData isKindOfClass:[JLClCellDataSource class]]) {
        cellClassName = [NSString stringWithUTF8String:object_getClassName(cellData)];
        cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
    }
    JLClCell *cell = nil;
    // 异常处理
    @try {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassName forIndexPath:indexPath];
    }
    @catch (NSException *exception) {
        // 注册Cell(第一次注册的时候)
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(cellClassName)];
        [collectionView registerNib:[UINib nibWithNibName:cellClassName bundle:bundle] forCellWithReuseIdentifier:cellClassName];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassName forIndexPath:indexPath];
    }
    cell.jl_delegate = self;
    // jl_setData:必须由子类实现
    [cell jl_setData:cellData];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (!_jl_sectionEnabled) {
        return nil;
    }
    __weak __block JLClView *view = nil;
    JLClSectionObject *sectionObject = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:indexPath.section];
    NSString *identifier = nil;
    if (kind == UICollectionElementKindSectionHeader || kind == CHTCollectionElementKindSectionHeader) {
        if (sectionObject.jl_headerViewDataSource == nil) {
            return nil;
        }
        identifier = NSStringFromClass([sectionObject.jl_headerViewDataSource class]);
        identifier = [identifier stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        // 设置HeaderView的DataSource
        __weak typeof(self) weakSelf = self;
        [view bk_whenTapped:^{
            weakSelf.jl_actionBlock == nil ? : weakSelf.jl_actionBlock(weakSelf, JLClActionBlockTypeTapped, indexPath.section, 0, sectionObject.jl_headerViewDataSource, view);
        }];
        // jl_setData:必须由子类实现
        [view jl_setData:sectionObject.jl_headerViewDataSource];
    } else if (kind == UICollectionElementKindSectionFooter || kind == CHTCollectionElementKindSectionFooter) {
        if (sectionObject.jl_footerViewDataSource == nil) {
            return nil;
        }
        identifier = NSStringFromClass([sectionObject.jl_footerViewDataSource class]);
        identifier = [identifier stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        // jl_setData:必须由子类实现
        [view jl_setData:sectionObject.jl_footerViewDataSource];
    }
    // 设置HeaderFooterView的代理
    view.jl_delegate = self;
    return view;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
    
    if (!_jl_sectionEnabled) {
        return 0.0;
    }
    JLClSectionObject *sectionObject = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:section];
    JLClHeaderViewDataSource *header = sectionObject.jl_headerViewDataSource;
    return header.jl_height;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
    
    if (!_jl_sectionEnabled) {
        return 0.0;
    }
    JLClSectionObject *sectionObject = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:section];
    JLClFooterViewDataSource *footer = sectionObject.jl_footerViewDataSource;
    return footer.jl_height;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_jl_sectionEnabled) {
        JLClSectionObject *sectionObject = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:indexPath.section];
        JLClCellDataSource *cellData = sectionObject.jl_cellDataSources[indexPath.item];
        JLClCell *cell = (JLClCell *)[self.jl_collectionView cellForItemAtIndexPath:indexPath];
        self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLClActionBlockTypeTapped , indexPath.section, indexPath.item, cellData, cell);
    }else{
        JLClCellDataSource *cellData = _jl_dataSource[indexPath.item];
        JLClCell *cell = (JLClCell *)[self.jl_collectionView cellForItemAtIndexPath:indexPath];
        self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLClActionBlockTypeTapped , indexPath.section, indexPath.item, cellData, cell);
    }
}

#pragma mark - UICollectionViewFlowLayout代理
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self._jl_minimumLineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return self._jl_minimumInteritemSpace;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self._jl_sectionInsets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (_jl_sectionEnabled) {
        JLClSectionObject *sectionObject = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:section];
        JLClHeaderViewDataSource *headerDataSource = sectionObject.jl_headerViewDataSource;
        return CGSizeMake(self.bounds.size.width, headerDataSource.jl_height);
    }else{
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (_jl_sectionEnabled) {
        JLClSectionObject *sectionObject = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:section];
        JLClFooterViewDataSource *footerDataSource = sectionObject.jl_footerViewDataSource;
        return CGSizeMake(self.bounds.size.width, footerDataSource.jl_height);
    }else{
        return CGSizeZero;
    }
}

#pragma mark -  CHTCollectionViewWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JLClCellDataSource *data = nil;
    if (_jl_sectionEnabled) {
        JLClSectionObject *sectionData = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:indexPath.section];
        data = (sectionData == nil || sectionData.jl_cellDataSources == nil || [sectionData.jl_cellDataSources count] == 0) ? nil : [sectionData.jl_cellDataSources objectAtIndex:indexPath.row];
    }else{
        data = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:indexPath.row];
    }
    return data.jl_size;
}

#pragma mark - UICollectionViewCell和HeaderFooterView的点击事件代理
- (void)jl_collectionCellActionRespond:(__kindof JLClCellDataSource *)data cell:(__kindof JLClCell *)cell {
    
    NSIndexPath *indexPath = [self.jl_collectionView indexPathForCell:cell];
    self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLClActionBlockTypeCustomizedTapped, [indexPath section], [indexPath item], data, cell);
}

- (void)jl_collectionHeaderFooterViewActionRespond:(__kindof JLClViewDataSource *)data view:(__kindof JLClView *)view {
    
    if (!_jl_sectionEnabled) {
        return;
    }
    BOOL header = [data isKindOfClass:[JLClHeaderViewDataSource class]] ? YES : NO;
    int section = 0;
    for (; section < [_jl_dataSource count]; section++) {
        JLClSectionObject *sectionData = (_jl_dataSource == nil || [_jl_dataSource count] == 0) ? nil : [_jl_dataSource objectAtIndex:section];
        if (header) {
            if ([sectionData.jl_headerViewDataSource isEqual:data]) {
                break;
            }
        }else{
            if ([sectionData.jl_footerViewDataSource isEqual:data]) {
                break;
            }
        }
    }
    self.jl_actionBlock == nil ? : self.jl_actionBlock(self, JLClActionBlockTypeCustomizedTapped, section, 0, data, view);
}

@end

#pragma mark - UICollectionView的Scroll代理
@implementation JLCollectionView (Scroll)

- (void)_setInitY:(CGFloat)y {
    
    objc_setAssociatedObject(self, @"InitY", @(y), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)_getInitY {
    
    return [objc_getAssociatedObject(self, @"InitY") floatValue];
}

- (void)_setLastY:(CGFloat)y {
    
    objc_setAssociatedObject(self, @"LastY", @(y), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)_getLastY {
    
    return [objc_getAssociatedObject(self, @"LastY") floatValue];
}

- (void)_setEndY:(CGFloat)y {
    
    objc_setAssociatedObject(self, @"EndY", @(y), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)_getEndY {
    
    return [objc_getAssociatedObject(self, @"EndY") floatValue];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.jl_scrollBlock == nil) {
        return;
    }
    [self _setEndY:scrollView.contentSize.height - scrollView.bounds.size.height];
    // 完全交由子类实现
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeScroll, 0, NO);
    CGFloat height = 0.0;
    if (scrollView.contentOffset.y >= [self _getInitY] && scrollView.contentOffset.y < [self _getEndY]) {
        // 当大于第一个临界值，并且，小于第二个临界值
        height = scrollView.contentOffset.y - [self _getLastY];
        if (height > 0) {
            // 往下拉
            self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeMoveDown, height, NO);
        }else if (height < 0) {
            // 往上拉
            self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeMoveUp, height, NO);
        }
    }else if(scrollView.contentOffset.y < [self _getInitY]){
        // 当小于第一临界值（表示开始进入下拉刷新准备状态）
        height = [self _getInitY] - scrollView.contentOffset.y;
        self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeRefreshing, height, NO);
        
    }else if (scrollView.contentOffset.y >= [self _getEndY]) {
        height = scrollView.contentOffset.y - [self _getEndY];
        self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeLoading, height, NO);
    }
    // 最后、记录下本次的contentOffset.y
    [self _setLastY:scrollView.contentOffset.y];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeDragWillBegin, 0, NO);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeDragDidEnd, 0, decelerate);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeDecelerateWillBegin, 0, NO);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.jl_scrollBlock == nil ? : self.jl_scrollBlock(scrollView, JLClScrollBlockTypeDecelerateDidEnd, 0, NO);
}

@end


#pragma mark - 移动CollectionViewCell
@implementation JLCollectionView (Move)

static CGPoint lastPoint;

- (void)_setMoveType:(JLClMoveCellType)type {
    
    objc_setAssociatedObject(self, "MoveType", @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JLClMoveCellType)_getMoveType {
    
    return [objc_getAssociatedObject(self, "MoveType") intValue];
}

- (void)_setMoveGesture:(UILongPressGestureRecognizer *)gesture {
    
    objc_setAssociatedObject(self, "MoveGesture", gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILongPressGestureRecognizer *)_getMoveGesture {
    
    return objc_getAssociatedObject(self, "MoveGesture");
}

- (void)_setFromIndexPath:(NSIndexPath *)indexPath {
    
    objc_setAssociatedObject(self, "FromIndexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)_getFromIndexPath {
    
    return objc_getAssociatedObject(self, "FromIndexPath");
}

- (void)_setToIndexPath:(NSIndexPath *)indexPath {
    
    objc_setAssociatedObject(self, "ToIndexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)_getToIndexPath {
    
    return objc_getAssociatedObject(self, "ToIndexPath");
}

- (void)_setTemporary:(UIView *)tmpView {
    
    objc_setAssociatedObject(self, "TempView", tmpView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)_getTemporaryView {
    
    return objc_getAssociatedObject(self, "TempView");
}

// 设置Cell移动交换
- (void)jl_setCollectionCellMovable:(BOOL)movable type:(JLClMoveCellType)type {
    
    [self _setMoveType:type];
    if (movable) {
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongGesture:)];
        [_jl_collectionView addGestureRecognizer:longGesture];
        [self _setMoveGesture:longGesture];
    }else {
        if ([self _getMoveGesture]) {
            [_jl_collectionView removeGestureRecognizer:[self _getMoveGesture]];
        }
    }
}

// 处理长按事件
- (void)_handleLongGesture:(UILongPressGestureRecognizer *)longPressGesture {
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self _longGestureBegan:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        [self _longGestureChange:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateCancelled || longPressGesture.state == UIGestureRecognizerStateEnded){
        [self _longGestureEndOrCancel:longPressGesture];
    }
}

// 手势开始
- (void)_longGestureBegan:(UILongPressGestureRecognizer *)longPressGesture {
    
    //获取手指所在的cell
    NSIndexPath *fromIndexPath = [_jl_collectionView indexPathForItemAtPoint:[longPressGesture locationOfTouch:0 inView:longPressGesture.view]];
    [self _setFromIndexPath:fromIndexPath];
    UICollectionViewCell *cell = [_jl_collectionView cellForItemAtIndexPath:fromIndexPath];
    UIView *tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
    cell.hidden = YES;
    UIView *tempView = tempMoveCell;
    tempView.frame = cell.frame;
    [_jl_collectionView addSubview:tempView];
    [self _setTemporary:tempMoveCell];
    lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    // 开启抖动
    if (_jl_moveShouldShakeBlock != nil) {
        if (_jl_moveShouldShakeBlock() == YES) {
            [self _startShakeAllCollectionViewCells];
        }
    }
}

// 手势拖动
- (void)_longGestureChange:(UILongPressGestureRecognizer *)longPressGesture {
    
    CGFloat tranX = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].x - lastPoint.x;
    CGFloat tranY = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].y - lastPoint.y;
    UIView *tempView = [self _getTemporaryView];
    tempView.center = CGPointApplyAffineTransform(tempView.center, CGAffineTransformMakeTranslation(tranX, tranY));
    lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    [self _moveCell];
}

// 手势取消或者结束
- (void)_longGestureEndOrCancel:(UILongPressGestureRecognizer *)longPressGesture {
    
    UICollectionViewCell *cell = [_jl_collectionView cellForItemAtIndexPath:[self _getFromIndexPath]];
    _jl_collectionView.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    __weak UIView *weakTempView = [self _getTemporaryView];
    [UIView animateWithDuration:0.25 animations:^{
        weakTempView.center = cell.center;
    } completion:^(BOOL finished) {
        [weakSelf _stopShakeAllCollectionViewCells];
        [weakTempView removeFromSuperview];
        cell.hidden = NO;
        weakSelf.jl_collectionView.userInteractionEnabled = YES;
    }];
    self.jl_moveFinishedBlock == nil ? : self.jl_moveFinishedBlock();
}

// Cell 移动 交换
- (void)_moveCell {
    
    for (JLClCell *cell in [self.jl_collectionView visibleCells]) {
        NSIndexPath *fromIndexPath = [self _getFromIndexPath];
        if ([self.jl_collectionView indexPathForCell:cell] == fromIndexPath) {
            continue;
        }
        UIView *tempView = [self _getTemporaryView];
        //计算中心距
        CGFloat spacingX = fabs(tempView.center.x - cell.center.x);
        CGFloat spacingY = fabs(tempView.center.y - cell.center.y);
        if (spacingX <= tempView.bounds.size.width / 2.0f && spacingY <= tempView.bounds.size.height / 2.0f) {
            if (cell.jl_data.jl_disableMovable == YES) {
                break;
            }else{
                NSIndexPath *toIndexPath = [_jl_collectionView indexPathForCell:cell];
                [self _setToIndexPath:toIndexPath];
                //更新数据源
                [self _updateDataSourceAfterMoving];
                //移动
                if ([self _getMoveType] == JLClMoveCellTypeInsert || _jl_sectionEnabled) {
                    [_jl_collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                }else{
                    if (fromIndexPath.item < toIndexPath.item) {
                        [_jl_collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                        [_jl_collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:toIndexPath.item - 1 inSection:0] toIndexPath:fromIndexPath];
                    }else{
                        [_jl_collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                        [_jl_collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:toIndexPath.item + 1 inSection:0] toIndexPath:fromIndexPath];
                    }
                }
                // 设置移动后的起始indexPath
                [self _setFromIndexPath:toIndexPath];
                break;
            }
        }
    }
}

// 更新交换数据源
- (void)_updateDataSourceAfterMoving {
    
    JLClCellDataSource *movedDataSource = nil;
    JLClCellDataSource *originalDataSource = nil;
    NSIndexPath *fromIndexPath = [self _getFromIndexPath];
    NSIndexPath *toIndexPath = [self _getToIndexPath];
    if ([self _getMoveType] == JLClMoveCellTypeInsert || _jl_sectionEnabled) {
        if (_jl_sectionEnabled) { // 多section
            //取出源item数据
            JLClSectionObject *fromSectionObject = [_jl_dataSource objectAtIndex:fromIndexPath.section];
            movedDataSource = [fromSectionObject.jl_cellDataSources objectAtIndex:fromIndexPath.item];
            //从资源数组中移除该数据
            [fromSectionObject.jl_cellDataSources removeObject:movedDataSource];
            //将数据插入到资源数组中的目标位置上
            JLClSectionObject *toSectionObject = [_jl_dataSource objectAtIndex:toIndexPath.section];
            [toSectionObject.jl_cellDataSources insertObject:movedDataSource atIndex:toIndexPath.item];
        }else {
            //取出源item数据
            movedDataSource = [_jl_dataSource objectAtIndex:fromIndexPath.item];
            //从资源数组中移除该数据
            [_jl_dataSource removeObject:movedDataSource];
            //将数据插入到资源数组中的目标位置上
            [_jl_dataSource insertObject:movedDataSource atIndex:toIndexPath.item];
        }
    }else{
        if (_jl_sectionEnabled) { // 多section
            //取出源item数据
            JLClSectionObject *fromSectionObject = [_jl_dataSource objectAtIndex:toIndexPath.section];
            movedDataSource = [fromSectionObject.jl_cellDataSources objectAtIndex:toIndexPath.item];
            JLClSectionObject *toSectionObject = [_jl_dataSource objectAtIndex:fromIndexPath.section];
            originalDataSource = [toSectionObject.jl_cellDataSources objectAtIndex:fromIndexPath.item];
            //交换
            [fromSectionObject.jl_cellDataSources replaceObjectAtIndex:toIndexPath.item withObject:originalDataSource];
            [toSectionObject.jl_cellDataSources replaceObjectAtIndex:fromIndexPath.item withObject:movedDataSource];
        }else {
            //取出源item数据
            movedDataSource = [_jl_dataSource objectAtIndex:toIndexPath.item];
            originalDataSource = [_jl_dataSource objectAtIndex:fromIndexPath.item];
            //交换
            [_jl_dataSource replaceObjectAtIndex:toIndexPath.item withObject:originalDataSource];
            [_jl_dataSource replaceObjectAtIndex:fromIndexPath.item withObject:movedDataSource];
        }
    }
    self.jl_moveBlock == nil ? : self.jl_moveBlock(self, fromIndexPath, toIndexPath, nil, nil, movedDataSource, nil);
}

// 开始Cell抖动
- (void)_startShakeAllCollectionViewCells {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angelToRandian(-1.0)),@(angelToRandian(1.0)),@(angelToRandian(-1.0))];
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.2;
    NSArray *cells = [_jl_collectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        /**如果加了shake动画就不用再加了*/
        if (![cell.layer animationForKey:@"shake"]) {
            [cell.layer addAnimation:anim forKey:@"shake"];
        }
    }
    UIView *tempView = [self _getTemporaryView];
    if (![tempView.layer animationForKey:@"shake"]) {
        [tempView.layer addAnimation:anim forKey:@"shake"];
    }
}

// 停止Cell抖动
- (void)_stopShakeAllCollectionViewCells {
    
    NSArray *cells = [_jl_collectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        [cell.layer removeAllAnimations];
    }
    UIView *tempView = [self _getTemporaryView];
    [tempView.layer removeAllAnimations];
}

@end
