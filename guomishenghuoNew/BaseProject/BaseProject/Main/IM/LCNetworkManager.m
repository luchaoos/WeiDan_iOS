//
//  LCNetworkManager.m
//  GuoMiShop
//
//  Created by 陆超 on 2017/6/9.
//  Copyright © 2017年 guomi. All rights reserved.
//

#import "LCNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "SecurityUtil.h"
#import <MJExtension/MJExtension.h>


#define VERIFY_KEY @"44d1e04f-fa08-40a2-8258-6356c172225a"
#define UID @"b7d381fb-62aa-404e-824a-10a31d3698ef"

@interface LCNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation LCNetworkManager

singleton_m(Manager)

- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sessionManager = [AFHTTPSessionManager manager];
            _sessionManager.requestSerializer.timeoutInterval = 15.f;
            _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        });
    }
    return _sessionManager;
}


- (void)uploadImage:(NSString *)name
             stream:(NSString *)stream
            success:(success)success
            failure:(failure)failure {
    [self.sessionManager
     POST:[BASE_URL stringByAppendingString:@"ShopIndexService.asmx/UpLoadImage"]
     parameters:@{@"fileName" : name,
                  @"filestream" : stream}
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dict = responseObject;
         if ([dict[@"code"] integerValue] == 200) {
             success(dict[@"data"]);
         } else {
             NSError *error = [[NSError alloc] initWithDomain:dict[@"error"] code:[dict[@"code"] integerValue] userInfo:@{}];
             failure(error);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
     }];
}

- (void)requestWithURL:(NSString *)URL
              function:(NSString *)function
                params:(NSDictionary *)params
               success:(success)success
               failure:(failure)failure {
    
    NSString *url = [BASE_URL stringByAppendingString:URL];
    
    NSMutableDictionary *tParams = params.mutableCopy;
    tParams[@"function"] = function;
    tParams[@"key"] = VERIFY_KEY;
    tParams[@"uid"] = UID;
    NSString *paramStr = [self encryptParams:[self formatParams:tParams.copy]];
    
    
    [self.sessionManager
     POST:url
     parameters:@{@"args" : paramStr}
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dict = responseObject;
         if ([dict[@"code"] integerValue] == 200) {
             success(dict[@"data"]);
         } else {
             NSError *error = [[NSError alloc] initWithDomain:dict[@"error"] code:[dict[@"code"] integerValue] userInfo:@{}];
             failure(error);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
     }];
}

- (void)requestWithBaseURL:(NSString *)baseURL
                       URL:(NSString *)URL
                  function:(NSString *)function
                    params:(NSDictionary *)params
                   success:(success)success
                   failure:(failure)failure {
    
    NSString *url = [baseURL stringByAppendingString:URL];
    
    NSMutableDictionary *tParams = params.mutableCopy;
    tParams[@"function"] = function;
    tParams[@"key"] = VERIFY_KEY;
    tParams[@"uid"] = UID;
    NSString *paramStr = [self encryptParams:[self formatParams:tParams.copy]];
    
    
    [self.sessionManager
     POST:url
     parameters:@{@"args" : paramStr}
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dict = responseObject;
         if ([dict[@"code"] integerValue] == 200) {
             success(dict[@"data"]);
         } else {
             NSError *error = [[NSError alloc] initWithDomain:dict[@"error"] code:[dict[@"code"] integerValue] userInfo:@{}];
             failure(error);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
     }];
}

- (NSString *)formatParams:(NSDictionary *)params {
    NSString *json = @"";
    if (params && params.allKeys.count > 0) {
        json = [params mj_JSONString];
    }
    return json;
}

- (NSString *)encryptParams:(NSString *)paramsStr {
    NSString *securityStr;
    securityStr = [SecurityUtil encryptAESData:[NSString stringWithFormat:@"%lu&%@", (unsigned long)paramsStr.length, paramsStr]];
    return securityStr;
}

@end
