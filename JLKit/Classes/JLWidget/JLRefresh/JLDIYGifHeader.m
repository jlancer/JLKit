//
//  JLDIYGifHeader.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <SDWebImage/UIImage+GIF.h>
#import "JLDIYGifHeader.h"
#import "JLStorage.h"
#import "CALayer+Addition_JL.h"

@interface JLDIYGifHeader()

@property (nonatomic, weak) UIImageView *idleView;
@property (nonatomic, weak) UIImageView *loadingGifView;
@property (nonatomic, weak) UILabel *labelState;

@end

@implementation JLDIYGifHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 80;
    
    UIImageView *idleView = [[UIImageView alloc] initWithImage:[JLStorage podImage:@"diyloading_circle" class:[self class]]];
    idleView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:idleView];
    self.idleView = idleView;
    
    UIImageView *loadingGifView = [[UIImageView alloc] init];
    idleView.contentMode = UIViewContentModeScaleAspectFit;
    NSBundle *bundle = [JLStorage podBundle:[self class]];
    NSString *path = [bundle pathForResource:@"diyloading_circle" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    loadingGifView.image = [UIImage sd_imageWithGIFData:imageData];
    loadingGifView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:loadingGifView];
    self.loadingGifView = loadingGifView;
    
    UILabel *labelState = [[UILabel alloc] init];
    labelState.font = [UIFont systemFontOfSize:12.0];
    labelState.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    labelState.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelState];
    self.labelState = labelState;

}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.idleView.frame = CGRectMake(0, 10.0, self.mj_w, self.mj_h - 40.0);
    self.loadingGifView.frame = CGRectMake(0, 10.0, self.mj_w, self.mj_h - 40.0);
    self.labelState.frame = CGRectMake(0, self.mj_h - 20.0, self.mj_w, 10.0);
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
            self.idleView.hidden = NO;
            self.loadingGifView.hidden = YES;
            self.labelState.text = @"下拉刷新";
        }
            break;
        case MJRefreshStatePulling:
            self.idleView.hidden = NO;
            self.loadingGifView.hidden = YES;
            self.labelState.text = @"松手开始刷新";
            break;
        case MJRefreshStateRefreshing:
            self.idleView.hidden = YES;
            self.loadingGifView.hidden = NO;
            self.labelState.text = @"正在刷新...";
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
