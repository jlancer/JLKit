//
//  EnvironmentChooseView.h
//  JLKit
//
//  Created by wangjian on 2020/11/24.
//  Copyright © 2020 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnvironmentChooseView : UIView

+ (void)showOn:(UIView *)superView finished:(void(^)(void))finished;

@end

NS_ASSUME_NONNULL_END
