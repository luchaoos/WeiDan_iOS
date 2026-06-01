//
//  GuigeModel.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/5/24.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "GuigeModel.h"

@implementation GuigeModel


+(instancetype)GuigeModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        @try {
            self.guigeName = dict[@"Name"];
            self.guigeId = [dict[@"Id"] stringValue];
            self.guigeStorNum = dict[@"StockNum"];
            self.guigePrice = dict[@"Price"];
            self.guigePicketNum  = dict[@"LunchboxNum"];
            self.guigePicketPrice = dict[@"LunchBoxFee"];
        }
        @catch (NSException *exception) {
            return self;
        }
        @finally {
            
        }
    }
    
    return self;
}


-(void)setGuigePrice:(NSString *)guigePrice
{
    _guigePrice = ZY_NSStringFromFormat(@"%@",guigePrice);
}


-(void)setGuigeStorNum:(NSString *)guigeStorNum
{
    _guigeStorNum = ZY_NSStringFromFormat(@"%@",guigeStorNum);
}

-(void)setGuigePicketNum:(NSString *)guigePicketNum
{
    _guigePicketNum = ZY_NSStringFromFormat(@"%@",guigePicketNum);
}

-(void)setGuigePicketPrice:(NSString *)guigePicketPrice
{
    _guigePicketPrice = ZY_NSStringFromFormat(@"%@",guigePicketPrice);
}

@end
