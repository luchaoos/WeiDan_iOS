//
//  GoodsModel.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/5/20.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CateModel.h"
#import "GuigeModel.h"


@interface GoodsModel : NSObject
@property(nonatomic) NSString *goodId;
@property(nonatomic) NSString *goodName;
@property(nonatomic) NSString *goodPrice;
@property(nonatomic) NSString *goodStorNum;//库存
@property(nonatomic) NSString *goodImgUrl;
@property(nonatomic) NSString *goodState;//商品状态
@property(nonatomic) NSString *goodSaleNum;//月销售数量
@property(nonatomic) CateModel *goodCate;//所属分类
@property(nonatomic) NSString *goodDanwei;//商品单位（份、个等）
@property(nonatomic) NSString *goodMinByNum;//最少购买量
@property(nonatomic) NSString *goodDescripe;//商品描述
@property(nonatomic) NSString *goodStar;//商品星评

@property(nonatomic) NSArray <GuigeModel *> *goodGuigeModel;//商品规格

//将内部model转为dict 用于上传至服务器
-(NSDictionary *)BuildProductDictForUpload;
-(NSDictionary *)buildGuigeDictForUploadWith:(GuigeModel *)guigeModel;
-(NSArray *)buildGuigeArrForUpload;

//初始化方法
+(instancetype)GoodModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
