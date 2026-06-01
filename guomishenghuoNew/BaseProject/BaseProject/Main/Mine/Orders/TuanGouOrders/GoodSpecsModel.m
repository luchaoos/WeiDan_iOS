//
//  GoodSpecsModel.m
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GoodSpecsModel.h"

@implementation GoodSpecsModel

-(NSMutableArray<NSString *> *)specsSpecs
{
    if (_specsSpecs == nil) {
        _specsSpecs = [NSMutableArray array];
    }
    
    return _specsSpecs;
}

@end
