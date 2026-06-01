//
//  ShoppingCartModel.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/19.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

@interface ShoppingCartModel : NSObject
@property(nonatomic) NSString *ShoppingCartGoodName;
@property(nonatomic) NSString *ShoppingCartGoodId;
@property(nonatomic) NSString *ShoppingCartGoodPrice;
@property(nonatomic) NSString *ShoppingCartGuigeName;
@property(nonatomic) NSString *ShoppingCartGuigeId;
@property(nonatomic) NSString *ShoppingCartBuyNum;
@property(nonatomic) NSString *ShoppingCartPacketNum;
@property(nonatomic) NSString *ShoppingCartPacketPrice;


+(instancetype)ShoppingCartWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)ShoppingCartWithGoodModel:(GoodsModel *)goodModel andGuigeModel:(GuigeModel *)guigeModel andBuyNum:(NSString *)num;
-(instancetype)initWithGoodModel:(GoodsModel *)goodModel andGuigeModel:(GuigeModel *)guigeModel andBuyNum:(NSString *)num;
//转化为bill格式用于上传服务器
-(NSDictionary *)transToBill;
@end
