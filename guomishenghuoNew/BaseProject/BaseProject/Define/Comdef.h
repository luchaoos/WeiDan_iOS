//
//  Comdef.h
//  YiShengDaoJia
//
//  Created by Wangjc on 16/4/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#ifndef Comdef_h
#define Comdef_h


#import "NoticeKeyDefine.h"
#import "DataProvider.h"


#pragma mark - system layer define

#define Verson  1.0
#define ProjectName @"GuoMiShengHuo"

#ifndef ZYDEBUG
#define ZYDEBUG  //开启debug
#endif

//use dlog to print while in debug model
#ifdef ZYDEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define ELog(a) DLog(@"%@",a)
#else
#define DLog(...)
#define ELog(a)
#endif

#define ZY_NSStringFromFormat(fmt,...)     [NSString stringWithFormat:fmt,##__VA_ARGS__]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define remove_sp(a) [[NSUserDefaults standardUserDefaults] removeObjectForKey:a]
#define get_sp(a) [[NSUserDefaults standardUserDefaults] objectForKey:a]
#define get_Bsp(a) [[NSUserDefaults standardUserDefaults] boolForKey:a]
#define get_Dsp(a) [[NSUserDefaults standardUserDefaults]dictionaryForKey:a]
#define set_sp(a,b) [[NSUserDefaults standardUserDefaults] setObject:b forKey:a]
#define set_Bsp(a,b) [[NSUserDefaults standardUserDefaults] setBool:b forKey:a]
#define sp [NSUserDefaults standardUserDefaults]
#define img(a) [UIImage imageNamed:a]
#define _app_ ((AppDelegate *)[UIApplication sharedApplication].delegate)


// define for UI－－
#define NavigationBar_HEIGHT 44
#define StatusBar_HEIGHT 20
#define TabBar_HEIGHT 54
#define Header_Height   (NavigationBar_HEIGHT + StatusBar_HEIGHT)


#define BACKGROUND_COLOR    [UIColor colorWithRed:234/255.0 green:235/255.0 blue:236/255.0 alpha:1.0]
#define NAVBAR_COLOR   [UIColor colorWithRed:237/255.0 green:109/255.0 blue:0/255.0 alpha:1.0]
#define ITEMS_COLOR      [UIColor whiteColor]
#define ORANGE_COLOR     [UIColor orangeColor]
#define AppMainColor  [UIColor orangeColor]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - define for net
//define for net
#define ServerAddr  ""

#define BaseUrl     @ServerAddr"http://121.40.189.165/WebService/"
#define BaseImgUrl  @ServerAddr"http://121.40.189.165/"

// 本地购物车Key
#define KEYShopingCart     @"shoppingCart"

#define isLogin @"isLogin"
#define user_ID @"user_ID"
#define AddressVCRefresh @"AddressVireControllerRefresh"
#define havePayPassword @"IsSetPayPwd"
#define BigImagePath @"BigImagePath"
#define SmallImagePath @"SmallImagePath"
#define kUrlScheme @"com.zykj.guomishenghuo"

#endif /* Comdef_h */
