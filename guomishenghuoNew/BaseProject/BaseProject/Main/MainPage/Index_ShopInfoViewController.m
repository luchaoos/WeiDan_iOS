//
//  Index_ShopInfoViewController.m
//  BaseProject
//
//  Created by 于金祥 on 16/10/27.
//  Copyright © 2016年 zykj. All rights reserved.
//


#import "Index_ShopInfoViewController.h"
#import "IMYWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "lhScanQCodeViewController.h"
#import "Pingpp.h"
#import "DataProviderOther.h"
#import "Index_GoodInfoViewController.h"
#import "LoginViewController.h"
#import "JXMapNavigationView.h"
#import "TXTradePasswordView.h"
#import "PayInShopViewController.h"
#import "PhotoLibraryViewController.h"
#import "PingLunViewController.h"
#import "JuBaoViewController.h"
#import "BigImageShowViewController.h"



@interface Index_ShopInfoViewController ()<UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,TXTradePasswordViewDelegate>
@property(strong,nonatomic)UIWebView* webView;
@property (nonatomic) JSContext *jsContext;
@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;
@end

@implementation Index_ShopInfoViewController
{
    TXTradePasswordView *TXView;
    NSString * payPrice;
    NSString * mymoney;
    NSString * payWay;
    UIActionSheet * alertshopInfo;
    NSString * _shopName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetDetialList];
    _lblLeft.hidden=YES;
    _btnLeft.hidden=YES;
    _imgLeft.hidden=YES;
    payWay=@"";
    payPrice=@"0.00";
    mymoney=@"0.00";
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    self.webView.delegate=self;
    self.webView.scalesPageToFit=NO;
    //    self.webView.scrollView.bounces = NO ;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:_webView];
    NSURL * webUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@Shangjia.aspx?shopid=%@&buyerid=%@",BaseImgUrl,self.shopID,get_sp(user_ID)]];
    [_webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
//    [_webView loadHTMLString:strHTML baseURL:[NSURL URLWithString:LunBoUrl]];
    [self.view bringSubviewToFront:_webView];
    _lblLeft.hidden=YES;
    _btnLeft.hidden=YES;
    _imgLeft.hidden=YES;
}
//-(void)webViewDidFinishLoad:(IMYWebView *)webView
//{
//    
//}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak Index_ShopInfoViewController *weakSelf = self;
//    _jsContext[@"startFunction"] = ^(id obj){
//        //这里通过block回调从而获得h5传来的json数据
//        /*block中捕获JSContexts
//         我们知道block会默认强引用它所捕获的对象，如下代码所示，如果block中直接使用context也会造成循环引用，这使用我们最好采用[JSContext currentContext]来获取当前的JSContext:
//         */
//        [JSContext currentContext];
//        NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dictionary = %@",dictionary);
//        
//        //        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
//        //        myWebVC.mDict = dictionary;
//        //        [weakSelf.navigationController pushViewController:myWebVC animated:YES];
//    };
    
    _jsContext[@"JUMPToShangjia1"] = ^(id obj){
        Index_ShopInfoViewController *vc = [[Index_ShopInfoViewController alloc] init];
        vc.shopID = [NSString stringWithFormat:@"%@", obj];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    _jsContext[@"back"] = ^()
    {
        @try {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    };
    
    _jsContext[@"share"]=^(id obj)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
             [Toolkit ShareForProject];
        });
       
    };
    _jsContext[@"MakeCall"]=^(id obj)
    {
        DLog(@"fenxiang");
        [JSContext currentContext];

        [Toolkit makeCall:(NSString *)obj];
    };
    _jsContext[@"JumpToGoodsDetial"]=^(id obj)
    {
        @try {
            DLog(@"JumpToGoodsDetial");
            [JSContext currentContext];
            //        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"" message:@"准备跳转商品详情页" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            //        [alert show];
            if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
                LoginViewController* loginVC=[[LoginViewController alloc] init];
                [weakSelf.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            Index_GoodInfoViewController * index_goodInfoVC=[[Index_GoodInfoViewController alloc] init];
            index_goodInfoVC.goodID=obj;
            [weakSelf.navigationController pushViewController:index_goodInfoVC animated:YES];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    };
    _jsContext[@"OpenMap"]=^(id Lng,id Lat)
    {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
        
        
        @try {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JSContext currentContext];
                _mapNavigationView = [[JXMapNavigationView alloc]init];
                [weakSelf.mapNavigationView showMapNavigationViewWithtargetLatitude:[Lat floatValue] targetLongitute:[Lng floatValue] toName:@"当前店铺"];
                [weakSelf.view addSubview:weakSelf.mapNavigationView];
            });
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
//        });
    };
    
    _jsContext[@"seeallpinglun"]=^(id shopid,id type)
    {
        @try {
            PingLunViewController * pinglunVC=[[PingLunViewController alloc] init];
            pinglunVC.shopid=shopid;
            pinglunVC.type=type;
            [weakSelf.navigationController pushViewController:pinglunVC animated:YES];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    };
    
    _jsContext[@"jiucuo"]=^(id shopid ,id shopName)
    {
        //        [Toolkit makeCall:obj];
        @try {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _shopName=shopName;
                alertshopInfo=[[UIActionSheet alloc] initWithTitle:@"选择错误类型" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"用户反馈",@"基础信息错误",@"电话空号",@"门店倒闭", @"地理位置错误",nil];
                [alertshopInfo showInView:weakSelf.view];
            });
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    };
    
    _jsContext[@"ShopScanForPay"]=^(id obj)
    {
        DLog(@"ShopScanForPay");
        [JSContext currentContext];
//        lhScanQCodeViewController * sqVC = [[lhScanQCodeViewController alloc]init];
//        //    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
//        [self presentViewController:sqVC animated:YES completion:^{
//            
//        }];
        
        @try {
            PayInShopViewController * payInShopVC=[[PayInShopViewController alloc] init];
            payInShopVC.shopID=weakSelf.shopID;
            payInShopVC.fandian=[obj floatValue];
            [weakSelf.navigationController pushViewController:payInShopVC animated:YES];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
//        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:ZY_NSStringFromFormat(@"请输入支付金额\n优先使用钱包支付(当前余额:%@)",mymoney) message:@"" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
//        [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
////         [[dialog textFieldAtIndex:0] becomeFirstResponder];
//        [dialog show];
        
    };
    _jsContext[@"OpenPhotoLibrary"]=^(id shopid)
    {
        @try {
            if (shopid!=nil) {
                PhotoLibraryViewController * photoLibraryVC=[[PhotoLibraryViewController alloc] init];
                photoLibraryVC.shopID=shopid;
                [weakSelf.navigationController pushViewController:photoLibraryVC animated:YES];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    };
    _jsContext[@"openbigimage"]=^(id path)
    {
        @try {
            if (path!=nil) {
                BigImageShowViewController * bigimgVC=[[BigImageShowViewController alloc] init];
                bigimgVC.imgUrl=ZY_NSStringFromFormat(@"%@",path);
                [weakSelf.navigationController pushViewController:bigimgVC animated:YES];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    };
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@",exceptionValue);
    };
}


-(void)SendErrorMessageCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"已提交，谢谢您的反馈"];
    }
    else
    {
        [YJXStatusHUD showError:@"提交失败，请稍后再试"];
    }
}
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    [[alertView textFieldAtIndex:0] becomeFirstResponder];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex !=0) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        DLog(@"%@",nameField.text);
        
        payPrice=nameField.text;
//        if ([mymoney floatValue]<[payPrice floatValue]) {
            UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信",@"银联", nil];
            [ac_alert showInView:self.view];
//        }
//        else
//        {
//            TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
//            TXView.backgroundColor=[UIColor whiteColor];
//            TXView.TXTradePasswordDelegate = self;
//            [TXView.TF becomeFirstResponder];
//            [self.view addSubview:TXView];
////            if (![TXView.TF becomeFirstResponder])
////            {
//                //成为第一响应者。弹出键盘
//            
////            }
//        }
        
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:alertshopInfo]) {
        NSString * title=@"";
        switch (buttonIndex) {
            case 5:
                return;
                break;
            case 1:
                title=@"基础信息错误";
                break;
            case 2:
                title=@"电话空号";
                break;
            case 3:
                title=@"门店倒闭";
                break;
            case 4:
                title=@"地理位置错误";
                break;
            default:
                break;
        }
        if (buttonIndex!=0) {
            DataProviderOther * dataprovider=[[DataProviderOther alloc] init];
            [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"SendErrorMessageCallBack:" setFailBackFunctionName:nil];
            [dataprovider SendErrorMessageWithShopID:self.shopID  andshopName:_shopName andcategory:title andcontent:@""];
        }
        else
        {
            JuBaoViewController * jubaoVC=[[JuBaoViewController alloc] init];
            jubaoVC.shopId=self.shopID;
            jubaoVC.shopName=_shopName;
            [self.navigationController pushViewController:jubaoVC animated:YES];
        }
        

        
        return;
    }
    
    if (buttonIndex==1) {
       payWay=@"wx";
    }
    if (buttonIndex==0) {
        payWay=@"alipay";
    }
    if (buttonIndex==2) {
        payWay=@"upacp";
    }
    
    TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
    TXView.backgroundColor=[UIColor whiteColor];
    TXView.TXTradePasswordDelegate = self;
    if (![TXView.TF becomeFirstResponder])
    {
        //成为第一响应者。弹出键盘
        [TXView.TF becomeFirstResponder];
    }
    
    
    [self.view addSubview:TXView];
    
}

#pragma mark  密码输入结束后调用此方法
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    NSLog(@"密码 = %@",Password);
    if ([view isEqual:TXView]) {
        [TXView removeFromSuperview];
        DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
        [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"VerifyPWDCallBack:" setFailBackFunctionName:nil];
        [mainrequest CheckPayPasswordWithpaypassword:Password];
//        [YJXStatusHUD showLoading:@"正在验证支付密码..."];
    }
    
}
-(void)VerifyPWDCallBack:(id)dict
{
//    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
//        [YJXStatusHUD showLoading:@"正在获取支付信息..."];
        DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
        [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"GetChargeCallBack:" setFailBackFunctionName:nil];
        [mainrequest DaoDianWithtotalprice:payPrice andchannel:payWay andshopid:self.shopID];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)GetChargeCallBack:(id)dict
{
//    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
        DLog(@"%@",dict);
        if ([NSString stringWithFormat:@"%@",dict[@"data"]].length>5) {
            [Pingpp createPayment:dict[@"data"]
                   viewController:self
                     appURLScheme:kUrlScheme
                   withCompletion:^(NSString *result, PingppError *error) {
                       if ([result isEqualToString:@"success"]) {
                           // 支付成功
                           [YJXStatusHUD showSuccess:@"支付成功"];
                           [self.navigationController popToRootViewControllerAnimated:YES];
                           
                       } else {
                           // 支付失败或取消
                           NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           [YJXStatusHUD showError:@"支付失败"];
                       }
                   }];
        }
        else
        {
            [YJXStatusHUD showSuccess:@"支付成功"];
        }
        
    }
    else
    {
        [YJXStatusHUD showError:@"请求失败"];
    }
}
-(void)GetDetialList
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:@"0" andmaximumRows:@"1" andtype:@"9"];
}

-(void)GetDetitlListCallBack:(id)dict
{
    ELog(dict);
    
    
    if (RequestSuccess(dict)) {
        mymoney=[NSString stringWithFormat:@"%@",dict[@"data"][@"TotalMoney"]];
    }
    //    else
    //    {
    //        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    //    }
}

//- (JXMapNavigationView *)mapNavigationView{
//    if (_mapNavigationView == nil) {
//        _mapNavigationView = [[JXMapNavigationView alloc]init];
//    }
//    return _mapNavigationView;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
}



@end
