
//
//  UIViewController+Addition_JL.m
//  JLKit
//
//  Created by wangjian on 2019/11/4.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "UIViewController+Addition_JL.h"
#import <objc/runtime.h>

#pragma mark - JLAlertModel

@implementation JLAlertModel

+ (JLAlertModel *)alertModelDefaultOK:(void(^)(void))action {
    
    JLAlertModel *model = [[JLAlertModel alloc] init];
    model.title = @"确定";
    model.style = UIAlertActionStyleDefault;
    model.action = [action copy];
    return model;
}

+ (JLAlertModel *)alertModelDefaultCancel:(void(^)(void))action {
    
    JLAlertModel *model = [[JLAlertModel alloc] init];
    model.title = @"取消";
    model.style = UIAlertActionStyleDefault;
    model.action = [action copy];
    return model;
}

+ (JLAlertModel *)alertModel:(NSString *)title action:(void(^)(void))action {
    
    JLAlertModel *model = [[JLAlertModel alloc] init];
    model.title = title;
    model.style = UIAlertActionStyleDefault;
    model.action = [action copy];
    return model;
}

+ (JLAlertModel *)alertModel:(NSString *)title style:(UIAlertActionStyle)style action:(void(^)(void))action {
    
    JLAlertModel *model = [[JLAlertModel alloc] init];
    model.title = title;
    model.style = style;
    model.action = [action copy];
    return model;
}

+ (JLAlertModel *)alertModel:(NSString *)title style:(UIAlertActionStyle)style action:(void(^)(void))action color:(UIColor *)color {
    
    JLAlertModel *model = [[JLAlertModel alloc] init];
    model.title = title;
    model.style = style;
    model.action = [action copy];
    model.color = color;
    return model;
}

@end

#pragma mark - Utility_Alert_JL

@implementation UIViewController (Addition_JL)

// 弹出AlertView(Warning)
-(void)jl_alertView:(NSString *)title message:(NSString *)message {
    
    JLAlertModel *okAlertModel = [JLAlertModel alertModelDefaultOK:NULL];
    [self jl_alertView:title message:message cancel:NO cancelColor:nil item:okAlertModel, nil];
}

// 弹出AlertView(Title,Message,Cancel,可变参数)
-(void)jl_alertView:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self jl_commonAlert:title message:message items:items cancel:cancel cancelColor:nil alertStyle:UIAlertControllerStyleAlert];
}

// 弹出AlertView(Title,Message,Cancel,Cancel颜色,可变参数)
-(void)jl_alertView:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self jl_commonAlert:title message:message items:items cancel:cancel cancelColor:cancelColor alertStyle:UIAlertControllerStyleAlert];
}

// 弹出ActionSheet(Title,Message,Cancel,可变参数)
-(void)jl_alertSheet:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self jl_commonAlert:title message:message items:items cancel:cancel cancelColor:nil alertStyle:UIAlertControllerStyleActionSheet];
}

// 弹出ActionSheet(Title,Message,Cancel,Cancel颜色,可变参数)
-(void)jl_alertSheet:(NSString *)title message:(NSString *)message cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor item:(JLAlertModel *)item,...NS_REQUIRES_NIL_TERMINATION {
    
    // 多参数处理
    NSMutableArray *items = [NSMutableArray array];
    va_list argList;
    if(item){
        [items addObject:item];
        va_start(argList, item);
        id arg;
        while ((arg = va_arg(argList, id))) {
            [items addObject:arg];
        }
    }
    va_end(argList);
    // 弹窗
    [self jl_commonAlert:title message:message items:items cancel:cancel cancelColor:cancelColor alertStyle:UIAlertControllerStyleActionSheet];
}

// (弹窗,AlertView + ActionSheet)
- (void)jl_commonAlert:(NSString *)title message:(NSString *)message items:(NSMutableArray *)items cancel:(BOOL)cancel cancelColor:(UIColor *)cancelColor alertStyle:(UIAlertControllerStyle)alertStyle {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    for (JLAlertModel *item in items) {
        if (item.title.length != 0) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item.title style:item.style handler:^(UIAlertAction * _Nonnull action) {
                item.action == nil ? : item.action();
            }];
            if (item.color != nil && [[UIDevice currentDevice].systemVersion floatValue] >= 8.2) {
                [alertAction setValue:item.color forKey:@"_titleTextColor"];
            }
            [alertController addAction:alertAction];
        }
    }
    if (cancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        if (cancelColor != nil && [[UIDevice currentDevice].systemVersion floatValue] >= 8.2) {
            [cancelAction setValue:cancelColor forKey:@"_titleTextColor"];
        }
        [alertController addAction:cancelAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
