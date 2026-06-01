//
//  ShoppingCartManager.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/19.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPDefaultManager.h"
#import "ShoppingCartModel.h"

@interface ShoppingCartManager : NSObject
//添加商品到购物车
+(void)AddGood:(ShoppingCartModel *)model;
//获取购物车列表
+(NSArray *)GetShoppingCart;
//清空购物车
+(void)clearShoppingCart;
//减商品
+(void)reduceGoodNumWithGoodId:(NSString *)goodId andGuigeId:(NSString*)guigeId;
//加商品
+(void)plusGoodNumWithGoodId:(NSString *)goodId andGuigeId:(NSString*)guigeId;
//获取购物车所有商品价格
+(CGFloat)getShoppingCartTotalPrice;

@end
