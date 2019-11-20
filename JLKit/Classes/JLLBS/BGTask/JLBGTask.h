//
//  JLBGTask.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLBGTask : NSObject

+ (JLBGTask *)shared;

// 开启后台任务
- (UIBackgroundTaskIdentifier)beginNewBackgroundTask;

@end

NS_ASSUME_NONNULL_END
