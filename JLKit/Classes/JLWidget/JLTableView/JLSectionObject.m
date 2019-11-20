


//
//  JLSectionObject.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLSectionObject.h"

@implementation JLSectionObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jl_cellDataSources = (NSMutableArray<JLCellDataSource> *)[NSMutableArray array];
    }
    return self;
}


@end
