//
//  Toolkit.m
//  Blinq
//
//  Created by Sugar on 13-8-27.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "Toolkit.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@implementation Toolkit


#pragma mark - add by wangjc


+(void)makeCall:(NSString *)phoneNum
{
    if(phoneNum ==nil||phoneNum.length==0)
    {
        return;
    }
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
//+(void)JumpToSafari:(NSString *)url
//{
//    if (url.length>0) {
//         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
//}



+(UIApplication*)showJuHua
{
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    
    return application;
}

+(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}


//根据字符串计算宽度
+(CGFloat)WidthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)height
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}



+(UIImageView *)drawLine:(CGFloat)startX andSY:(CGFloat)startY andEX:(CGFloat)endX andEY:(CGFloat)endY andLW:(CGFloat)lineWidth andColor:(UIColor *)color andView:(UIView *)tempView
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:tempView.frame];
    [tempView addSubview:imageView];
    
    CGFloat R, G, B,A;
    
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        R = components[0];
        G = components[1];
        B = components[2];
        A = components[3];
    }
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), R,G, B, A);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startX, startY);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endX, endY);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return imageView;
}

+(NSMutableArray *)getColorRGBA:(UIColor *) color
{
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        
        NSMutableArray *rgbaArr = [NSMutableArray array];
        for (int i = 0; i<numComponents; i++) {
            [rgbaArr addObject:[NSString stringWithFormat:@"%lf",components[i]]];
        }
        return rgbaArr;
    }
    else
    {
        return nil;
    }
}



+(NSString *)judgeIsNull:(NSString *)str{
    str = [NSString stringWithFormat:@"%@",str];
    if([str isEqual:@""] || [str isEqual:[NSNull null]] || [str isEqual:@"(null)"]||[str isEqual:@"<null>"]){
        return @"";
    }
    return str;
}


#pragma mark camera utility
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - plist file 

+(id)ReadPlist:(NSString*)FileName ForKey:(NSString *)key
{

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:FileName];

    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"dic is:%@",dic);
    
    if(dic == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        
        dic = [NSDictionary dictionaryWithContentsOfFile:filename];
        return dic[key];
    }
    else
    {
        return dic[key];
    }

}



+(void)writePlist:(NSString*)FileName andContent:(id)content andKey:(NSString *)key
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:FileName];
    
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
   
    
    NSLog(@"dic is:%@",dic);
    
    if(dic == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:content forKey:key];
        [tempDict writeToFile:filename atomically:YES];
    }
    else
    {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dic];
        
        [tempDict setObject:content forKey:key];
        [tempDict writeToFile:filename atomically:YES];
    }
    
}


+(void)delPlist:(NSString *)plist
{
    //清除plist文件，可以根据我上面讲的方式进去本地查看plist文件是否被清除
    NSFileManager *fileMger = [NSFileManager defaultManager];
    
    NSString *xiaoXiPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:plist];
    
    //如果文件路径存在的话
    BOOL bRet = [fileMger fileExistsAtPath:xiaoXiPath];
    
    if (bRet) {
        
        NSError *err;
        
        [fileMger removeItemAtPath:xiaoXiPath error:&err];
    }
}


#pragma mark - time 


+(NSString *)GettitleForDate:(NSString *)dateStr
{
    @try {
        NSString * resultStr=@"";
        
        if (dateStr.length>0) {
            
            NSDate * nowDate=[NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date = [dateFormatter dateFromString:dateStr];
            
            NSTimeInterval a_hour = 60*60;
            
            NSDate *other = [date addTimeInterval: a_hour];
        
            if ([nowDate compare:other]==NSOrderedDescending) {
                
                NSTimeInterval a_day = 24*60*60;
                
                NSDate *othersecond = [[self extractDate:date] addTimeInterval: a_day];
                if ([nowDate compare:othersecond]==NSOrderedDescending) {
                    if ([nowDate compare:[othersecond addTimeInterval:a_day]]==NSOrderedDescending) {
                        if ([nowDate compare:[[othersecond addTimeInterval:a_day] addTimeInterval:a_day] ]==NSOrderedDescending) {
                            [dateFormatter setDateFormat:@"MM月dd日"];
                            NSString *strHour = [dateFormatter stringFromDate:date];
                            return [NSString stringWithFormat:@"%@",strHour];
                        }
                        else
                        {
                            return @"前天发布";
                        }
                    }
                    else
                    {
                        return @"昨天发布";
                    }
                }
                else
                {
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *strHour = [dateFormatter stringFromDate:date];
                    return [NSString stringWithFormat:@"%@",strHour];
                }
            }
            else
            {
                return @"刚刚发布";
            }
        }
        
        return resultStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSString *) compareDateStr
//
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *compareDate = [dateFormatter dateFromString:compareDateStr];
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = @"刚刚";
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+(NSString *)calculateAge:(NSString *)birthDay
{
    if (birthDay == nil || [birthDay isEqual:@""]) {
        return @"";
    }
    NSString *age;
    NSString *now;
    NSInteger numAge;
    now = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSInteger bYear = [[birthDay substringToIndex:4] integerValue];
    NSInteger nYear = [[now substringToIndex:4] integerValue];
    
    NSRange tempRang;
    tempRang.length = 2;
    tempRang.location = 5;
    NSInteger bMonth = [[birthDay substringWithRange:tempRang] integerValue];
    NSInteger nMonth = [[now substringWithRange:tempRang] integerValue];
    
    tempRang.length = 2;
    tempRang.location =8;
    NSInteger bDay = [[birthDay substringWithRange:tempRang] integerValue];
    NSInteger nDay = [[now substringWithRange:tempRang] integerValue];
    
    
    if(bYear > nYear)
        return @"0";
    numAge = nYear - bYear;
    
    if(bMonth>nMonth)//不到生日减一岁
    {
        if(numAge >0)
            numAge--;
    }
    else if(bMonth == nMonth)
    {
        if(bDay > nDay)
        {
            if(numAge >0)
                numAge--;
        }
    }
    
    age = [NSString stringWithFormat:@"%ld",(long)numAge];
    return age;
}

+ (NSDate *)extractDate:(NSDate *)date {
    if (!date) {
        date=[NSDate date];
    }
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}

#pragma mark  - old

+ (BOOL)isSystemIOS7
{
     
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0&&[[[UIDevice currentDevice] systemVersion] floatValue] < 8.0? YES : NO;
}
+ (BOOL)isSystemIOS8
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO;
}



//+ (NSString *)getSystemLanguage
//{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kSystemLanguage];
//}
//
//+ (void)setSystemLanguage:(NSString *)strLanguage
//{
//    if (strLanguage)
//        [[NSUserDefaults standardUserDefaults] setObject:strLanguage forKey:kSystemLanguage];
//}

//+(UIImage *)drawsimiLine:(UIImageView *)imageView
//{
//    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
//    
//    CGFloat lengths[] = {5,5};
//    CGContextRef line = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
//    
//    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
//    CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
//    CGContextAddLineToPoint(line, 310.0, 20.0);
//    CGContextStrokePath(line);
//    
//    return UIGraphicsGetImageFromCurrentImageContext();
//}

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}


#pragma mark - 监测当前网络是否可用

+ (MYNetworkStatus)checkNetworkState
{
    // 1.检测wifi状态
     Reachability *wifi = [Reachability reachabilityForLocalWiFi];

     // 2.检测手机是否能上网络(WIFI\3G\2.5G)
     Reachability *conn = [Reachability reachabilityForInternetConnection];

     // 3.判断网络状态
     if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
         NSLog(@"有wifi");
         
         return NetWorkStatusWiFi;

     } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
         NSLog(@"使用手机自带网络进行上网");
         
         return NetworkStatusPhone;

     } else { // 没有网络
         
         NSLog(@"没有网络");
         return NetworkStatusUnAvaliable;
     }
}


+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}



/**
 *  根据颜色返回纯色image
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


/**
 *  string转uincode string
 *
 *  @param string string
 *
 *  @return uincode string
 */
+ (NSString *)unicodeStringWithString:(NSString *)string {
    NSString *result = [NSString string];
    for (int i = 0; i < [string length]; i++) {
        result = [result stringByAppendingFormat:@"\\u%04x", [string characterAtIndex:i]];
        /*
         因为Unicode用16个二进制位（即4个十六进制位）表示字符，对于小于0x1000字符要用0填充空位，
         所以使用%04x这个转换符，使得输出的十六进制占4位并用0来填充开头的空位。
         */
    }
    return result;
}


/**
 *  unicode string转str
 *
 *  @param string uincode string
 *
 *  @return string
 */
+ (NSString *)stringWithUnicodeString:(NSString *)string {
    NSArray *strArray = [[string substringFromIndex:2] componentsSeparatedByString:@"\\u"];
    NSString *result = [NSString string];
    for (NSString *str in strArray) {
        NSString *tmpStr = [@"0x" stringByAppendingString:str];
        unichar c = strtoul([tmpStr UTF8String], 0, 0);
        /*
         上面两行也可以写成下面一行：
         unichar c = strtoul([str UTF8String], 0, 16);
         */
        result = [result stringByAppendingString:[NSString stringWithCharacters:&c length:1]];
    }
    return result;
}

//颜色生成图片方法
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


#pragma mark ----- NSUserDefaults -----
//用户中心设值
+(void)setUserDefaultWithObject:(NSString *)object forKey:(id)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:object forKey:key];
    
//    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}
//用户中心通过key取值
+(id)getUserDefaultByKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
    
//    id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    return object;
}


+(void)ShareForProject
{
//    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"guomi512@2x"]];
//    //        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"快来下载果米生活吧"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"https://www.pgyer.com/LgYl"]
//                                          title:@"果米商铺分享"
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
//    }

}

+(UIView *)topView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[window.subviews.count - 1];
}

+(NSString *)NSArrayToJsonString:(id)dataObject
{
    
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error: &error];
    
    if (([jsonData length] != 0) && (error == nil)){
        return [[NSString alloc] initWithData:jsonData
                                     encoding:NSUTF8StringEncoding];;
    }else{
        return nil;
    }
}

@end
