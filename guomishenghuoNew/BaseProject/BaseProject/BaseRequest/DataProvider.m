//
//  DataProvider.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DataProvider.h"

//#define YZkey @"6f0a9c87-5d76-46af-87d5-2c69271b7cff"
//#define uid @"85a4d4cd-ec0f-4b2e-8514-4c5ffc0257c0"
#define LoginService @"LoginService.asmx/Entry"
#define MineService @"MineService.asmx/Entry"
#define UpLoadImage @"LoginService.asmx/UpLoadImage"
#define IndexService @"IndexService.asmx/Entry"
#define ShopIndexService @"ShopIndexService.asmx/Entry"

@implementation DataProvider

//注册
-(void)registerWithUsername:(NSString *)username password:(NSString *)password{
    if (username && password) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"username",
                                          @"password"]
                              andResult:@[@"Register",
                                          username,
                                          password]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

//快速登录
-(void)fastLoginWithPhone:(NSString *)phone{
    if (phone) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"phone"]
                              andResult:@[@"LoginFast",
                                          phone]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

//登录
-(void)loginWithUsername:(NSString *)username password:(NSString *)password{
    if (username && password) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"username",
                                          @"password"]
                              andResult:@[@"Login",
                                          username,
                                          password]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

//登录
-(void)OtherloginWithopenid:(NSString *)openid nicname:(NSString *)nicname andphotopath:(NSString *)photopath{
    if (openid && nicname && photopath) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"openid",
                                          @"nicname",
                                          @"photopath"]
                              andResult:@[@"LoginByOther",
                                          openid,
                                          nicname,
                                          photopath]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//更改密码，通过旧密码更改
-(void)changePasswordWithId:(NSString *)userid oldpassword:(NSString *)oldpassword newpassword:(NSString *)newpassword{
    if (userid && oldpassword && newpassword) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"phone",
                                          @"oldpassword",
                                          @"newpassword"]
                              andResult:@[@"ChangePasswordByOld",
                                          userid,
                                          oldpassword,
                                          newpassword]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//忘记密码，通过验证码更改
-(void)changePasswordByVerifyCodeWithId:(NSString *)userid newpassword:(NSString *)newpassword{
    if (userid && newpassword) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"phone",
                                          @"newpassword"]
                              andResult:@[@"ChangePassword",
                                          userid,
                                          newpassword]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//设置支付密码
-(void)setPayPasswordWithId:(NSString *)userid paypassword:(NSString *)paypassword{
    if (userid && paypassword) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"paypassword"]
                              andResult:@[@"SetPayPassword",
                                          userid,
                                          paypassword]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

//更改支付密码
-(void)changePayPasswordWithId:(NSString *)userid oldpaypassword:(NSString *)oldpaypassword newpaypassword:(NSString *)newpaypassword{
    if (userid && oldpaypassword && newpaypassword) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"oldpaypassword",
                                          @"newpaypassword"]
                              andResult:@[@"ChangePayPassword",
                                          userid,
                                          oldpaypassword,
                                          newpaypassword]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//头像上传
-(void)uploadHeadImageWithFileName:(NSString *)fileName filestream:(NSString *)filestream{
    if (fileName && filestream) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,UpLoadImage];
//        NSString *json = [self setParam:@[@"function",
//                                          @"fileName",
//                                          @"filestream"]
//                              andResult:@[@"UpLoadImage",
//                                          fileName,
//                                          filestream]];
//        NSDictionary *params = @{@"args":json};
//        ELog(params);
        NSDictionary *prm = @{@"fileName":fileName,@"filestream":filestream};;
        [self postRequst:url andPrm:prm];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//修改个人信息
-(void)changePersonalInfoWithId:(NSString *)userid photopath:(NSString *)photopath nicname:(NSString *)nicname{
    if (userid && photopath && nicname) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"photopath",
                                          @"nicname"]
                              andResult:@[@"ChangeInfor",
                                          userid,
                                          photopath,
                                          nicname]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
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
                   name:(NSString *)name{
    if (userid && addressdetail && isdefault && shopid && phone && name) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"addressdetail",
                                          @"areaid",
                                          @"isdefault",
                                          @"lat",
                                          @"lng",
                                          @"shopid",
                                          @"phone",
                                          @"postcode",
                                          @"name"]
                              andResult:@[@"SaveAddress",
                                          userid,
                                          addressdetail,
                                          areaid,
                                          isdefault,
                                          lat,
                                          lng,
                                          shopid,
                                          phone,
                                          postcode,
                                          name]];
        NSDictionary *params = @{@"args":json};
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//获取收货地址的列表
-(void)getAddressListWithUserid:(NSString *)userid{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"userid"]
                              andResult:@[@"SelectAllAddressByUserId",
                                          userid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//设置默认收货地址
-(void)setDefaultAddressWithAddressid:(NSString *)addressid userid:(NSString *)userid{
    if (addressid && userid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"addressid",
                                          @"userid"]
                              andResult:@[@"SetDefaultAddressById",
                                          addressid,
                                          userid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//删除收货地址
-(void)deleteAddressByAddressid:(NSString *)addressid{
    if (addressid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"addressid"]
                              andResult:@[@"DeleteAddressById",
                                          addressid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark ---------- 首页 ---------
//城市查询
-(void)getAllCity{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
    NSString *json = [self setParam:@[@"function"]
                          andResult:@[@"SelectAllArea"]];
    NSDictionary *params = @{@"args":json};
    ELog(params);
    [self postRequst:url andPrm:params];
}


-(void)BoundPhoneWithopenid:(NSString *)openid andphone:(NSString *)phone
{
    if (openid && phone) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                          @"openid",
                                          @"phone"]
                              andResult:@[@"BindPhone",
                                          openid,
                                          phone]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)shopIndexServiceGetDistributionWithShopid:(NSString *)shopId
{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/ShopWebService/%@",ShopIndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",]
                              andResult:@[@"GetDistribution",
                                          shopId,]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)shopIndexServiceGetSubordinateListWithShopid:(NSString *)shopId type:(NSString *)type
{
    if (shopId && type) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/ShopWebService/%@",ShopIndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"type"]
                              andResult:@[@"GetSubordinateList",
                                          shopId,
                                          type]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)shopIndexServiceGetCommissionListWithShopid:(NSString *)shopId startRowIndex:(NSString *)startRowIndex maximumRows:(NSString *)maximumRows
{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/ShopWebService/%@",ShopIndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"GetCommissionList",
                                          shopId,
                                          startRowIndex,
                                          maximumRows]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)commissionServiceIsBindBankCardWithShopid:(NSString *)shopId{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",]
                              andResult:@[@"IsBindBankCard",
                                          shopId,]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)commissionServiceWithDrawCashWithShopid:(NSString *)shopId money:(NSString *)money{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"money"]
                              andResult:@[@"WithDrawCash",
                                          shopId,
                                          money]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)commissionServiceBindBankCardWithShopid:(NSString *)shopId cardno:(NSString *)cardno recopenaccdept:(NSString *)recopenaccdept recvubankno:(NSString *)recvubankno nameforbank:(NSString *)nameforbank{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"cardno",
                                          @"recopenaccdept",
                                          @"recvubankno",
                                          @"nameforbank"]
                              andResult:@[@"BindBankCard",
                                          shopId,
                                          cardno,
                                          recopenaccdept,
                                          recvubankno,
                                          nameforbank]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)shopIndexServiceGetWithDrawListWithShopid:(NSString *)shopId startRowIndex:(NSString *)startRowIndex maximumRows:(NSString *)maximumRows
{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"GetWithDrawList",
                                          shopId,
                                          startRowIndex,
                                          maximumRows]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)commissionServicGetBankMesWithShopid:(NSString *)shopId{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",]
                              andResult:@[@"GetBankMes",]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)commissionServicGetProvinceWithShopid:(NSString *)shopId{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",]
                              andResult:@[@"GetProvince",]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)commissionServicGetAreaMesWithShopid:(NSString *)shopId provincename:(NSString *)provincename {
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"provincename"]
                              andResult:@[@"GetAreaMes",
                                          provincename]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)commissionServicGetCodeWithShopid:(NSString *)shopId areacode:(NSString *)areacode bankcode:(NSString *)bankcode {
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"CommissionService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"areacode",
                                          @"bankcode"]
                              andResult:@[@"GetCode",
                                          areacode,
                                          bankcode]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)mallServiceCallBackOrderno:(NSString *)orderno amount:(NSString *)amount {
    if (orderno) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"MallService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"orderno",
                                          @"amount"]
                              andResult:@[@"CallBack",
                                          orderno,
                                          amount]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)ShopIndexServiceSubmitPointWithShopid:(NSString *)shopid userid:(NSString *)userid point:(NSString *)point {
    if (shopid) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/ShopWebService/%@",@"ShopIndexService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"userid",
                                          @"point"]
                              andResult:@[@"SubmitPoint",
                                          shopid,
                                          userid,
                                          point]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)ShopIndexServiceSubmitPointWithShopid:(NSString *)shopid userid:(NSString *)userid priceid:(NSString *)priceid {
    if (shopid) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/ShopWebService/%@",@"ShopIndexService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"userid",
                                          @"priceid"]
                              andResult:@[@"SubmitPointNew",
                                          shopid,
                                          userid,
                                          priceid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)ShopIndexGetPointPictureWithShopid:(NSString *)shopid {
    if (shopid) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"ShopService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",]
                              andResult:@[@"GetPointPicture",
                                          shopid,]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)shopIndexServiceGetPointProductWithShopid:(NSString *)shopId startRowIndex:(NSString *)startRowIndex maximumRows:(NSString *)maximumRows
{
    if (shopId) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"ShopService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"GetPointProductByShopId",
                                          shopId,
                                          startRowIndex,
                                          maximumRows]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)OtherServiceApplyOpenPointShopNewWithShopid:(NSString *)shopid shopname:(NSString *)shopname phone:(NSString *)phone address:(NSString *)address{
    if (shopid) {
        NSString *url = [NSString stringWithFormat:@"http://121.40.189.165/WebService/%@",@"OtherService.asmx/Entry"];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"shopname",
                                          @"phone",
                                          @"address"]
                              andResult:@[@"ApplyOpenPointShopNew",
                                          shopid,
                                          shopname,
                                          phone,
                                          address]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

//分类搜索产品
//-(void)searchGoodsWithStartRowIndex:(NSString *)startRowIndex maximumRows:(NSString *)maximumRows search:(NSString *)search categoryid:(NSString *)categoryid
@end
