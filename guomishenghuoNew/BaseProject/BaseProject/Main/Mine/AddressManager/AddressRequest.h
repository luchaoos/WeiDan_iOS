//
//  AddressRequest.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/14.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "BaseRequest.h"

@interface AddressRequest : BaseRequest
//获取地址列表
-(void)addressList;
//添加地址
-(void)addAddressWithDetail:(NSString *)addressdetail
                  andAreaid:(NSString *)areaid
                     andLat:(NSString *)lat
                     andLng:(NSString *)lng
                     andSex:(NSString *)sex
                   andPhone:(NSString *)phone
                    andName:(NSString *)name
                andHouseNum:(NSString *)housenum;
//编辑地址
-(void)eidtAddressWithId:(NSString *)addrId
                  Detail:(NSString *)addressdetail
               andAreaid:(NSString *)areaid
                  andLat:(NSString *)lat
                  andLng:(NSString *)lng
                  andSex:(NSString *)sex
                andPhone:(NSString *)phone
                 andName:(NSString *)name
             andHouseNum:(NSString *)housenum;
//删除地址
-(void)delAddressWithID:(NSString *)addrid;

@end
