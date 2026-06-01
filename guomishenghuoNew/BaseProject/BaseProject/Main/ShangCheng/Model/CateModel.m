//
//  CateModel.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/5/21.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "CateModel.h"

@implementation CateModel

+(instancetype)CateModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        @try {
            
            if (dict != nil) {
                self.cateDescirpe = dict[@"Description"];
                
                if(self.cateDescirpe == nil || self.cateDescirpe.length == 0)
                {
                    self.cateDescirpe = @"无描述";
                }
                
                self.cateName = dict[@"Name"];
                self.cateId = dict[@"Id"];
                self.cateCode = dict[@"Code"];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    return self;
}

@end
