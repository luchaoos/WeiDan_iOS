//
//  ShangCheng_GoodDetialViewController.m
//  BaseProject
//
//  Created by 于金祥 on 16/11/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShangCheng_GoodDetialViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ShangCheng_GoodDetialViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)UIWebView* webView;
@property (nonatomic) JSContext *jsContext;

@end

@implementation ShangCheng_GoodDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    self.webView.delegate=self;
    self.webView.scalesPageToFit=NO;
    //    self.webView.scrollView.bounces = NO ;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:_webView];
    NSURL * webUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@ShopS.aspx?shopid=%@",BaseImgUrl,self.goodID]];
    [_webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
    //    [_webView loadHTMLString:strHTML baseURL:[NSURL URLWithString:LunBoUrl]];
    _lblLeft.hidden=YES;
    _btnLeft.hidden=YES;
    _imgLeft.hidden=YES;
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak ShangCheng_GoodDetialViewController *weakSelf = self;
    _jsContext[@"startFunction"] = ^(id obj){
        //这里通过block回调从而获得h5传来的json数据
        /*block中捕获JSContexts
         我们知道block会默认强引用它所捕获的对象，如下代码所示，如果block中直接使用context也会造成循环引用，这使用我们最好采用[JSContext currentContext]来获取当前的JSContext:
         */
        [JSContext currentContext];
        NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dictionary = %@",dictionary);
        
        //        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        //        myWebVC.mDict = dictionary;
        //        [weakSelf.navigationController pushViewController:myWebVC animated:YES];
    };
    _jsContext[@"AddToShoppingCar"] = ^(id obj,id obj1 ,id obj2){
        //这里通过block回调从而获得h5传来的json数据
        /*block中捕获JSContexts
         我们知道block会默认强引用它所捕获的对象，如下代码所示，如果block中直接使用context也会造成循环引用，这使用我们最好采用[JSContext currentContext]来获取当前的JSContext:
         */
        [JSContext currentContext];
        NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
        NSString *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dictionary = %@",dictionary);
        
        //        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        //        myWebVC.mDict = dictionary;
        //        [weakSelf.navigationController pushViewController:myWebVC animated:YES];
    };
    _jsContext[@"GoodDetialGoBack"]=^(id obj)
    {
        //        if (webView.canGoBack) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //        }
        
    };
    _jsContext[@"share"]=^(id obj)
    {
        DLog(@"JumpToGoodsDetial");
        [JSContext currentContext];
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"" message:@"准备分享" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        
    };
    
    _jsContext[@"AddToShoppingCar"]=^(id obj,id obj1,id obj2)
    {
        [JSContext currentContext];
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"" message:@"加入购物车" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        
    };
    _jsContext[@"BuyRightNow"]=^(id obj,id obj1,id obj2)
    {
        [JSContext currentContext];
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"" message:@"立即购买" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        
    };
    _jsContext[@"mycart"]=^(id obj)
    {
        [JSContext currentContext];
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"" message:@"显示购物车" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        
    };
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@",exceptionValue);
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
}



@end
