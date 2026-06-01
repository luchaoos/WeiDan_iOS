//
//  GoodDetialViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/4.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "GoodDetialViewController.h"
#import "ShoppingCarCellTableViewCell.h"
//#import "SubmitOrderViewController.h"
#import "LoginManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DataProviderOther.h"
#import "JSONKit.h"
#import "SubmitJiFenOrderViewController.h"
#import "ShopGoodsListViewController.h"
#import "JiFenOrderEnterViewController.h"
#import "JiFenShopingCarViewController.h"
#import "IMChatViewController.h"

#define _ShopingCartCELLHEIGHT   44

@interface GoodDetialViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic) JSContext *jsContext;
@property (nonatomic) GoodsModel *goodModel;
@property (nonatomic) NSMutableArray <GuigeModel *> *guiGeArr;
@property (nonatomic) GuigeModel *selectGuige;


//购物车
@property (strong, nonatomic)  UITableView *shoppingCarTableview;
@property (strong, nonatomic)  UIView *shoppingCarvVew;
@property (strong, nonatomic)  UILabel *lbl_shoppingCarNum;
@property(nonatomic ) NSArray *shopingCartArr;//购物车

@end

@implementation GoodDetialViewController
{
    UIImageView * img_backGround;
    UIView * bottomview_backview;
    BOOL isbottomviewshow;
    BOOL isshoppingCarShow;
    UIButton * btn_showORHide;
    UILabel * lbl_titleprice;
    UIButton * btn_zhezhao;
    
    NSDictionary * data_Info;
    
    UILabel * txt_changeValue;
    UIButton * btn_AddToShoppingCar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    _shopingCartArr = [ShoppingCartManager GetShoppingCart];
    [self.view addSubview:_shoppingCarvVew];
    
    
}

-(void)initViews
{
    [self InitNav];
    
    [self buildbottom];
    [self BuildShoppingCarView];
    [self SetInfoWithShoppingCar];//计算价格
}


-(void)InitNav
{
    _lblTitle.text = @"商品详情";
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.webView.delegate=self;
    self.webView.scalesPageToFit=NO;
    //    self.webView.scrollView.bounces = NO ;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:_webView];
//    NSURL * webUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@ShopS.aspx?productid=%@&buyerid=%@",BaseImgUrl,self.goodId,get_sp(user_ID)]];
    NSURL * webUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@Index.aspx?productid=%@&buyerid=%@",BaseImgUrl,self.goodId,get_sp(user_ID)]];
    [_webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
    //    [_webView loadHTMLString:strHTML baseURL:[NSURL URLWithString:LunBoUrl]];
//    _lblLeft.hidden=YES;
//    _btnLeft.hidden=YES;
//    _imgLeft.hidden=YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak GoodDetialViewController *weakSelf = self;
    
//    _jsContext[@"AddToShoppingCar"] = ^(id obj,id obj1 ,id obj2){
//        //这里通过block回调从而获得h5传来的json数据
//        /*block中捕获JSContexts
//         我们知道block会默认强引用它所捕获的对象，如下代码所示，如果block中直接使用context也会造成循环引用，这使用我们最好采用[JSContext currentContext]来获取当前的JSContext:
//         */
//        [JSContext currentContext];
//        NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
//        NSString *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dictionary = %@",dictionary);
//        
//        //        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
//        //        myWebVC.mDict = dictionary;
//        //        [weakSelf.navigationController pushViewController:myWebVC animated:YES];
//    };
    
    
    _jsContext[@"goinshop"] = ^(id obj) {
        ShopGoodsListViewController *vc = [[ShopGoodsListViewController alloc] init];
        vc.shopId = obj;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    _jsContext[@"talk"] = ^(id obj) {
        IMChatViewController *vc = [[IMChatViewController alloc] init];
        vc.targetId = [NSString stringWithFormat:@"%@", obj];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    _jsContext[@"GoodDetialGoBack"]=^()
    {
        //        if (webView.canGoBack) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //        }
        
    };
    _jsContext[@"mycart"]=^()
    {
        [JSContext currentContext];
//        [weakSelf btn_showShoppingCar];
        JiFenShopingCarViewController *vc = [[JiFenShopingCarViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    _jsContext[@"share"]=^(id obj)
    {
        [JSContext currentContext];
        [Toolkit ShareForProject];
        
    };
    
    _jsContext[@"AddToShoppingCar"]=^(id productid,id guigeid,id num,id productName,id guigeName,id price)
    {
//        [JSContext currentContext];
//        @try {
            NSDictionary * productModel=[[NSDictionary alloc] initWithObjectsAndKeys:productid,@"ProductId",guigeid,@"ProductPriceId",num,@"ProductNum",productName,@"ProductName",guigeName,@"ProductPriceName",price,@"ProductPrice", nil];
//            ShoppingCartModel * model=[[ShoppingCartModel alloc] initWithDict:productModel];
//            [ShoppingCartManager AddGood:model];
//        } @catch (NSException *exception) {
//            DLog(@"购物券商城——GoodDetial加入购物车异常");
//        } @finally {
//            [SVProgressHUD showSuccessWithStatus:@"已加入购物车"];
//            _shopingCartArr = [ShoppingCartManager GetShoppingCart];
//            [weakSelf.shoppingCarTableview reloadData];
//            [weakSelf SetInfoWithShoppingCar];
//        }
        
        DataProviderOther *dataProvider = [[DataProviderOther alloc] init];
        [dataProvider setDelegateObject:weakSelf setSucceedBackFunctionName:@"addShopCarFinish:" setFailBackFunctionName:nil];
        [dataProvider SubmitBasketNewWithlist_detail:[Toolkit NSArrayToJsonString:@[productModel]] userid:get_sp(user_ID) type:@"1"];
    };
    _jsContext[@"BuyRightNow"]=^(id productid,id guigeid,id num,id productName,id guigeName,id price)
    {
//        [JSContext currentContext];
        NSMutableDictionary *billDict = [NSMutableDictionary dictionary];
        [billDict setObject:[[NSString stringWithFormat:@"%@",productid] length]>0?productid:@"0" forKey:@"ProductId"];
        [billDict setObject:productName forKey:@"ProductName"];
        [billDict setObject:price forKey:@"ProductPrice"];
        //
        [billDict setObject:[[NSString stringWithFormat:@"%@",guigeid] length]>0?guigeid:@"0" forKey:@"ProductPriceId"];
        [billDict setObject:guigeName forKey:@"ProductPriceName"];
        [billDict setObject:num forKey:@"ProductNum"];
        NSArray * prmArray=[[NSArray alloc] initWithObjects:billDict, nil];
        DataProviderOther *request = [[DataProviderOther alloc] init];
        [request setDelegateObject:weakSelf setSucceedBackFunctionName:@"BuildBillCallBack:" setFailBackFunctionName:nil];
        
//        [request BuildBillWithDetail:[Toolkit NSArrayToJsonString:prmArray] andtype:@"1"];
        [request BuildBillNewWithDetail:[Toolkit NSArrayToJsonString:prmArray] andtype:@"1" list_billid:@"" pointprice:[NSString stringWithFormat:@"%.2lf", [num doubleValue] * [price doubleValue]]];
        
    };
    
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@",exceptionValue);
    };
}

- (void)addShopCarFinish:(NSDictionary *)dict {
    NSLog(@"%@", dict);
    if (RequestSuccess(dict)) {
        
        [SVProgressHUD showSuccessWithStatus:@"已加入购物车"];
    } else {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", dict[@"error"]]];
    }
}
-(void)BuildBillCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    if (RequestSuccess(dict)) {
        JiFenOrderEnterViewController *vc = [[JiFenOrderEnterViewController alloc] init];
        vc.data = dict[@"data"];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    ELog(dict);
//    if (RequestSuccess(dict)) {
//        
//        SubmitJiFenOrderViewController * submitOrderVC=[[SubmitJiFenOrderViewController alloc] init];
//        submitOrderVC.orderDetial=dict[@"data"];
//        [self.navigationController pushViewController:submitOrderVC animated:YES];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
//    }
    
}
-(void)BuildShoppingCarView
{
    UIView *shoppingCarView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    shoppingCarView.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(15, 6, 100, 20)];
    
    lbl_title.text=@"已添加商品";
    
    [shoppingCarView addSubview:lbl_title];
    
    UILabel *lbl_canhefei=[[UILabel alloc] initWithFrame:CGRectMake(lbl_title.frame.origin.x+lbl_title.frame.size.width, 10, 100, 14)];
    lbl_canhefei.text=@"";
    
    lbl_canhefei.textColor=[UIColor grayColor];
    
    self.lbl_shoppingCarNum=lbl_canhefei;
    [shoppingCarView addSubview:self.lbl_shoppingCarNum];
    
    self.shoppingCarvVew=shoppingCarView;
    
    
    UITableView * tb_shoppingcar=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, _ShopingCartCELLHEIGHT * 4)];
    
    tb_shoppingcar.delegate=self;
    
    tb_shoppingcar.dataSource=self;
    
    self.shoppingCarTableview=tb_shoppingcar;
    self.shoppingCarTableview.tableFooterView = [[UIView alloc] init];
    
    
    
    
    shoppingCarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH , 34+self.shoppingCarTableview.frame.size.height);
    [shoppingCarView addSubview:self.shoppingCarTableview];
    shoppingCarView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.shoppingCarvVew];
    //self.shoppingCarvVew.hidden=YES;
    
}
-(void)buildbottom
{
    
    bottomview_backview=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 70)];
    bottomview_backview.backgroundColor=[UIColor whiteColor];
    UIView * itembottomview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    itembottomview.backgroundColor=UIColorFromRGBValue(0xaeaeae);
    UIButton * btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 50)];
    btn_pay.backgroundColor=UIColorFromRGBValue(0xfb0404);
    [btn_pay setTitle:@"去支付" forState:UIControlStateNormal];
    [btn_pay addTarget:self action:@selector(PayForShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [itembottomview addSubview:btn_pay];
    lbl_titleprice=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, 150, 20)];
    lbl_titleprice.text=@"购物车还是空的";
    lbl_titleprice.textColor=[UIColor grayColor];
    [itembottomview addSubview:lbl_titleprice];
    [bottomview_backview addSubview:itembottomview];
    btn_showORHide=[[UIButton alloc] initWithFrame:CGRectMake(10, bottomview_backview.frame.origin.y-30, 60, 60)];
    [btn_showORHide setImage:[UIImage imageNamed:@"guomi512"] forState:UIControlStateNormal];
//    [btn_showORHide setImage:[UIImage imageNamed:@"hui"] forState:UIControlStateSelected];
    btn_showORHide.selected=NO;
    [btn_showORHide addTarget:self action:@selector(btn_showShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomview_backview];
    [self.view addSubview:btn_showORHide];
    bottomview_backview.hidden=YES;
    btn_showORHide.hidden=YES;
    isbottomviewshow=YES;
}

#pragma mark - action

-(void)addShoppingCart
{
    if (self.selectGuige == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择规格"];
    
        return;
    }
    
    [ShoppingCartManager AddGood:[ShoppingCartModel ShoppingCartWithGoodModel:self.goodModel andGuigeModel:self.selectGuige andBuyNum:@"1"]];
    
    [SVProgressHUD showSuccessWithStatus:@"加入成功"];
    [self SetInfoWithShoppingCar];//计算价格
    [self ChangeNumberWith:self.selectGuige.guigeId];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodDetialVCAddGoodSucceed" object:nil];
}

-(void)btn_showShoppingCar
{
    [self setShoppingcarButtonStatue];
    if (!isshoppingCarShow) {
        
        _shopingCartArr = [ShoppingCartManager GetShoppingCart];
        [self.view addSubview:_shoppingCarvVew];
        [self.shoppingCarTableview reloadData];
        
        if (!btn_zhezhao) {
            btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(self.shoppingCarvVew.bounds.size.height)-60)];
            btn_zhezhao.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        }
        
        [self.view addSubview:btn_zhezhao];
        isshoppingCarShow=YES;
        [self.view bringSubviewToFront:btn_showORHide];
        [UIView animateWithDuration:0.3 animations:^{
            btn_showORHide.center=CGPointMake(btn_showORHide.center.x, btn_showORHide.center.y-(self.shoppingCarvVew.bounds.size.height+30));
            self.shoppingCarvVew.center=CGPointMake(self.shoppingCarvVew.center.x, self.shoppingCarvVew.center.y-60-self.shoppingCarvVew.bounds.size.height);
        }];
        bottomview_backview.hidden=NO;
        btn_showORHide.hidden=NO;
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            btn_showORHide.center=CGPointMake(btn_showORHide.center.x, btn_showORHide.center.y+(self.shoppingCarvVew.bounds.size.height+30));
            self.shoppingCarvVew.center=CGPointMake(self.shoppingCarvVew.center.x, self.shoppingCarvVew.center.y+60+self.shoppingCarvVew.bounds.size.height);
            
            //            _shoppingCarvVew.hidden=YES;
        }];
        bottomview_backview.hidden=YES;
        btn_showORHide.hidden=YES;
        [btn_zhezhao removeFromSuperview];
        
        isshoppingCarShow=NO;
    }
    
    
}

-(void)setShoppingcarButtonStatue
{
    if (self.shopingCartArr.count>0) {
        //        [btn_showORHide setImage:[UIImage imageNamed:@"01fanhui_07"] forState:UIControlStateNormal];
        btn_showORHide.selected=NO;
    }
    else
    {
        _lbl_shoppingCarNum.text=[NSString stringWithFormat:@"数量:"];
        
        //        [btn_showORHide setImage:[UIImage imageNamed:@"01fanhui_07"] forState:UIControlStateNormal];
        btn_showORHide.selected=YES;
    }
}




-(void)PayForShoppingCar:(UIButton *)sender
{
    if (self.shopingCartArr.count>0) {
        [self buildBill];
    }
    else
    {
//        [YJXStatusHUD showError:@"请选择商品后进行支付"];?
        return;
    }
    
    //    SubmitOrderViewController * submitOrderVC=[[SubmitOrderViewController alloc] init];
    //
    //    [self.navigationController pushViewController:submitOrderVC animated:YES];
}
#pragma mark - data source

-(void)buildBill
{
    @try {
        if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
            
            //            [SVProgressHUD showWithStatus:@"创建订单。。。" maskType:SVProgressHUDMaskTypeBlack];
            DataProviderOther *request = [[DataProviderOther alloc] init];
            [request setDelegateObject:self setSucceedBackFunctionName:@"BuildBillCallBack:" setFailBackFunctionName:nil];
            NSMutableArray *cartArr = [NSMutableArray array];
            
            for (ShoppingCartModel *model in self.shopingCartArr) {
                [cartArr addObject:[model transToBill]];
            }
            
            [request BuildBillWithDetail:[Toolkit NSArrayToJsonString:cartArr] andtype:@"1"];
        }
    } @catch (NSException *exception) {
        DLog(@"func:buildBill 抛异常");
        
    } @finally {
        
    }
    
}




-(void)SetInfoWithShoppingCar
{
    self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
    _lbl_shoppingCarNum.text=[NSString stringWithFormat:@"共计%lu件商品",(unsigned long)self.shopingCartArr.count];
    if (self.shopingCartArr.count>0) {
        
        lbl_titleprice.text=[NSString stringWithFormat:@"共¥%.2f",[ShoppingCartManager getShoppingCartTotalPrice]];
    }
    else
    {
        lbl_titleprice.text=@"购物车还是空的";
    }
    
}



#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shopingCartArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        ShoppingCartModel * itemModel=self.shopingCartArr[indexPath.row];
        static NSString *CellIdentifier = @"shoppingcarcellTableViewCellIdentifier";
        ShoppingCarCellTableViewCell *itemcell = (ShoppingCarCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        @try {
            
            itemcell  = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCarCellTableViewCell" owner:self options:nil] lastObject];
            itemcell.layer.masksToBounds=YES;
            itemcell.selectionStyle = UITableViewCellSelectionStyleNone;
            itemcell.frame=CGRectMake(itemcell.frame.origin.x, itemcell.frame.origin.y, tableView.frame.size.width, itemcell.frame.size.height);
            itemcell.lbl_title.text=itemModel.ShoppingCartGoodName;
            itemcell.lbl_price.text=itemModel.ShoppingCartGoodPrice;
            itemcell.lbl_num.text=itemModel.ShoppingCartBuyNum;
            itemcell.btn_add.tag=indexPath.row;
            itemcell.btn_jian.tag=indexPath.row;
            [itemcell.btn_add addTarget:self action:@selector(ShoppingCarJiaChangeNum:) forControlEvents:UIControlEventTouchUpInside];
            [itemcell.btn_jian addTarget:self action:@selector(ShoppingCarJianchangeNum:) forControlEvents:UIControlEventTouchUpInside];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        return itemcell;
}

-(void)ShoppingCarJiaChangeNum:(UIButton * )sender
{
    @try {
        ShoppingCartModel *model = self.shopingCartArr[sender.tag];
        [ShoppingCartManager plusGoodNumWithGoodId:model.ShoppingCartGoodId andGuigeId:model.ShoppingCartGuigeId];
//        [self PlusGoodForCaiDanListWithGoodID:model.ShoppingCartGoodId AndguigeId:model.ShoppingCartGuigeId];
        if ([[NSString stringWithFormat:@"%@",model.ShoppingCartGuigeId] isEqualToString:[NSString stringWithFormat:@"%@",self.selectGuige.guigeId]]) {
            [self ChangeNumberWith:model.ShoppingCartGuigeId];
        }
        

    }
    @catch (NSException *exception) {
        NSLog(@"购物车数量改变＋");
    }
    @finally {
        self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
        [_shoppingCarTableview reloadData];
        [self SetInfoWithShoppingCar];
       
    }
}

-(void)ShoppingCarJianchangeNum:(UIButton *)sender
{
    @try {
        ShoppingCartModel *model = self.shopingCartArr[sender.tag];
        [ShoppingCartManager reduceGoodNumWithGoodId:model.ShoppingCartGoodId andGuigeId:model.ShoppingCartGuigeId];
//        [self RdusGoodForCaiDanListWithGoodID:model.ShoppingCartGoodId AndguigeId:model.ShoppingCartGuigeId];
        if ([[NSString stringWithFormat:@"%@",model.ShoppingCartGuigeId] isEqualToString:[NSString stringWithFormat:@"%@",self.selectGuige.guigeId]]) {
            [self ChangeNumberWith:model.ShoppingCartGuigeId];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"购物车数量改变-");
    }
    @finally {
        
        self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
        [_shoppingCarTableview reloadData];
//        [self reLayoutShoppingCart];
        [self SetInfoWithShoppingCar];
        
    }
}


-(void)JianChangeNumber
{
    [ShoppingCartManager reduceGoodNumWithGoodId:self.goodModel.goodId andGuigeId:self.selectGuige.guigeId];
    
    [SVProgressHUD showSuccessWithStatus:@"加入成功"];
    [self SetInfoWithShoppingCar];//计算价格
    [self ChangeNumberWith:self.selectGuige.guigeId];
}







-(NSMutableArray<GuigeModel *> *)guiGeArr
{
    if (_guiGeArr == nil) {
        _guiGeArr = [NSMutableArray array];
    }
    
    return _guiGeArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    _app_.hiddenTabBar;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.selectGuige=[_guiGeArr firstObject];
    [self ChangeNumberWith:self.selectGuige.guigeId];
}
-(void)ChangeNumberWith:(NSString *)guigeid
{
    self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
    BOOL isExist=NO;
    for (NSData *data in self.shopingCartArr) {
        
        ShoppingCartModel *tempModel = (ShoppingCartModel *)data;
        
        //[shoppingCart removeObjectAtIndex:i];
        DLog(@"%@",tempModel.ShoppingCartGoodId);
        if([tempModel.ShoppingCartGoodId isEqualToString:self.goodId])
        {
            if([[NSString stringWithFormat:@"%@",tempModel.ShoppingCartGuigeId] isEqualToString:[NSString stringWithFormat:@"%@",guigeid]])//判断是否是该商品
            {
                isExist=YES;
                NSInteger num = [tempModel.ShoppingCartBuyNum integerValue];
                
                if (num == 0){
                    txt_changeValue.text=@"0";
                    txt_changeValue.hidden=YES;
                    btn_AddToShoppingCar.hidden=NO;
                    return;
                }
                
                txt_changeValue.text=ZY_NSStringFromFormat(@"%ld",(long)num);
                txt_changeValue.hidden=NO;
                btn_AddToShoppingCar.hidden=YES;
                return;
            }
        }
        
        
    }
    if (!isExist) {
        txt_changeValue.hidden=YES;
        btn_AddToShoppingCar.hidden=NO;
    }

}

@end
