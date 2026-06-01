//
//  TakeOutModel.h
//  智慧社区
//
//  Created by 陈程 on 15/5/26.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ShoppingCartModel.h"

@interface TakeOutModel : NSObject
/**
 * 食品标题
 */
@property (nonatomic,copy) NSString *title;
/**
 * 食品id
 */
@property (nonatomic,assign) NSInteger foodID;
/**
 * 已经售出的份数
 */
@property (nonatomic,assign) NSInteger soldCount;
/**
 * 价格
 */
@property (nonatomic,assign) float price;
/**
 * 图像地址
 */
@property (nonatomic,copy) NSString *iconPath;
/**
 * 是否显示份数
 */
@property (nonatomic,assign,getter=IsShowCount) BOOL showCount;
/**
 * 订购的数量
 */
@property (nonatomic,assign) NSInteger orderCount;

@property (nonatomic) BOOL moreGuiGe;
@property (nonatomic,strong)NSArray * guiGeArray;

//+(instancetype)TakeOutWithShoopingCartModel:(ShoppingCartModel *)model;
//-(instancetype)initWithShoppingCartModel:(ShoppingCartModel *)model;
@end
