//
//  ShoppingCartManager.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/19.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "ShoppingCartManager.h"

@implementation ShoppingCartManager

+(CGFloat)getShoppingCartTotalPrice
{
    //使用NSDecimalNumber保证计算的准确性
    NSDecimalNumber *totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];;
    NSArray *cartArr = [ShoppingCartManager GetShoppingCart];
    for (ShoppingCartModel *model in cartArr) {
        
        NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:model.ShoppingCartGoodPrice];
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:model.ShoppingCartBuyNum];
        
        NSDecimalNumber *total = [price decimalNumberByMultiplyingBy:num];
        totalPrice=[totalPrice decimalNumberByAdding:total];
    }
    
    return totalPrice.doubleValue;
}


+(NSArray *)GetShoppingCart
{
    NSArray *dataArr = [APPDefaultManager getDefaultByKey:KEYShopingCart];
    
    NSMutableArray *shoppingCart = [NSMutableArray array];
    for (NSData *data in dataArr) {
        [shoppingCart addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    
    return shoppingCart;
}

+(void)AddGood:(ShoppingCartModel *)model
{
    NSMutableArray *shoppingCart = [NSMutableArray arrayWithArray:[APPDefaultManager getDefaultByKey:KEYShopingCart]];

    int i =0;
    for (NSData *data in shoppingCart) {
        
        ShoppingCartModel *tempModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([[NSString stringWithFormat:@"%@",tempModel.ShoppingCartGoodId] isEqualToString:[NSString stringWithFormat:@"%@",model.ShoppingCartGoodId]])
        {
            if([[NSString stringWithFormat:@"%@",tempModel.ShoppingCartGuigeId] isEqualToString:[NSString stringWithFormat:@"%@",model.ShoppingCartGuigeId]])//如果是同一件商品则累加
            {
                NSInteger num = [tempModel.ShoppingCartBuyNum integerValue];
                num+=[model.ShoppingCartBuyNum integerValue];
                tempModel.ShoppingCartBuyNum = ZY_NSStringFromFormat(@"%ld",(long)num);
                [shoppingCart replaceObjectAtIndex:i withObject:[NSKeyedArchiver archivedDataWithRootObject:tempModel]];
                
                [APPDefaultManager setDefaultByKey:KEYShopingCart andObject:shoppingCart];
                
                return;
            }
        }
        i++;
        
    }
    //如果是一件新的商品则添加至购物车列表
    [shoppingCart addObject:[NSKeyedArchiver archivedDataWithRootObject:model]];
    [APPDefaultManager setDefaultByKey:KEYShopingCart andObject:shoppingCart];
}


+(void)plusGoodNumWithGoodId:(NSString *)goodId andGuigeId:(NSString*)guigeId
{
    NSMutableArray *shoppingCart = [NSMutableArray arrayWithArray:[APPDefaultManager getDefaultByKey:KEYShopingCart]];

    int i =0;
    for (NSData *data in shoppingCart) {
        
        ShoppingCartModel *tempModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([[NSString stringWithFormat:@"%@",tempModel.ShoppingCartGoodId] isEqualToString:[NSString stringWithFormat:@"%@",goodId]])
        {
            if([[NSString stringWithFormat:@"%@",tempModel.ShoppingCartGuigeId] isEqualToString:[NSString stringWithFormat:@"%@",guigeId]])//如果是同一件商品则累加
            {
                NSInteger num = [tempModel.ShoppingCartBuyNum integerValue];
                num++;
                tempModel.ShoppingCartBuyNum = ZY_NSStringFromFormat(@"%ld",(long)num);
                [shoppingCart replaceObjectAtIndex:i withObject:[NSKeyedArchiver archivedDataWithRootObject:tempModel]];
                
                [APPDefaultManager setDefaultByKey:KEYShopingCart andObject:shoppingCart];
                
                return;
            }
        }
        i++;
        
    }
}

+(void)reduceGoodNumWithGoodId:(NSString *)goodId andGuigeId:(NSString*)guigeId
{
    
    NSMutableArray *shoppingCart = [NSMutableArray arrayWithArray:[APPDefaultManager getDefaultByKey:KEYShopingCart]];
    
    int i =0;
    for (NSData *data in shoppingCart) {
        
        ShoppingCartModel *tempModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
//        [shoppingCart removeObjectAtIndex:i];
        DLog(@"%@",tempModel.ShoppingCartGoodId);
        if([tempModel.ShoppingCartGoodId isEqualToString:goodId])
        {
            if([[NSString stringWithFormat:@"%@",tempModel.ShoppingCartGuigeId] isEqualToString:[NSString stringWithFormat:@"%@",guigeId]])//判断是否是该商品
            {
                NSInteger num = [tempModel.ShoppingCartBuyNum integerValue];
                
                if (num <= 1) /*如果减没了则从购物车移除*/{
                    [shoppingCart removeObjectAtIndex:i];
                    [APPDefaultManager setDefaultByKey:KEYShopingCart andObject:shoppingCart];
                    
                    return;
                }
                
                num--;
                tempModel.ShoppingCartBuyNum = ZY_NSStringFromFormat(@"%ld",(long)num);
                [shoppingCart replaceObjectAtIndex:i withObject:[NSKeyedArchiver archivedDataWithRootObject:tempModel]];
                
                [APPDefaultManager setDefaultByKey:KEYShopingCart andObject:shoppingCart];
                
                return;
            }
        }
        i++;
        
    }
}


+(void)clearShoppingCart
{
    [APPDefaultManager removeDefaultByKey:KEYShopingCart];
}

@end
