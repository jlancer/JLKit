//
//  JLCityGroupTableViewController.h
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLCityGroup.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLCityGroupSelectBlock)(NSString *cityName);

@interface JLCityGroupTableViewController : UITableViewController

@property(nonatomic, copy) JLCityGroupSelectBlock block;

@end

NS_ASSUME_NONNULL_END
