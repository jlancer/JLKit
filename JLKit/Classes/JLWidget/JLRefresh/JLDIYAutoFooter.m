
//
//  JLDIYAutoFooter.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLDIYAutoFooter.h"

@interface JLDIYAutoFooter()

@property (nonatomic, weak) UILabel *labelNoMoreData;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@end

@implementation JLDIYAutoFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 80;
    
    // 添加label
    UILabel *labelNoMoreData = [[UILabel alloc] init];
    labelNoMoreData.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    labelNoMoreData.font = [UIFont systemFontOfSize:14];
    labelNoMoreData.textAlignment = NSTextAlignmentCenter;
    labelNoMoreData.text = @"——    别扯了，到底啦    ——";
    [self addSubview:labelNoMoreData];
    self.labelNoMoreData = labelNoMoreData;
    
    // LoadingView
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loadingView];
    self.loadingView = loadingView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.labelNoMoreData.frame = self.bounds;
    self.loadingView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.labelNoMoreData.hidden = YES;
            [self.loadingView stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.labelNoMoreData.hidden = YES;
            [self.loadingView startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.labelNoMoreData.hidden = NO;
            [self.loadingView stopAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


@end
