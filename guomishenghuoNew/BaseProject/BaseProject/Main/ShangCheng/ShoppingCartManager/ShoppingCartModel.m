//
//  ShoppingCartModel.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/19.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel

+(instancetype)ShoppingCartWithDict:(NSDictionary *)dict
{

    return [[self alloc] initWithDict:dict];

}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        @try {
            self.ShoppingCartGoodName = [Toolkit judgeIsNull:dict[@"ProductName"]];
            self.ShoppingCartGoodId = [Toolkit judgeIsNull:dict[@"Id"]];
            self.ShoppingCartGoodPrice = [Toolkit judgeIsNull:dict[@"ProductPrice"]];
            
            self.ShoppingCartGuigeName = [Toolkit judgeIsNull:dict[@"ProductPriceName"]];
            self.ShoppingCartGuigeId = [Toolkit judgeIsNull:dict[@"ProductPriceId"]];
            self.ShoppingCartBuyNum = [Toolkit judgeIsNull:dict[@"ProductNum"]];
            
//            self.ShoppingCartPacketNum = dict[@"ProductName"];
//            self.ShoppingCartPacketPrice = dict[@"ProductName"];

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    return self;
}

+(instancetype)ShoppingCartWithGoodModel:(GoodsModel *)goodModel andGuigeModel:(GuigeModel *)guigeModel andBuyNum:(NSString *)num
{
    return [[self alloc] initWithGoodModel:goodModel andGuigeModel:guigeModel andBuyNum:num];
}

-(instancetype)initWithGoodModel:(GoodsModel *)goodModel andGuigeModel:(GuigeModel *)guigeModel andBuyNum:(NSString *)num
{
    if (self = [super init]) {
        self.ShoppingCartGoodName = goodModel.goodName;
        self.ShoppingCartGoodId = goodModel.goodId;
        self.ShoppingCartGoodPrice = guigeModel.guigePrice;
        
        self.ShoppingCartGuigeName = guigeModel.guigeName;
        self.ShoppingCartGuigeId = guigeModel.guigeId;
        self.ShoppingCartBuyNum = num;
        
        self.ShoppingCartPacketNum = guigeModel.guigePicketNum;
        self.ShoppingCartPacketPrice = guigeModel.guigePicketPrice;
        
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.ShoppingCartGoodName = [[coder decodeObjectForKey:@"ShoppingCartGoodName"] copy];
        self.ShoppingCartGoodId = [[coder decodeObjectForKey:@"ShoppingCartGoodId"] copy];
        self.ShoppingCartGoodPrice = [[coder decodeObjectForKey:@"ShoppingCartGoodPrice"] copy];
        
        self.ShoppingCartGuigeName = [[coder decodeObjectForKey:@"ShoppingCartGuigeName"] copy];
        self.ShoppingCartGuigeId = [[coder decodeObjectForKey:@"ShoppingCartGuigeId"] copy];
        self.ShoppingCartBuyNum = [[coder decodeObjectForKey:@"ShoppingCartBuyNum"] copy];
        
        self.ShoppingCartPacketNum = [[coder decodeObjectForKey:@"ShoppingCartPacketNum"] copy];
        self.ShoppingCartPacketPrice = [[coder decodeObjectForKey:@"ShoppingCartPacketNum"] copy];
    }
    
    return self;
    
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.ShoppingCartGoodName forKey:@"ShoppingCartGoodName"];
    [coder encodeObject:self.ShoppingCartGoodId forKey:@"ShoppingCartGoodId"];
    [coder encodeObject:self.ShoppingCartGoodPrice forKey:@"ShoppingCartGoodPrice"];
    
    [coder encodeObject:self.ShoppingCartGuigeName forKey:@"ShoppingCartGuigeName"];
    [coder encodeObject:self.ShoppingCartGuigeId forKey:@"ShoppingCartGuigeId"];
    [coder encodeObject:self.ShoppingCartBuyNum forKey:@"ShoppingCartBuyNum"];
    
    [coder encodeObject:self.ShoppingCartPacketNum forKey:@"ShoppingCartPacketNum"];
    [coder encodeObject:self.ShoppingCartPacketPrice forKey:@"ShoppingCartPacketPrice"];
}


-(NSDictionary *)transToBill
{
    @try {
        
        NSMutableDictionary *billDict = [NSMutableDictionary dictionary];
        [billDict setObject:self.ShoppingCartGoodId forKey:@"ProductId"];
        [billDict setObject:self.ShoppingCartGoodName forKey:@"ProductName"];
        [billDict setObject:self.ShoppingCartGoodPrice forKey:@"ProductPrice"];
//        
        [billDict setObject:self.ShoppingCartGuigeId?self.ShoppingCartGuigeId:@"0" forKey:@"ProductPriceId"];
        [billDict setObject:self.ShoppingCartGuigeName?self.ShoppingCartGuigeName:@"" forKey:@"ProductPriceName"];
        [billDict setObject:self.ShoppingCartBuyNum forKey:@"ProductNum"];
//        [billDict setObject:@"1" forKey:@"shopid"];
//
//        [billDict setObject:self.ShoppingCartPacketNum forKey:@"LunchboxNum"];
//        [billDict setObject:self.ShoppingCartPacketPrice forKey:@"LunchBoxFee"];
        
        return billDict;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
}



@end
