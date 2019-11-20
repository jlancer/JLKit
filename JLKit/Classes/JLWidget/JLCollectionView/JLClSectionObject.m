
//
//  JLClSectionObject.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLClSectionObject.h"

@implementation JLClSectionObject

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.jl_cellDataSources = (NSMutableArray<JLClCellDataSource> *)[[NSMutableArray alloc] init];
    }
    return self;
}

@end
