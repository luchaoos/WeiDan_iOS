//
//  DataProvider.m
//  YiShengDaoJia
//
//  Created by Wangjc on 16/4/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseRequest.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"

#define YZkey @"44d1e04f-fa08-40a2-8258-6356c172225a"
#define uid @"b7d381fb-62aa-404e-824a-10a31d3698ef"

@interface BaseRequest ()
{
    id CallBackObject;
    NSString * successCallBackFunctionName;
    NSString * failCallBackFunctionName;
}
@property(nonatomic) AFHTTPSessionManager *postSessionManager;
@property(nonatomic) AFHTTPSessionManager *getSessionManager;
@end

@implementation BaseRequest


-(instancetype)init
{
    if (self = [super init]) {
        self.useSecurity = YES;
    }
    
    return self;
}
#pragma mark - property
-(AFHTTPSessionManager *)postSessionManager
{
    if (_postSessionManager == nil)
    {
        _postSessionManager = [AFHTTPSessionManager manager];
        _postSessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
        _postSessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
        _postSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        _postSessionManager.requestSerializer.timeoutInterval = 10;
    }
    
    return _postSessionManager;
}

-(AFHTTPSessionManager *)getSessionManager
{
    if (_getSessionManager == nil)
    {
        _getSessionManager = [AFHTTPSessionManager manager];
        _getSessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
        _getSessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
        _getSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        _getSessionManager.requestSerializer.timeoutInterval = 10;
    }
    
    return _postSessionManager;
}

#pragma mark -  callback
- (void)setDelegateObject:(id)cbobject setSucceedBackFunctionName:(NSString *)selectorName setFailBackFunctionName:(NSString *)failselectorName

{
    CallBackObject = cbobject;
    
    successCallBackFunctionName = selectorName;
    
    failCallBackFunctionName=failselectorName;
}

- (void)setDelegateObject:(id)cbobject setFailBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    failCallBackFunctionName = selectorName;
}


#pragma mark - tool function

-(NSString *)setParam:(NSArray *)params andResult:(NSArray *)results
{
    
//    if (params.count != results.count) {
//        return nil;
//    }
    
    NSString *json = @"";
    
    @try {
        if (params && results && params.count == results.count) {
            json = ZY_NSStringFromFormat(@"\"%@\":\"%@\"",params[0],results[0]);
            for (int i = 1; i < params.count ; i++) {
                if ((((NSString *)params[i]).length >=5
                     && [[params[i] substringToIndex:5] isEqualToString:@"list_"])                    ||
                    (((NSString *)params[i]).length >=7
                        && [[params[i] substringToIndex:7] isEqualToString:@"entity_"])) {
                        
                    json = ZY_NSStringFromFormat(@"%@,\"%@\":%@",json,params[i],results[i]);
                }
                else
                {
                    json = ZY_NSStringFromFormat(@"%@,\"%@\":\"%@\"",json,params[i],results[i]);
                    
                }
            }
            //添加key
            json = ZY_NSStringFromFormat(@"\"key\":\"%@\",\"uid\":\"%@\",%@",YZkey,uid,json);
            //添加｛｝
            json = ZY_NSStringFromFormat(@"{%@}",json);
            DLog(@"%@",json);
            return [self encryptionStr:json];
//            return [SecurityUtil encryptAESData:[NSString stringWithFormat:@"%lu&%@",(unsigned long)json.length,json]];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return json;
}


-(NSString *)userSetParam:(NSArray *)params andResult:(NSArray *)results
{
    NSString *json = @"";
    
    @try {
        if (params && results && params.count == results.count) {
            json = ZY_NSStringFromFormat(@"\"%@\":\"%@\"",params[0],results[0]);
            for (int i = 1; i < params.count ; i++) {
                if ((((NSString *)params[i]).length >=5 && [[params[i] substringToIndex:5] isEqualToString:@"list_"])/*json字符串 不加“”*/
                    || (((NSString *)params[i]).length >=7 && [[params[i] substringToIndex:7] isEqualToString:@"entity_"])) {
                    json = ZY_NSStringFromFormat(@"%@,\"%@\":%@",json,params[i],results[i]);
                }
                else
                {
                    json = ZY_NSStringFromFormat(@"%@,\"%@\":\"%@\"",json,params[i],results[i]);
                    
                }
            }
            //添加key
            json = ZY_NSStringFromFormat(@"\"key\":\"%@\",\"uid\":\"%@\",%@",YZkey,uid,json);
            
            //添加userid
            json = ZY_NSStringFromFormat(@"%@,\"userid\":\"%@\"",json,get_sp(user_ID));
            
            //添加｛｝
            json = ZY_NSStringFromFormat(@"{%@}",json);
            DLog(@"%@",json);
            return [self encryptionStr:json];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return json;
}




-(NSString *)setParamWithNoEncry:(NSArray *)params andResult:(NSArray *)results
{
    
    NSString *json = @"";
    
    @try {
        if (params && results && params.count == results.count) {
            json = ZY_NSStringFromFormat(@"\"%@\":\"%@\"",params[0],results[0]);
            for (int i = 1; i < params.count ; i++) {
                json = ZY_NSStringFromFormat(@"%@,\"%@\":\"%@\"",json,params[i],results[i]);
            }
            //添加key
            json = ZY_NSStringFromFormat(@"\"key\":\"%@\",\"uid\":\"%@\",%@",YZkey,uid,json);
            //添加｛｝
            json = ZY_NSStringFromFormat(@"{%@}",json);
            DLog(@"%@",json);
            return json;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return json;
}

-(NSString *)encryptionStr:(NSString *)str
{
    if (self.useSecurity == NO) {
        return str;
    }
    else
    {
        NSString *securityStr;
        securityStr = [SecurityUtil encryptAESData:[NSString stringWithFormat:@"%lu&%@",(unsigned long)str.length,str]];
        return securityStr;
    }
    
}

#pragma mark - netWork request


-(void)postRequst:(NSString *)url andPrm:(NSDictionary *)prm
{
    
    [self.postSessionManager POST:url parameters:prm progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        
//        //进度显示
//        if ([[[UIDevice currentDevice] systemVersion]floatValue] < 8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        {
//            NSURLSessionTask *tempSession = (NSURLSessionTask *)uploadProgress;
//            
//            DLog(@"%lf",1.0 *tempSession.countOfBytesSent / tempSession.countOfBytesExpectedToSend);
//        }
//        else if([[[UIDevice currentDevice] systemVersion]floatValue] >= 8.0)
//        {
//            DLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//        }
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(successCallBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        
        NSLog(@"Post success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);  //这里打印错误信息
        SEL func_selector = NSSelectorFromString(failCallBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:error];
        }else{
            NSLog(@"回调失败...");
        }
        //        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}


-(void)getRequst:(NSString *)url andPrm:(NSDictionary *)prm
{
    
    [self.getSessionManager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                            
                            NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
                            id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            
                            SEL func_selector = NSSelectorFromString(successCallBackFunctionName);
                            if ([CallBackObject respondsToSelector:func_selector]) {
                                NSLog(@"回调成功...");
                                [CallBackObject performSelector:func_selector withObject:dict];
                            }else{
                                NSLog(@"回调失败...");
                            }
                            
                            NSLog(@"get success");
                            
                        }
     
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                            SEL func_selector = NSSelectorFromString(failCallBackFunctionName);
                            if ([CallBackObject respondsToSelector:func_selector]) {
                                NSLog(@"回调成功...");
                                [CallBackObject performSelector:func_selector withObject:error];
                            }else{
                                NSLog(@"回调失败...");
                            }
                            
                            NSLog(@"%@",error);  //这里打印错误信息
                            //             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                        }];
}



@end
