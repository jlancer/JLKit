//
//  EnvironmentChooseView.m
//  JLKit
//
//  Created by wangjian on 2020/11/24.
//  Copyright © 2020 wangjian. All rights reserved.
//

#import "EnvironmentChooseView.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "UIView+Addition_JL.h"
#import "Macro.h"
#import "APIConfig.h"

@interface EnvironmentChooseView()

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UITextField *urlTextField;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, copy) void(^finishedBlock)(void);

@end

@implementation EnvironmentChooseView

- (void)dealloc {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

+ (void)showOn:(UIView *)superView finished:(void(^)(void))finished {
    
    EnvironmentChooseView *view = MF_LOAD_NIB(@"EnvironmentChooseView");
    view.frame = UIScreen.mainScreen.bounds;
    [superView addSubview:view];
    view.finishedBlock = finished;
    [view _build];
}

- (void)_build {
    
    [self.okButton jl_cornerRadius:6.0];
    [self.closeButton jl_cornerRadius:6.0];
    
    APIEnvironmentType env = [APIConfig getEnviroment];
    self.segmentedControl.selectedSegmentIndex = env;
    self.urlTextField.text = [APIConfig baseURL];
    if (self.segmentedControl.selectedSegmentIndex == APIEnvironmentTypeTest ||
        self.segmentedControl.selectedSegmentIndex == APIEnvironmentTypeProduction) {
        self.urlTextField.userInteractionEnabled = NO;
    }else {
        self.urlTextField.userInteractionEnabled = YES;
    }
    
    MF_WEAK_SELF
    [self.segmentedControl bk_addEventHandler:^(UISegmentedControl *sender) {
        if (sender.selectedSegmentIndex == APIEnvironmentTypeTest ||
            sender.selectedSegmentIndex == APIEnvironmentTypeProduction) {
            weakSelf.urlTextField.userInteractionEnabled = NO;
            weakSelf.urlTextField.text = sender.selectedSegmentIndex == APIEnvironmentTypeTest ? HOST_DEV : HOST_PROD;
        }else {
            weakSelf.urlTextField.userInteractionEnabled = YES;
            weakSelf.urlTextField.text = [APIConfig customizeURL];
        }
    } forControlEvents:UIControlEventValueChanged];
    
    [self.okButton bk_addEventHandler:^(id sender) {
        [APIConfig setEnviroment:(APIEnvironmentType)weakSelf.segmentedControl.selectedSegmentIndex url:weakSelf.urlTextField.text];
        weakSelf.finishedBlock == nil ? : weakSelf.finishedBlock();
        [weakSelf _dismiss];
        exit(0);
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeButton bk_addEventHandler:^(id sender) {
        [weakSelf _dismiss];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)_dismiss {

    MF_WEAK_SELF
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
