//
//  ShoppingModel.m
//  TDS
//
//  Created by 黎金 on 16/3/24.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "ShoppingModel.h"


@implementation ShoppingModel

@synthesize headClickState;

@synthesize headPriceDict;

-(instancetype)initWithShopDict:(NSDictionary *)dict{
    
    self.headID = [dict[@"Shop"] firstObject][@"Id"];
    
    self.headState = 0;
    
    self.discount  = @"1";
    
    self.headName=[dict[@"Shop"] firstObject][@"Name"];
    
    self.headCellArray = [NSMutableArray arrayWithArray:[self ReturnData:dict[@"BillDetailList"]]];
    
    self.headClickState = 0;
    
    self.headPriceDict = [[NSDictionary alloc] init];
    self.headPriceDict = @{
                           @"headTitle":[NSString stringWithFormat:@"选择必选单品,即可享受%@折优惠",self.discount],
                           @"footerTitle":@"小计:¥0.00",
                           @"footerMinus":@""
                           };
    
    return self ;
}

-(NSArray *)ReturnData:(NSArray *)array{
    
    NSMutableArray *arrays= [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        
        ShoppingCellModel *model = [[ShoppingCellModel alloc] initWithShopDict:dict];
        [arrays addObject:model];

    }

    return arrays;
}


@end

@implementation ShoppingCellModel

@synthesize row;
@synthesize section;
@synthesize indexState;
@synthesize cellClickState;
@synthesize cellPriceDict;
@synthesize cellEditState;
-(instancetype)initWithShopDict:(NSDictionary *)dict{
    
    self.ID = dict[@"Id"];
    self.imageUrl = ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,dict[@"ProductImage"]);
    self.title = dict[@"ProductName"];
    self.color = dict[@"ProductPriceName"];
    self.size = @"";
    self.price =dict[@"ProductPrice"];
    self.mustInteger = 0;
    self.numInt = [dict[@"ProductNum"] integerValue];
    self.inventoryInt = 0;
    self.discountNum = @"1";
    self.row = 0;
    self.section = 0;
    self.indexState = 0;
    self.cellClickState = 0;
    self.cellEditState = 0;
    self.cellPriceDict = [[NSDictionary alloc] init];
    return self ;
}

@end