//
//  GoodDetailModel.m
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GoodDetailModel.h"

@implementation GoodDetailModel


+(instancetype)GoodDetailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        @try {
            
            self.goodID = ZY_NSStringFromFormat(@"%@",Zy_JudgeObjIsNull(@"Id"));
            self.goodName = Zy_JudgeObjIsNull(@"ProductName");
            self.goodCount = Zy_JudgeObjIsNull(@"ProductNum");
            self.goodPrice = ZY_NSStringFromFormat(@"%@",Zy_JudgeObjIsNull(@"ProductPrice"));
            self.goodImgUrl = ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,Zy_JudgeObjIsNull(@"ProductImage"));
            
            GoodSpecsModel *specs1 = [[GoodSpecsModel alloc] init];
//            specs1.specsName = Zy_JudgeObjIsNull(@"ProductPriceName");
            specs1.specsSelected = Zy_JudgeObjIsNull(@"ProductPriceName");
            self.goodSpecs = @[specs1];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            return self;
        }
    }
    
    return self;
}

@end
