//
//  SellerModel.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/5.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerModel : NSObject

@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *other;
@property (nonatomic, copy) NSString *dress;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *distance;

+ (SellerModel *)modelWithDictionary:(NSDictionary *)dic;
@end
