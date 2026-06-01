//
//  DataProviderOther.h
//  BaseProject
//
//  Created by 于金祥 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseRequest.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"

@interface DataProviderOther : BaseRequest
-(void)GetCityInfo:(NSString *)city;
/**
 *  获取轮播图
 *
 *  @param areaid <#areaid description#>
 *  @param type   type 类型 2：首页一级广告 3：首页二级广告 4：商城一级广告 5：商城二级广告 6：购物券商城一级广告 7：购物券商城二级广告
 */
-(void)GetLunBoTu:(NSString *)areaid andtype:(NSString *)type;
/**
 *  获取首页分类
 *
 *  @param areaid <#areaid description#>
 */
-(void)GetFenLei;
/**
 *  获取首页名店抢购
 *
 *  @param areaid <#areaid description#>
 */
-(void)GetMingDian:(NSString *)areaid;
/**
 *  获取首页热销产品
 *
 *  @param areaid <#areaid description#>
 */
-(void)GetFotGood:(NSString *)areaid andlat:(NSString *)lat andlng:(NSString *)lng;
/**
 *  获取所有分类
 */
-(void)GetAllFenLei;
/**
 *  获取县区
 *
 *  @param areaid <#areaid description#>
 */
-(void)GetCityNext:(NSString *)areaid;
/**
 *  <#Description#>
 *
 *  @param areaid <#areaid description#>
 *  @param type   type 类型 2：首页一级广告 3：首页二级广告 4：商城一级广告 5：商城二级广告 6：购物券商城一级广告 7：购物券商城二级广告
 */
-(void)GetLunBoTuSecond:(NSString *)areaid andtype:(NSString *)type;

/**
 *  获取二级分类
 *
 *  @param parentid <#parentid description#>
 */
-(void)GetFenLeiSecond:(NSString *)parentid;
/**
 *  获取购物车数据
 *
 *  @param userid <#userid description#>
 */
-(void)GetShoppingCarDataWithUserId:(NSString *)userid;

/**
 *  获取商铺列表
 *
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 *  @param search        <#search description#>
 *  @param categoryid    <#categoryid description#>
 *  @param length        <#length description#>
 *  @param order         <#order description#>
 *  @param areaid        <#areaid description#>
 */
-(void)GetShopListstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryid:(NSString *)categoryid andlength:(NSString *)length andorder:(NSString *)order andareaid:(NSString *)areaid;
/**
 *  搜索
 *
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 *  @param search        <#search description#>
 *  @param categoryid    <#categoryid description#>
 *  @param length        <#length description#>
 *  @param order         <#order description#>
 *  @param areaid        <#areaid description#>
 *  @param isallcity     <#isallcity description#>
 */
-(void)SearchWithRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryid:(NSString *)categoryid andlength:(NSString *)length andorder:(NSString *)order andareaid:(NSString *)areaid andisallcity:(NSString *)isallcity andlat:(NSString *)lat andlng:(NSString *)lng;
/**
 *  获取购物券商城分类
 */
-(void)GetShopFenLei;
/**
 *  名店列表
 *
 *  @param areaid <#areaid description#>
 */
-(void)GetMingDianList:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andlat:(NSString *)lat andlng:(NSString *)lng;
/**
 *  查询我的评价
 *
 *  @param userid        <#userid description#>
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 *  @param type          是否团购评价 0：购物券评价 1：团购评价
 */
-(void)GetCommentWithUserid:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andtype:(NSString *)type;

/**
 *  获取我的收藏列表
 *
 *  @param userid        <#userid description#>
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 *  @param type          <#type description#>
 */
-(void)GetShouCangWithUserid:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andtype:(NSString *)type;
/**
 *  删除收藏
 *
 *  @param shoucangid <#shoucangid description#>
 */
-(void)DelShouCang:(NSString *)shoucangid;

/**
 *  我的钱包以及明细
 *
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 */
-(void)SelectMyWalletWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

/**
 *  获取我的订单
 *
 *  @param jifenstate    购物券订单状态
 *  @param tuangoustate  团购订单状态
 *  @param tuikuanstate  1：退款订单   0:正常订单
 *  @param isjifen       1:购物券商城订单   0:团购订单
 *  @param isdaodian     是否到店:是:1   否:0
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 */
-(void)GetUserOrderListWithjifenstate:(NSString *)jifenstate andtuangoustate:(NSString *)tuangoustate andtuikuanstate:(NSString *)tuikuanstate andisjifen:(NSString *)isjifen andisdaodian:(NSString *)isdaodian andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

/**
 *  根据地区获取购物券商城的分类以及产品
 *
 *  @param areaid <#areaid description#>
 */
-(void)GetJiFenShopAllProductWithareaid:(NSString *)areaid andparentid:(NSString *)parentid;
/**
 *  创建订单
 *
 *  @param list_billdetail <#list_billdetail description#>
 */
-(void)BuildBillWithDetail:(NSString *)list_billdetail andtype:(NSString *)type;
/**
 *  <#Description#>
 *
 *  @param billid       <#billid description#>
 *  @param addressid    <#addressid description#>
 *  @param type         0：普通订单 1：购物券订单
 *  @param buyermessage <#buyermessage description#>
 *  @param totalprice   <#totalprice description#>
 */
-(void)SaveBillWithbillid:(NSString *)billid andaddressid:(NSString *)addressid andtype:(NSString *)type andbuyermessage:(NSString *)buyermessage andtotalprice:(NSString *)totalprice;
/**
 *  我的购物券列表
 *
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 */
-(void)GetMineJiFenWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;
/**
 *  团购的立即购买
 *
 *  @param productid <#productid description#>
 *  @param num       <#num description#>
 */
-(void)BuyRightNowWith:(NSString *)productid andnum:(NSString *)num;

/**
 *  团购保存订单
 *
 *  @param list_billid  订单id
 *  @param qianbao      钱包花费
 *  @param channel      支付方式微信：“wx”支付宝：“alipay”银联：“upacp”
 *  @param buyermessage <#buyermessage description#>
 *  @param totalprice   总价
 */
-(void)TuanGouSaveBillWithlist_billid:(NSString *)list_billid andqianbao:(NSString *)qianbao andchannel:(NSString *)channel andbuyermessage:(NSString *)buyermessage andtotalprice:(NSString *)totalprice;

/**
 *  充值
 *
 *  @param channel 支付方式微信：“wx”支付宝：“alipay”银联：“upacp”
 *  @param amount  充值金额
 */
-(void)ChongZhiGetChargeWithchannel:(NSString *)channel andamount:(NSString *)amount;

/**
 *  提交购物车
 *
 *  @param list_detail <#list_detail description#>
 */
-(void)SubmitBasketWithlist_detail:(NSString *)list_detail;

/**
 *  修改购物车数量
 *
 *  @param detailid <#detailid description#>
 *  @param num      <#num description#>
 */
-(void)ChangeProductNumForBasketWithdetailid:(NSString *)detailid andnum:(NSString *)num;
/**
 *  取消订单
 *
 *  @param billid <#billid description#>
 */
-(void)CancelBillWithbillid:(NSString *)billid andreason:(NSString *)reason;
/**
 *  删除订单
 *
 *  @param billid <#billid description#>
 */
-(void)DeleteBillWithbillid:(NSString *)billid;
/**
 *  确认收货
 *
 *  @param billid <#billid description#>
 */
-(void)ReceiveBillWithbillid:(NSString *)billid;

/**
 *  热门搜索
 */
-(void)HotSearch;

-(void)AppraiseBillWithbillid:(NSString *)billid andshopscore:(NSString *)shopscore andshopappraise:(NSString *)shopappraise andshopappraisepicture:(NSString *)shopappraisepicture andlist_ProAppraise:(NSString *)list_ProAppraise;

/**
 *  到店支付
 *
 *  @param totalprice <#totalprice description#>
 *  @param channel    <#channel description#>
 *  @param shopid     <#shopid description#>
 */
-(void)DaoDianWithtotalprice:(NSString *)totalprice andchannel:(NSString *)channel andshopid:(NSString *)shopid;

/**
 *  购物券商城下的推荐商品
 *
 *  @param areaid        <#areaid description#>
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 */
-(void)SelectRecommendForJifen:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;
/**
 *  今日推荐
 *
 *  @param areaid        <#areaid description#>
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 */
-(void)SelectTodayRecommend:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;

/**
 *  消息中心
 *
 *  @param areaid        <#areaid description#>
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 */
-(void)SelectMessage:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;


/**
 *  申请开店
 *
 *  @param username   <#username description#>
 *  @param shopname   <#shopname description#>
 *  @param password   <#password description#>
 *  @param address    <#address description#>
 *  @param phone      <#phone description#>
 *  @param categoryid <#categoryid description#>
 */
-(void)ApplyOpenShopWithusername:(NSString * )username andshopname:(NSString *)shopname andpassword:(NSString *)password andaddress:(NSString *)address andphone:(NSString *)phone andcategoryid:(NSString *)categoryid;
/**
 *  批量删除购物车
 *
 *  @param list_detail <#list_detail description#>
 */
-(void)DeleteForBasketWithlist_detail:(NSString *)list_detail;

/**
 *  附近店铺
 *
 *  @param lat <#lat description#>
 *  @param lng <#lng description#>
 */
-(void)SelectShopListForFujinWithlat:(NSString *)lat andlng:(NSString *)lng;

-(void)SelectShopIndexNewRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryid:(NSString *)categoryid andlength:(NSString *)length andorder:(NSString *)order andareaid:(NSString *)areaid andisallcity:(NSString *)isallcity andlat:(NSString *)lat andlng:(NSString *)lng;
/**
 *  验证支付密码
 *
 *  @param paypassword <#paypassword description#>
 */
-(void)CheckPayPasswordWithpaypassword:(NSString *)paypassword;
/**
 *  <#Description#>
 *
 *  @param startRowIndex <#startRowIndex description#>
 *  @param maximumRows   <#maximumRows description#>
 *  @param type          type 类型 8：购物券记录 9：钱包记录 10：健康储蓄金记录
 */
-(void)SelectAllWalletDetailWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andtype:(NSString *)type;
/**
 *  提现
 *
 *  @param type   <#type description#>
 *  @param amount <#amount description#>
 *  @param cardno <#cardno description#>
 */
-(void)WidthDrawWithtype:(NSString * )type andamount:(NSString *)amount andcardno:(NSString *)cardno;
///获取商铺相册
-(void)GetShopPhotoLibraryWithShopID:(NSString *)shopid;
//删除
-(void)DELWithBillID:(NSString *)billid;

//纠错
-(void)SendErrorMessageWithShopID:(NSString *)shopid andshopName:(NSString *)shopName andcategory:(NSString *)categoryname andcontent:(NSString *)content;

//提现记录
-(void)SelectWidthDrawRecord:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows;


-(void)SendSMSCodeWithVerifyCode:(NSString *)code andPhone:(NSString *)phone;

//获取名店抢购图片
-(void)GetPicture:(NSString *)areaid;
//积分商城搜索
-(void)JifenSearchWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andareaid:(NSString *)areaid;



-(void)SubmitBasketNewWithlist_detail:(NSString *)list_detail userid:(NSString *)userid type:(NSString *)type;

-(void)BuildBillNewWithDetail:(NSString *)list_billdetail andtype:(NSString *)type list_billid:(NSString *)list_billid pointprice:(NSString *)pointprice;

-(void)SaveBasketBillWithlist_billid:(NSString *)list_billid addressid:(NSString *)addressid totalprice:(NSString *)totalprice list_basketbillid:(NSString *)list_basketbillid;

@end
