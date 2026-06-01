//
//  DataProviderOther.m
//  BaseProject
//
//  Created by 于金祥 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "DataProviderOther.h"
#define IndexService @"IndexService.asmx/Entry"
#define MallService @"MallService.asmx/Entry"
#define ShopService @"ShopService.asmx/Entry"
#define MineService @"MineService.asmx/Entry"
#define OtherService @"OtherService.asmx/Entry"
#define LoginService @"LoginService.asmx/Entry"

@implementation DataProviderOther



-(void)GetCityInfo:(NSString *)city
{
    if (city) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"cityname"]
                              andResult:@[@"SelectAreaByName",
                                          city]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
    
}
-(void)GetLunBoTu:(NSString *)areaid andtype:(NSString *)type
{
    if (areaid&&type) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"type"]
                              andResult:@[@"SelectAdvertisementNew",
                                          areaid,
                                          type]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetLunBoTuSecond:(NSString *)areaid andtype:(NSString *)type
{
    if (areaid&&type) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"type"]
                              andResult:@[@"SelectAdvertisementNew",
                                          areaid,
                                          type]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetFenLei
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
    NSString *json = [self setParam:@[@"function"]
                          andResult:@[@"SelectProductCategory"]];
    NSDictionary *params = @{@"args":json};
    ELog(params);
    [self postRequst:url andPrm:params];
}
-(void)GetFenLeiSecond:(NSString *)parentid
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
    NSString *json = [self setParam:@[@"function",
                                      @"parentid"]
                          andResult:@[@"SelectChildrenCategory",
                                      parentid]];
    NSDictionary *params = @{@"args":json};
    ELog(params);
    [self postRequst:url andPrm:params];
}
-(void)GetMingDian:(NSString *)areaid
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"num"]
                              andResult:@[@"SelectPanicBuyingByAreaId",
                                          areaid,
                                          @"4"]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetPicture:(NSString *)areaid
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"num"]
                              andResult:@[@"GetPicture",
                                          areaid,
                                          @"4"]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetFotGood:(NSString *)areaid andlat:(NSString *)lat andlng:(NSString *)lng
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"num",
                                          @"lat",
                                          @"lng"]
                              andResult:@[@"SelectRecomendProductByAreaIdNew",
                                          areaid,
                                          @"30",
                                          lat,
                                          lng]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetAllFenLei
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
    NSString *json = [self setParam:@[@"function"]
                          andResult:@[@"SelectAllCategory"]];
    NSDictionary *params = @{@"args":json};
    ELog(params);
    [self postRequst:url andPrm:params];
}
-(void)GetCityNext:(NSString *)areaid
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"parentid"]
                              andResult:@[@"SelectAreaByParentId",
                                          areaid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetShoppingCarDataWithUserId:(NSString *)userid
{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid"]
                              andResult:@[@"SelectBasket",
                                          userid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetShopListstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryid:(NSString *)categoryid andlength:(NSString *)length andorder:(NSString *)order andareaid:(NSString *)areaid
{
    if (startRowIndex&&maximumRows&&search&&categoryid&&length&&order&&areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self setParam:@[@"function",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"search",
                                          @"categoryid",
                                          @"length",
                                          @"order",
                                          @"areaid"]
                              andResult:@[@"SelectPageShopList",
                                          startRowIndex,
                                          maximumRows,
                                          search,
                                          categoryid,
                                          length,
                                          order,
                                          areaid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)SearchWithRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryid:(NSString *)categoryid andlength:(NSString *)length andorder:(NSString *)order andareaid:(NSString *)areaid andisallcity:(NSString *)isallcity andlat:(NSString *)lat andlng:(NSString *)lng
{
    if (startRowIndex&&maximumRows&&search&&categoryid&&length&&order&&areaid&&isallcity) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"search",
                                          @"categoryid",
                                          @"length",
                                          @"ordertype",
                                          @"areaid",
                                          @"isallcity",
                                          @"lat",
                                          @"lng"]
                              andResult:@[@"SelectProductByCategoryIdNew",
                                          startRowIndex,
                                          maximumRows,
                                          search,
                                          categoryid,
                                          length,
                                          order,
                                          areaid,
                                          isallcity,
                                          lat,
                                          lng]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectShopIndexNewRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryid:(NSString *)categoryid andlength:(NSString *)length andorder:(NSString *)order andareaid:(NSString *)areaid andisallcity:(NSString *)isallcity andlat:(NSString *)lat andlng:(NSString *)lng
{
    if (startRowIndex&&maximumRows&&search&&categoryid&&length&&order&&areaid&&isallcity) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"search",
                                          @"categoryid",
                                          @"length",
                                          @"ordertype",
                                          @"areaid",
                                          @"isallcity",
                                          @"lat",
                                          @"lng"]
                              andResult:@[@"SelectShopIndexNew",
                                          startRowIndex,
                                          maximumRows,
                                          search,
                                          categoryid,
                                          length,
                                          order,
                                          areaid,
                                          isallcity,
                                          lat,
                                          lng]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetShopFenLei
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
    NSString *json = [self setParam:@[@"function"]
                          andResult:@[@"GetAllCate"]];
    NSDictionary *params = @{@"args":json};
    ELog(params);
    [self postRequst:url andPrm:params];
}

-(void)GetMingDianList:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andlat:(NSString *)lat andlng:(NSString *)lng
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"lat",
                                          @"lng"]
                              andResult:@[@"SelectRecomendShopNew",
                                          areaid,
                                          startRowIndex,
                                          maximumRows,
                                          lat,
                                          lng]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetCommentWithUserid:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andtype:(NSString *)type
{
    if (userid&&startRowIndex&&maximumRows&&type) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"istuangou"]
                              andResult:@[@"SelectAppraiseForBuyer",
                                          userid,
                                          startRowIndex,
                                          maximumRows,
                                          type]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetShouCangWithUserid:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andtype:(NSString *)type
{
    if (userid&&startRowIndex&&maximumRows&&type) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"type"]
                              andResult:@[@"SelectMyFavProduct",
                                          userid,
                                          startRowIndex,
                                          maximumRows,
                                          type]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)DelShouCang:(NSString *)shoucangid
{
    if (shoucangid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"id"]
                              andResult:@[@"DelFavProduct",
                                          shoucangid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectMyWalletWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex&&maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self userSetParam:@[@"function",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"SelectMyWallet",
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

-(void)GetUserOrderListWithjifenstate:(NSString *)jifenstate andtuangoustate:(NSString *)tuangoustate andtuikuanstate:(NSString *)tuikuanstate andisjifen:(NSString *)isjifen andisdaodian:(NSString *)isdaodian andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex&&maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"startRowIndex",
                                              @"maximumRows",
                                              @"jifenstate",
                                              @"tuangoustate",
                                              @"tuikuanstate",
                                              @"isjifen",
                                              @"isdaodian"]
                                  andResult:@[@"SelectPageBillByUserId",
                                              startRowIndex,
                                              maximumRows,
                                              jifenstate,
                                              tuangoustate,
                                              tuikuanstate,
                                              isjifen,
                                              isdaodian]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)GetJiFenShopAllProductWithareaid:(NSString *)areaid andparentid:(NSString *)parentid
{
    if (areaid&&parentid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"parentid"]
                              andResult:@[@"SelectAllProductAndCategoryByAreaId",
                                          areaid,
                                          parentid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)BuildBillWithDetail:(NSString *)list_billdetail andtype:(NSString *)type
{
    if (list_billdetail&&type) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
        
        NSString *json = [self setParam:@[@"function",
                                          @"list_billdetail",
                                          @"userid",
                                          @"type"]
                              andResult:@[@"BuildBill",
                                          list_billdetail,
                                          get_sp(user_ID),
                                          type]];
        
        NSDictionary * prm=@{@"args": json};
        ELog(prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)BuildBillNewWithDetail:(NSString *)list_billdetail andtype:(NSString *)type list_billid:(NSString *)list_billid pointprice:(NSString *)pointprice
{
    if (list_billdetail&&type) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
        
        NSString *json = [self setParam:@[@"function",
                                          @"list_billdetail",
                                          @"userid",
                                          @"type",
                                          @"list_billid",
                                          @"pointprice"]
                              andResult:@[@"BuildBillNew",
                                          list_billdetail,
                                          get_sp(user_ID),
                                          type,
                                          list_billid,
                                          pointprice]];
        
        NSDictionary * prm=@{@"args": json};
        ELog(prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SaveBasketBillWithlist_billid:(NSString *)list_billid addressid:(NSString *)addressid totalprice:(NSString *)totalprice list_basketbillid:(NSString *)list_basketbillid
{
    if (list_billid&&totalprice) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
        
        NSString *json = [self setParam:@[@"function",
                                          @"list_billid",
                                          @"addressid",
                                          @"totalprice",
                                          @"type",
                                          @"buyermessage",
                                          @"buyerid",
                                          @"list_basketbillid"]
                              andResult:@[@"SaveBasketBill",
                                          list_billid,
                                          addressid,
                                          totalprice,
                                          @"0",
                                          @"",
                                          get_sp(user_ID),
                                          list_basketbillid]];
        
        NSDictionary * prm=@{@"args": json};
        ELog(prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}




-(void)SaveBillWithbillid:(NSString *)billid andaddressid:(NSString *)addressid andtype:(NSString *)type andbuyermessage:(NSString *)buyermessage andtotalprice:(NSString *)totalprice
{
    if (billid&&addressid&&type&&totalprice&&buyermessage) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
        
        NSString *json = [self setParam:@[@"function",
                                          @"billid",
                                          @"addressid",
                                          @"type",
                                          @"buyermessage",
                                          @"totalprice"]
                              andResult:@[@"SaveBill",
                                          billid,
                                          addressid,
                                          type,
                                          buyermessage,
                                          totalprice]];
        
        NSDictionary * prm=@{@"args": json};
        ELog(prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}
-(void)TuanGouSaveBillWithlist_billid:(NSString *)list_billid andqianbao:(NSString *)qianbao andchannel:(NSString *)channel andbuyermessage:(NSString *)buyermessage andtotalprice:(NSString *)totalprice
{
    if (list_billid&&qianbao&&channel&&totalprice&&buyermessage) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        
        NSString *json = [self userSetParam:@[@"function",
                                          @"list_billid",
                                          @"qianbao",
                                          @"channel",
                                          @"buyermessage",
                                          @"totalprice"]
                              andResult:@[@"SaveBill",
                                          list_billid,
                                          qianbao,
                                          channel,
                                          buyermessage,
                                          totalprice]];
        
        NSDictionary * prm=@{@"args": json};
        ELog(prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}
-(void)GetMineJiFenWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (startRowIndex&&maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"startRowIndex",
                                              @"maximumRows"]
                                  andResult:@[@"SelectMyJiFenWallet",
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
-(void)SelectAllWalletDetailWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andtype:(NSString *)type
{
    if (startRowIndex&&maximumRows&&type) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"startRowIndex",
                                              @"maximumRows",
                                              @"type"]
                                  andResult:@[@"SelectAllWalletDetail",
                                              startRowIndex,
                                              maximumRows,
                                              type]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)BuyRightNowWith:(NSString *)productid andnum:(NSString *)num
{
    if (productid&&num) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"productid",
                                              @"num"]
                                  andResult:@[@"BuyNow",
                                              productid,
                                              num]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)ChongZhiGetChargeWithchannel:(NSString *)channel andamount:(NSString *)amount
{
    if (channel&&amount) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"channel",
                                              @"amount",
                                              @"description"]
                                  andResult:@[@"GetCharge",
                                              channel,
                                              amount,
                                              @"果米生活"]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)SubmitBasketWithlist_detail:(NSString *)list_detail
{
    if (list_detail) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"list_detail"]
                                  andResult:@[@"SubmitBasket",
                                              list_detail]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)SubmitBasketNewWithlist_detail:(NSString *)list_detail userid:(NSString *)userid type:(NSString *)type
{
    if (list_detail) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"list_billdetail",
//                                              @"userid",
                                              @"type"]
                                  andResult:@[@"SubmitBasketNew",
                                              list_detail,
//                                              userid,
                                              type]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)ChangeProductNumForBasketWithdetailid:(NSString *)detailid andnum:(NSString *)num
{
    if (detailid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"detailid",
                                              @"num"]
                                  andResult:@[@"ChangeProductNumForBasket",
                                              detailid,
                                              num]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)CancelBillWithbillid:(NSString *)billid andreason:(NSString *)reason
{
    if (billid&&reason) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"billid",
                                              @"reason"]
                                  andResult:@[@"CancelBillNew",
                                              billid,
                                              reason]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)DeleteBillWithbillid:(NSString *)billid
{
    if (billid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"billid"]
                                  andResult:@[@"DeleteBill",
                                              billid]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)ReceiveBillWithbillid:(NSString *)billid
{
    if (billid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"billid"]
                                  andResult:@[@"ReceiveBill",
                                              billid]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)HotSearch
{
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function"]
                                  andResult:@[@"HotSearch"]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
}

-(void)AppraiseBillWithbillid:(NSString *)billid andshopscore:(NSString *)shopscore andshopappraise:(NSString *)shopappraise andshopappraisepicture:(NSString *)shopappraisepicture andlist_ProAppraise:(NSString *)list_ProAppraise
{
    if (billid&&shopscore&&list_ProAppraise&&shopappraisepicture&&shopappraise) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"billid",
                                              @"shopscore",
                                              @"shopappraise",
                                              @"list_shopappraisepicture",
                                              @"list_ProAppraise"]
                                  andResult:@[@"AppraiseBill",
                                              billid,
                                              shopscore,
                                              shopappraise,
                                              shopappraisepicture,
                                              list_ProAppraise]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
-(void)DaoDianWithtotalprice:(NSString *)totalprice andchannel:(NSString *)channel andshopid:(NSString *)shopid
{
    if (totalprice&&channel&&shopid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"channel",
                                              @"totalprice",
                                              @"shopid"]
                                  andResult:@[@"DaoDian",
                                              channel,
                                              totalprice,
                                              shopid]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
        [YJXStatusHUD hideLoading];
    }
}

-(void)SelectRecomendShopForTuangoustartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andcategoryid:(NSString *)categoryid andlength:(NSString *)length andorder:(NSString *)order andareaid:(NSString *)areaid
{
    if (startRowIndex&&maximumRows&&search&&categoryid&&length&&order&&areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self setParam:@[@"function",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"search",
                                          @"categoryid",
                                          @"length",
                                          @"order",
                                          @"areaid"]
                              andResult:@[@"SelectRecomendShopForTuangou",
                                          startRowIndex,
                                          maximumRows,
                                          search,
                                          categoryid,
                                          length,
                                          order,
                                          areaid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectRecommendForJifen:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"SelectRecommendForJifen",
                                          areaid,
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

-(void)SelectTodayRecommend:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,OtherService];
        NSString *json = [self setParam:@[@"function",
                                          @"areaid",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"SelectTodayRecommend",
                                          areaid,
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
-(void)SelectMessage:(NSString *)areaid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,OtherService];
        NSString *json = [self userSetParam:@[@"function",
                                          @"areaid",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"SelectMessage",
                                          areaid,
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
-(void)ApplyOpenShopWithusername:(NSString * )username andshopname:(NSString *)shopname andpassword:(NSString *)password andaddress:(NSString *)address andphone:(NSString *)phone andcategoryid:(NSString *)categoryid
{
    if (username&&shopname&&password&&address&&phone&&categoryid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,OtherService];
        NSString *json = [self setParam:@[@"function",
                                          @"username",
                                          @"shopname",
                                          @"password",
                                          @"address",
                                          @"phone",
                                          @"categoryid",
                                          @"lat",
                                          @"lng",
                                          @"areaid"]
                              andResult:@[@"ApplyOpenShop",
                                          username,
                                          shopname,
                                          password,
                                          address,
                                          phone,
                                          categoryid,
                                          @"",
                                          @"",
                                          @"0"]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)WidthDrawWithtype:(NSString * )type andamount:(NSString *)amount andcardno:(NSString *)cardno
{
    if (type&&amount&&cardno) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self userSetParam:@[@"function",
                                          @"type",
                                          @"amount",
                                          @"cardno"]
                              andResult:@[@"WidthDraw",
                                          type,
                                          amount,
                                          cardno]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
-(void)DeleteForBasketWithlist_detail:(NSString *)list_detail
{
    if (list_detail) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MallService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"list_detaillist"]
                                  andResult:@[@"DeleteForBasket",
                                              list_detail]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)SelectShopListForFujinWithlat:(NSString *)lat andlng:(NSString *)lng
{
    if (lat&&lng) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"lat",
                                              @"lng"]
                                  andResult:@[@"SelectShopListForFujin",
                                              lat,
                                              lng]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}
//验证支付密码
-(void)CheckPayPasswordWithpaypassword:(NSString *)paypassword{
    if (paypassword) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginService];
        NSString *json = [self setParam:@[@"function",
                                              @"id",
                                              @"paypassword"]
                              andResult:@[@"CheckPayPassword",
                                          get_sp(user_ID),
                                          paypassword]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
        [YJXStatusHUD hideLoading];
    }
}

-(void)GetShopPhotoLibraryWithShopID:(NSString *)shopid
{
    if (shopid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ShopService];
        NSString *json = [self setParam:@[@"function",
                                          @"userid"]
                              andResult:@[@"SelectPhotoCategory",
                                          shopid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
        [YJXStatusHUD hideLoading];
    }
}

-(void)DELWithBillID:(NSString *)billid
{
    if (billid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"billid"]
                              andResult:@[@"DeleteBillByBillId",
                                          billid]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
        [YJXStatusHUD hideLoading];
    }
}

-(void)SendErrorMessageWithShopID:(NSString *)shopid andshopName:(NSString *)shopName andcategory:(NSString *)categoryname andcontent:(NSString *)content
{
    if (shopid&&shopName&&categoryname&&content) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"shopid",
                                          @"shopname",
                                          @"categoryname",
                                          @"content"]
                              andResult:@[@"JiuCuo",
                                          shopid,
                                          shopName,
                                          categoryname,
                                          content]];
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
        [YJXStatusHUD hideLoading];
    }
}

-(void)SelectWidthDrawRecord:(NSString *)userid andstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows
{
    if (userid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,MineService];
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"startRowIndex",
                                          @"maximumRows"]
                              andResult:@[@"SelectWidthDrawRecord",
                                          userid,
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

-(void)SendSMSCodeWithVerifyCode:(NSString *)code andPhone:(NSString *)phone
{
    if (code&&phone) {
        NSString *url = [NSString stringWithFormat:@"http://smsapi.c123.cn/OpenPlatform/OpenApi?action=sendOnce&ac=1001@501395610001&authkey=F7245E6A06AC19BDCC07C9A45ED24466&cgid=7903&csid=101&c=%@&m=%@",code,phone];
        NSDictionary *params = @{@"guomishengh":@"32dfdd"};
        [self getRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}

-(void)JifenSearchWithstartRowIndex:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows andsearch:(NSString *)search andareaid:(NSString *)areaid
{
    if (startRowIndex&&maximumRows&&search && areaid) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,IndexService];
        NSString *json = [self userSetParam:@[@"function",
                                              @"startRowIndex",
                                              @"maximumRows",
                                              @"search",
                                              @"areaid"]
                                  andResult:@[@"JifenSearch",
                                              startRowIndex,
                                              maximumRows,
                                              search,
                                              areaid]];
        
        NSDictionary *params = @{@"args":json};
        ELog(params);
        [self postRequst:url andPrm:params];
    }
    else{
        [SVProgressHUD dismiss];
    }
}


@end
