//
//  LCNetworkManager.h
//  GuoMiShop
//
//  Created by 陆超 on 2017/6/9.
//  Copyright © 2017年 guomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

#define BASE_URL @"http://121.40.189.165/WebService/"

static NSString *const kShopIndexService = @"ShopIndexService.asmx/Entry";
static NSString *const kCommissionService = @"CommissionService.asmx/Entry";
static NSString *const kShopService = @"ShopService.asmx/Entry";
static NSString *const kFriendService = @"FriendService.asmx/Entry";
static NSString *const kLoginService = @"LoginService.asmx/Entry";

@interface LCNetworkManager : NSObject

singleton_h(Manager)

typedef void (^success)(id responseData);
typedef void (^failure)(NSError *error);

- (void)requestWithURL:(NSString *)URL
              function:(NSString *)function
                params:(NSDictionary *)params
               success:(success)success
               failure:(failure)failure;

- (void)requestWithBaseURL:(NSString *)baseURL
                       URL:(NSString *)URL
                  function:(NSString *)function
                    params:(NSDictionary *)params
                   success:(success)success
                   failure:(failure)failure;

- (void)uploadImage:(NSString *)name
             stream:(NSString *)stream
            success:(success)success
            failure:(failure)failure;
@end
