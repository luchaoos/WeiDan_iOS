//
//  GoodsModel.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/5/20.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel


+(instancetype)GoodModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        @try {
            
            self.goodId = [dict[@"Id"] stringValue];
            self.goodName = dict[@"Name"];
            self.goodPrice = [dict[@"Price"] stringValue];
            self.goodImgUrl = dict[@"ImagePath"];
            self.goodDescripe = [Toolkit judgeIsNull:dict[@"Content"]];
            self.goodSaleNum = [dict[@"SaleNum"] stringValue];
            self.goodStar=[dict[@"AvgScore"] stringValue];
            self.goodStorNum = [Toolkit judgeIsNull:dict[@"StockNum"]] ;
        }
        @catch (NSException *exception) {
            return self;
        }
        @finally {
            
        }
        
    }
    
    return self;
}



-(NSDictionary *)BuildProductDictForUpload
{
    
    @try {
        
        NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
        [productDict setObject:self.goodName forKey:@"name"];
        [productDict setObject:self.goodCate.cateId forKey:@"categoryId"];
        [productDict setObject:self.goodDescripe forKey:@"content"];
        [productDict setObject:self.goodImgUrl forKey:@"imagePath"];
        [productDict setObject:self.goodMinByNum forKey:@"minPrice"];
        [productDict setObject:self.goodGuigeModel[0].guigePrice forKey:@"price"];
        if(self.goodId !=nil && self.goodId.length >0)
        {
            [productDict setObject:self.goodId forKey:@"id"];
        }
        
        return productDict;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
    
}


-(NSDictionary *)buildGuigeDictForUploadWith:(GuigeModel *)guigeModel
{
    
    @try {
        
        NSMutableDictionary *guigeDict = [NSMutableDictionary dictionary];
        [guigeDict setObject:guigeModel.guigeName forKey:@"name"];
        [guigeDict setObject:guigeModel.guigePrice forKey:@"price"];
        [guigeDict setObject:guigeModel.guigeStorNum forKey:@"stockNum"];
        [guigeDict setObject:guigeModel.guigePicketPrice forKey:@"lunchBoxFee"];
        [guigeDict setObject:guigeModel.guigePicketNum forKey:@"lunchboxNum"];
        
        return guigeDict;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
}


-(NSArray *)buildGuigeArrForUpload
{
    NSMutableArray *guigeArr = [NSMutableArray array];
    
    for (GuigeModel *guigeModel in self.goodGuigeModel) {
        NSDictionary *tempDict = [self buildGuigeDictForUploadWith:guigeModel];
        if (tempDict == nil) {
            continue;
        }
        [guigeArr addObject:tempDict];
    }
    
    return guigeArr;
}

@end
