//
//  DataProvider.h
//  YiShengDaoJia
//
//  Created by Wangjc on 16/4/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject

#ifndef BaseUrl
#define BaseUrl @"http://pp.xiangdaole.com/WebService/"
#endif

#define RequestSuccess(dict)  ([dict[@"code"] intValue]== 200)
#define ErrorMessage(dict)     (dict[@"error"])
#define DataTotal(dict)      ([dict[@"recordcount"] intValue])

@property(nonatomic) BOOL useSecurity; //default is Yes

/**
 *  设置回调方法
 *
 *  @param cbobject         <#cbobject description#>
 *  @param selectorName     成功回调
 *  @param failselectorName 失败回调
 */
- (void)setDelegateObject:(id)cbobject setSucceedBackFunctionName:(NSString *)selectorName setFailBackFunctionName:(NSString *)failselectorName;
/**
 *  post请求
 *
 */
-(void)postRequst:(NSString *)url andPrm:(NSDictionary *)prm;
/**
 *  get请求
 *
 */
-(void)getRequst:(NSString *)url andPrm:(NSDictionary *)prm;
/**
 * 上传nsdata的数据
 *
 */
-(void)UploadImg:(NSString *)url andPrm:(NSDictionary *)prm andData:(NSData *)data;

/**
 *  根据参数设置json字符串
 *
 *  @param params 参数名
 *  @param results 值
 */
-(NSString *)setParam:(NSArray *)params andResult:(NSArray *)results;

/**
 *  根据参数设置json字符串
 *
 *  @param params 参数名
 *  @param results 值
 */
-(NSString *)setParamWithNoEncry:(NSArray *)params andResult:(NSArray *)results;

/**
 *  加密
 *
 *
 */
-(NSString *)encryptionStr:(NSString *)str;
/**
 *
 * 设置开始网络请求时延迟提示“加载中”的功能
 * 即：如果在设置的时间内 数据返回则不提示 如果数据未返回 则会出现一个提示框
 *
 */
-(void)setDelayReminderWithDuration:(NSTimeInterval)duration andReminderStr:(NSString *)reminderStr;
/**
 * 设置进度回调
 */
-(void)setdelegateObject:(id)cbobject setProgressFunctionName:(NSString *)selectorName;
/**
 * 取消所有请求
 */
-(void)CancelPostAllRequest;

-(void)CancelGetAllRequest;

-(void)cancelGetRequest;

-(void)cancelPostRequest;

-(NSString *)userSetParam:(NSArray *)params andResult:(NSArray *)results;

@end
