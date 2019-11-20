

//
//  JLDIYHeader.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLDIYHeader.h"
#import "JLStorage.h"
#import "CALayer+Addition_JL.h"

@interface JLDIYHeader()

@property (nonatomic, weak) UIImageView *arrowImageView;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@end

@implementation JLDIYHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 80;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[JLStorage podImage:@"ic_diy_arrow" class:[self class]]];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    // 背景图
    /*
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    */
    
    // loading
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loadingView];
    self.loadingView = loadingView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.arrowImageView.frame = CGRectMake(0, 0, 20.0, 20.0);
    self.arrowImageView.center = CGPointMake(self.mj_w * 0.5 , self.mj_h * 0.5);
    self.loadingView.center = CGPointMake(self.mj_w * 0.5 , self.mj_h * 0.5);
    self.backgroundImageView.frame = self.bounds;
    
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
        {
            self.arrowImageView.hidden = NO;
            self.loadingView.hidden = YES;
            [self.arrowImageView.layer removeAllAnimations];
            [self.loadingView stopAnimating];
        }
            break;
        case MJRefreshStatePulling:
            self.arrowImageView.hidden = NO;
            self.loadingView.hidden = YES;
            [self.loadingView stopAnimating];
            [self.arrowImageView.layer jl_animatedRotate:0.2 fromValue:0 toValue:M_PI times:1 removedOnCompletion:NO];
            break;
        case MJRefreshStateRefreshing:
            self.arrowImageView.hidden = YES;
            self.loadingView.hidden = NO;
            [self.loadingView startAnimating];
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
