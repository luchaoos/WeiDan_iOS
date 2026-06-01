//
//  Toolkit.h
//  Blinq
//
//  Created by Sugar on 13-8-27.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UserInfoModel.h"
#import "Reachability.h"

#define Zy_JudgeObjIsNull(str)      ([Toolkit judgeIsNull:dict[str]])
#define Zy_JudgeIsNull(str)      ([Toolkit judgeIsNull:str])

typedef enum _MYNetworkStatus
{
    NetWorkStatusWiFi,
    NetworkStatusPhone,
    NetworkStatusUnAvaliable
}MYNetworkStatus;

@interface Toolkit : NSObject

+ (BOOL)isEnglishSysLanguage;
+ (BOOL)isSystemIOS7;
+(BOOL)isSystemIOS8;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
//计算指定时间与当前的时间差
+(NSString *) compareCurrentTime:(NSString *) compareDateStr;
//计算年龄根据生日
+(NSString *)calculateAge:(NSString *)birthDay;
//检测网络状态
+ (MYNetworkStatus)checkNetworkState;
/**
 *根据nsstring 和 view的宽度计算高度
 */
+(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width;
/**
 *根据nsstring 和 view的高度计算长度
 */
+(CGFloat)WidthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)heigh;
//返回rgba色值
+(NSMutableArray *)getColorRGBA:(UIColor *) color;
//添加划线api
+(UIImageView *)drawLine:(CGFloat)startX andSY:(CGFloat)startY andEX:(CGFloat)endX andEY:(CGFloat)endY andLW:(CGFloat)lineWidth andColor:(UIColor *)color andView:(UIView *)tempView;

+(NSString *)judgeIsNull:(NSString *)str;
//显示顶部菊花
+(UIActivityIndicatorView*)showJuHua;


#pragma mark Plist
+(id)ReadPlist:(NSString*)FileName ForKey:(NSString *)key;
+(void)writePlist:(NSString*)FileName andContent:(id)content andKey:(NSString *)key;
+(void)delPlist:(NSString *)plist;
#pragma mark - camera

+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

#pragma mark - 打电话
+(void)makeCall:(NSString *)phoneNum;
#pragma mark - time
+(NSString *)GettitleForDate:(NSString *)dateStr;
//根据日期获取周几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
/**
 *  根据颜色返回纯色image
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage*) createImageWithColor: (UIColor*) color;

+ (NSString *)unicodeStringWithString:(NSString *)string;

+ (NSString *)stringWithUnicodeString:(NSString *)string;

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//用户中心设值
+(void)setUserDefaultWithObject:(NSString *)object forKey:(id)key;
//用户中心通过key取值
+(id)getUserDefaultByKey:(NSString *)key;

+(void)ShareForProject;
/**
 *  添加到最顶层的view上
 *
 *  @return <#return value description#>
 */
+(UIView *)topView;
/**
 *  object转jsonString
 *
 *  @param dataObject <#dataObject description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)NSArrayToJsonString:(id)dataObject;

@end
