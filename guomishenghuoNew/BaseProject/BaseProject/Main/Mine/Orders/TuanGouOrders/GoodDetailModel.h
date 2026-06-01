//
//  GoodDetailModel.h
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodSpecsModel.h"

@interface GoodDetailModel : NSObject
@property(nonatomic) NSString *goodID;
@property(nonatomic) NSString *goodName;
@property(nonatomic) NSString *goodDescripe;
@property(nonatomic) NSString *goodPrice;
@property(nonatomic) NSString *goodCount;
@property(nonatomic) NSString *goodImgUrl;
@property(nonatomic) NSString *goodQuanMa;//券码
@property(nonatomic) NSArray <GoodSpecsModel *>*goodSpecs;

+(instancetype)GoodDetailWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
