//
//  UIViewController+Addition_JL.h
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JLAlertModel

@interface JLAlertModel : NSObject

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   void(^action)(void);
@property (nonatomic, assign) UIAlertActionStyle style;
@property (nonatomic, strong) UIColor *color;

// JLAlertModel构造方法
+ (JLAlertModel *)alertModelDefaultOK:(void(^)(void))action;

+ (JLAlertModel *)alertModelDefaultCancel:(void(^)(void))action;

+ (JLAlertModel *)alertModel:(NSString *)title action:(void(^)(void))action;

+ (JLAlertModel *)alertModel:(NSString *)title style:(UIAlertActionStyle)style action:(void(^)(void))action;

+ (JLAlertModel *)alertModel:(NSString *)title style:(UIAlertActionStyle)style action:(void(^)(void))action color:(UIColor *)color;

@end

@protocol JLAlertModel <NSObject>

@end

#pragma mark - Utility_Alert_JL

@interface UIViewController (Addition_JL)

// 弹出AlertView(Warning)
-(void)jl_alertView:(NSString *)title message:(NSString *)message;

// 弹出AlertView(Title,Message,Cancel,可变参数)
-(void)jl_alertView:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

// 弹出AlertView(Title,Message,Cancel,Cancel颜色,可变参数)
-(void)jl_alertView:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

// 弹出ActionSheet(Title,Message,Cancel,可变参数)
-(void)jl_alertSheet:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

// 弹出ActionSheet(Title,Message,Cancel,Cancel颜色,可变参数)
-(void)jl_alertSheet:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION;

// (弹窗,AlertView + ActionSheet)
- (void)jl_commonAlert:(NSString *)title message:(NSString *)message items:(NSMutableArray *)items cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor alertStyle:(UIAlertControllerStyle)alertStyle;

@end

NS_ASSUME_NONNULL_END
