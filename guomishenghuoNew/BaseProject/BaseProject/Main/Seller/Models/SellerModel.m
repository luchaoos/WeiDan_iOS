//
//  SellerModel.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/5.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SellerModel.h"

@implementation SellerModel
+ (SellerModel *)modelWithDictionary:(NSDictionary *)dic{
    return [[SellerModel alloc]initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(id)copyWithZone:(struct _NSZone *)zone{
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
