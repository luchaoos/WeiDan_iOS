//
//  AddressModel.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+(instancetype)AddressModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        @try {
            
//            @property(nonatomic) NSString *Address_Id;
//            @property(nonatomic) NSString *Address_addr;
//            @property(nonatomic) NSString *Address_sex;
//            @property(nonatomic) NSString *Address_phone;
//            @property(nonatomic) NSString *Address_name;
//            @property(nonatomic) NSString *lat;//精度
//            @property(nonatomic) NSString *lng;//纬度
            self.Address_Id = [Toolkit judgeIsNull:dict[@"Id"]];
            self.Address_addr = [Toolkit judgeIsNull:dict[@"AddressDetail"]];
            self.Address_Num = [Toolkit judgeIsNull:dict[@"HouseNum"]];
            self.Address_sex = [Toolkit judgeIsNull:dict[@"Sex"]];
            self.Address_phone = [Toolkit judgeIsNull:dict[@"Phone"]];
            self.Address_name = [Toolkit judgeIsNull:dict[@"Name"]];
            self.lat = [Toolkit judgeIsNull:dict[@"Lat"]];
            self.lng = [Toolkit judgeIsNull:dict[@"Lng"]];
            self.IsDefault = [Toolkit judgeIsNull:dict[@"IsDefault"]];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    
    return self;
}

@end
