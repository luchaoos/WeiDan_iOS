//
//  AppDelegate.m
//  BaseProject
//
//  Created by Wangjc on 16/6/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarViewController.h"
#import "FirstScrollController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import "CCLocationManager.h"
#import "DataProviderOther.h"
#import "APIKey.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "Pingpp.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "JPUSHService.h"
#import "SetPayPwdViewController.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

#import <RongIMKit/RongIMKit.h>

#define JPUSH_KEY   @"4ef1b297c5daaee999ba832c"


@interface AppDelegate ()
{
    CustomTabBarViewController *_tabBarViewCol;
    FirstScrollController *_firstCol;
    SetPayPwdViewController * _payPWDVC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (get_sp(@"UserName")) {
        if (!get_sp(@"openid")) {
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"fastLoginCallBack:" setFailBackFunctionName:nil];
            [dataProvider fastLoginWithPhone:get_sp(@"UserName")];
        }
        
    }
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        set_sp(@"location_lat", ZY_NSStringFromFormat(@"%f",locationCorrrdinate.latitude));
        set_sp(@"location_lng", ZY_NSStringFromFormat(@"%f",locationCorrrdinate.longitude));
    } withAddress:^(NSString *addressString) {
        set_sp(@"addressString",[addressString stringByReplacingOccurrencesOfString:@"(null)" withString:@""]);
    } withCityBlock:^(NSString *addressString) {
        set_sp(@"location_City", addressString);
        [self GetCityInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetLocationSuccess" object:nil];
        //初始化极光
        [self initJPushWithLaunchOptions:launchOptions];
    }];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:0.1];
    [SVProgressHUD setFadeOutAnimationDuration:0.1];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//
//    [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
//        set_sp(@"location_City", addressString);
//        [self GetCityInfo];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"GetLocationSuccess" object:nil];
//        //初始化极光
//        [self initJPushWithLaunchOptions:launchOptions];
//    }];
    
    [[RCIM sharedRCIM] initWithAppKey:@"qd46yzrfqeasf"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView1:) name:@"changeRootView1" object:nil];
    [self initUI];
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"18bb05e65f470"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {//wxf9c6e606334f9a0d
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxf9c6e606334f9a0d"
                                       appSecret:@"b4195abc2b5e99d7d31c4591606a9545"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"101359783"
                                      appKey:@"9998aece55c610fa5073b966f133d13d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    [self configureAPIKey];//配置高德地图的key
    
    [self ConfigurePgyer];//配置蒲公英
    
    
    [self clearBadge:application];
    return YES;
}



-(void)GetCityInfo
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetCityInfoCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetCityInfo:get_sp(@"location_City")];
}
-(void)GetCityInfoCallBack:(id)dict
{
    @try {
        if (RequestSuccess(dict)) {
            DLog(@"%@",dict);
            
            if (get_sp(@"city_Id")==nil) {
                
            }else
            {
                if ([[NSString stringWithFormat:@"%@",get_sp(@"city_Id")] isEqualToString:[NSString stringWithFormat:@"%@",dict[@"data"][@"Id"]]]) {
                    return;
                }
            }
            set_sp(@"city_Id", dict[@"data"][@"Id"]);
            set_sp(@"city_Name", dict[@"data"][@"Name"]);
        }
    } @catch (NSException *exception) {
        set_sp(@"city_Id", @"30887");
        set_sp(@"city_Name", @"临沂市");
    } @finally {
        
    }
}

-(void)ConfigurePgyer
{
    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"e6ed6f740522c2bcff3337557830c1ad"];
//    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"e6ed6f740522c2bcff3337557830c1ad"];
}
- (void)configureAPIKey
{
    if ([APIKeyForMap length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKeyForMap;
}

//所有新方法都在此之后添加
//UI

-(void)initUI
{
    /**
     设置根VC
     */
    
    
    _firstCol=[[FirstScrollController alloc]init];
    
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    
    _payPWDVC=[[SetPayPwdViewController alloc] init];
    
    if(self.window == nil)
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        
        self.window.rootViewController =_tabBarViewCol;
    }
    else
    {
        self.window.rootViewController =_firstCol;
    }
    [self.window makeKeyAndVisible];
    
    
    [self registerMobSMS];
}

-(void)registerMobSMS{
    
    [SMSSDK registerApp:@"17f0a37300844" withSecret:@"getVerificationCodeByMethod"];
    [SMSSDK enableAppContactFriends:false];
}


-(void)fastLoginCallBack:(id)dict{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        
        NSDictionary * loginDict = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
        if ([loginDict[@"IsClose"] intValue]!=0) {
            [YJXStatusHUD showError:@"账号已被限制使用，请联系客服"];
            [Toolkit setUserDefaultWithObject:@"NO" forKey:isLogin];
            return;
        }
        //[SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [Toolkit setUserDefaultWithObject:@"YES" forKey:isLogin];
        [Toolkit setUserDefaultWithObject:loginDict[@"Id"] forKey:user_ID];
        set_sp(@"UserName", loginDict[@"UserName"]);
        set_sp(@"PhotoPath", loginDict[@"PhotoPath"]);
        set_sp(@"Phone", loginDict[@"Phone"]);
        set_sp(@"Token", loginDict[@"Token"]);
        //set_sp(@"UserName", loginDict[@"UserName"]);
        //set_sp(@"UserName", loginDict[@"UserName"]);
        //set_sp(@"UserName", loginDict[@"UserName"]);
        //set_sp(@"UserName", loginDict[@"UserName"]);
        set_sp(havePayPassword, loginDict[@"IsSetPayPwd"]);
//        _payPWDVC.isreaister=YES;
        if ([get_sp(havePayPassword) integerValue]==0) {
//            _payPWDVC.isRoot=YES;
//            self.window.rootViewController = _payPWDVC;
//            [self.window makeKeyAndVisible];
        }
        [YJXStatusHUD showSuccess:@"登录成功"];
        
        [[RCIM sharedRCIM] connectWithToken:get_sp(@"Token") success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
        [Toolkit setUserDefaultWithObject:@"NO" forKey:isLogin];
        remove_sp(@"UserName");
        remove_sp(@"PhotoPath");
        remove_sp(@"Phone");
    }
}

-(void)changeRootView1:(id)sender
{
    self.window.rootViewController = _tabBarViewCol;
    [self.window makeKeyAndVisible];
    return;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
//    BOOL result=[ShareSDK ]
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}
#pragma mark - tabbar 操作


- (void)showTabBar
{
    [_tabBarViewCol showTabBar];
}
- (void)hiddenTabBar
{
    [_tabBarViewCol hideCustomTabBar];
}
-(CustomTabBarViewController *)getTabBar
{
    return _tabBarViewCol;
}


#pragma mark - JPush

-(void) initJPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    //#ifdef ZYDEBUG
    //    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_KEY
    //                          channel:@"Publish channel"
    //                 apsForProduction:NO];
    //#else
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_KEY
                          channel:@"Publish channel"
                 apsForProduction:YES];
    //#endif
    
}

-(void)clearBadge:(UIApplication *)application
{
    
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
#pragma mark - launch
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *alias = ZY_NSStringFromFormat(@"alias_%@",get_sp(user_ID)) ;
//    NSString *alias = @"alias_66" ;
    //    [JPUSHService setTags:nil alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:)  object:self];
    //    DLog(@"Receive notice");
    //    [self getNotice];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    DLog(@"Receive notice");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListRefresh" object:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    DLog(@"Receive notice");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListRefresh" object:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


@end
