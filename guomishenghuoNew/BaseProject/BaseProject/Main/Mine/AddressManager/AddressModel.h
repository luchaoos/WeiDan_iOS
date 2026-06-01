//
//  AddressModel.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property(nonatomic) NSString *Address_Id;
@property(nonatomic) NSString *Address_addr;
@property(nonatomic) NSString *Address_Num;
@property(nonatomic) NSString *Address_sex;
@property(nonatomic) NSString *Address_phone;
@property(nonatomic) NSString *Address_name;
@property(nonatomic) NSString *lat;//精度
@property(nonatomic) NSString *lng;//纬度
@property(nonatomic) NSString *IsDefault;//是否是默认

+(instancetype)AddressModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
