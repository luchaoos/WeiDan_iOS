//
//  DataProvider.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"

@interface DataProvider :BaseRequest

//注册
-(void)registerWithUsername:(NSString *)username password:(NSString *)password;
//快速登录
-(void)fastLoginWithPhone:(NSString *)phone;
//登录
-(void)loginWithUsername:(NSString *)username password:(NSString *)password;
//更改密码，通过旧密码更改
-(void)changePasswordWithId:(NSString *)user_id oldpassword:(NSString *)oldpassword newpassword:(NSString *)newpassword;
//忘记密码，通过验证码更改
-(void)changePasswordByVerifyCodeWithId:(NSString *)userid newpassword:(NSString *)newpassword;
//设置支付密码
-(void)setPayPasswordWithId:(NSString *)userid paypassword:(NSString *)paypassword;
//更改支付密码
-(void)changePayPasswordWithId:(NSString *)userid oldpaypassword:(NSString *)oldpaypassword newpaypassword:(NSString *)newpaypassword;
//头像上传
-(void)uploadHeadImageWithFileName:(NSString *)fileName filestream:(NSString *)filestream;
//修改和个人信息
-(void)changePersonalInfoWithId:(NSString *)userid photopath:(NSString *)photopath nicname:(NSString *)nicname;
//获取收货地址的列表
-(void)getAddressListWithUserid:(NSString *)userid;
//新增（编辑）收货地址
-(void)addAddressWithId:(NSString *)userid
          addressdetail:(NSString *)addressdetail
                 areaid:(NSString *)areaid
              isdefault:(NSString *)isdefault
                    lat:(NSString *)lat
                    lng:(NSString *)lng
                 shopid:(NSString *)shopid
                  phone:(NSString *)phone
               postcode:(NSString *)postcode
                   name:(NSString *)name;
//设置默认收货地址
-(void)setDefaultAddressWithAddressid:(NSString *)addressid userid:(NSString *)userid;
//删除收货地址
-(void)deleteAddressByAddressid:(NSString *)addressid;

///第三方登录
-(void)OtherloginWithopenid:(NSString *)openid nicname:(NSString *)nicname andphotopath:(NSString *)photopath;


#pragma mark ---------- 首页 ---------
//城市查询
-(void)getAllCity;

-(void)BoundPhoneWithopenid:(NSString *)openid andphone:(NSString *)phone;


-(void)shopIndexServiceGetDistributionWithShopid:(NSString *)shopId;

-(void)shopIndexServiceGetSubordinateListWithShopid:(NSString *)shopId type:(NSString *)type;

-(void)shopIndexServiceGetCommissionListWithShopid:(NSString *)shopId startRowIndex:(NSString *)startRowIndex maximumRows:(NSString *)maximumRows;


-(void)commissionServiceIsBindBankCardWithShopid:(NSString *)shopId;

-(void)commissionServiceWithDrawCashWithShopid:(NSString *)shopId money:(NSString *)money;

-(void)commissionServiceBindBankCardWithShopid:(NSString *)shopId cardno:(NSString *)cardno recopenaccdept:(NSString *)recopenaccdept recvubankno:(NSString *)recvubankno nameforbank:(NSString *)nameforbank;

-(void)shopIndexServiceGetWithDrawListWithShopid:(NSString *)shopId startRowIndex:(NSString *)startRowIndex maximumRows:(NSString *)maximumRows;

-(void)commissionServicGetBankMesWithShopid:(NSString *)shopId;

-(void)commissionServicGetProvinceWithShopid:(NSString *)shopId;

-(void)commissionServicGetAreaMesWithShopid:(NSString *)shopId provincename:(NSString *)provincename ;

-(void)commissionServicGetCodeWithShopid:(NSString *)shopId areacode:(NSString *)areacode bankcode:(NSString *)bankcode ;

-(void)mallServiceCallBackOrderno:(NSString *)orderno amount:(NSString *)amount;

-(void)ShopIndexServiceSubmitPointWithShopid:(NSString *)shopid userid:(NSString *)userid point:(NSString *)point;

-(void)ShopIndexGetPointPictureWithShopid:(NSString *)shopid;

-(void)shopIndexServiceGetPointProductWithShopid:(NSString *)shopId startRowIndex:(NSString *)startRowIndex maximumRows:(NSString *)maximumRows;

-(void)OtherServiceApplyOpenPointShopNewWithShopid:(NSString *)shopid shopname:(NSString *)shopname phone:(NSString *)phone address:(NSString *)address;

-(void)ShopIndexServiceSubmitPointWithShopid:(NSString *)shopid userid:(NSString *)userid priceid:(NSString *)priceid;
@end
