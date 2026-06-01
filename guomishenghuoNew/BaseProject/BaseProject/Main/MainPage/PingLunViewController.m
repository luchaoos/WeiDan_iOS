//
//  PingLunViewController.m
//  BaseProject
//
//  Created by 于金祥 on 2016/12/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PingLunViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DataProviderOther.h"
#import "SubmitTuanGouOrderViewController.h"
#import "JXMapNavigationView.h"
#import "BigImageShowViewController.h"


@interface PingLunViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)UIWebView* webView;
@property (nonatomic) JSContext *jsContext;
@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;

@end

@implementation PingLunViewController
{
    float jifenrate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    jifenrate=0.00;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    self.webView.delegate=self;
    self.webView.scalesPageToFit=NO;
    //    self.webView.scrollView.bounces = NO ;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:_webView];
    NSURL * webUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@Pinglun.aspx?id=%@&type=%@",BaseImgUrl,self.shopid,self.type]];
    [_webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
    //    [_webView loadHTMLString:strHTML baseURL:[NSURL URLWithString:LunBoUrl]];
    _lblLeft.hidden=YES;
    _btnLeft.hidden=YES;
    _imgLeft.hidden=YES;
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    @try {
        _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        __weak PingLunViewController *weakSelf = self;
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
        
        _jsContext[@"back"]=^(id obj)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        };
        _jsContext[@"OpenMap"]=^(id Lng,id Lat)
        {
            DLog(@"OpenMap%@///%@",Lng,Lat);
            [JSContext currentContext];
            [weakSelf.mapNavigationView showMapNavigationViewWithtargetLatitude:[Lat floatValue] targetLongitute:[Lng floatValue] toName:@"当前店铺"];
            [weakSelf.view addSubview:weakSelf.mapNavigationView];
            
        };
        _jsContext[@"share"]=^(id obj)
        {
            [Toolkit ShareForProject];
            
        };
        
        _jsContext[@"MakeCall"]=^(id obj)
        {
            [Toolkit makeCall:obj];
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

    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
    }
    return _mapNavigationView;
}
-(void)BuyRightNowCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        SubmitTuanGouOrderViewController * submitOrderVC=[[SubmitTuanGouOrderViewController alloc] init];
        submitOrderVC.orderDetial=dict[@"data"];
        submitOrderVC.fandian=jifenrate;
        [self.navigationController pushViewController:submitOrderVC animated:YES];
    }
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
