//
//  AddressRequest.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/14.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "AddressRequest.h"

#define AddressEntry    @"Order.asmx/Entry"

@implementation AddressRequest

-(void)addressList
{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,AddressEntry];
    
    NSString *json = [self setParam:@[@"function",
                                      @"startRowIndex",
                                      @"maximumRows",
                                      @"userid"]
                          andResult:@[@"SelectAddressPageByUserId",
                                      @"0",
                                      @"1000",
                                      [ProjectTools getUserID]]];
    
    NSDictionary * prm=@{@"args":json};
    DLog(@"%@",prm);
    [self postRequst:url andPrm:prm];
    
    
}

-(void)addAddressWithDetail:(NSString *)addressdetail
                  andAreaid:(NSString *)areaid
                     andLat:(NSString *)lat
                     andLng:(NSString *)lng
                     andSex:(NSString *)sex
                   andPhone:(NSString *)phone
                    andName:(NSString *)name
                andHouseNum:(NSString *)housenum
{
    if (addressdetail && areaid && lat && lng && sex && phone && name && housenum) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,AddressEntry];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"addressdetail",
                                          @"areaid",
                                          @"lat",
                                          @"lng",
                                          @"userid",
                                          @"sex",
                                          @"phone",
                                          @"name",
                                          @"housenum"]
                              andResult:@[@"EditAddress",
                                          @"0",
                                          addressdetail,
                                          areaid,
                                          lat,
                                          lng,
                                          [ProjectTools getUserID],
                                          sex,
                                          phone,
                                          name,
                                          housenum]];
        
        NSDictionary * prm=@{@"args":json};
        DLog(@"%@",prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}


-(void)eidtAddressWithId:(NSString *)addrId
                  Detail:(NSString *)addressdetail
               andAreaid:(NSString *)areaid
                  andLat:(NSString *)lat
                  andLng:(NSString *)lng
                  andSex:(NSString *)sex
                andPhone:(NSString *)phone
                 andName:(NSString *)name
             andHouseNum:(NSString *)housenum

{
    if ([addrId intValue ] == 0) {
        
        DLog(@"addrid can't be 0");
        return;
    }
    
    if (addrId && addressdetail && areaid && lat && lng && sex && phone && name && housenum) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,AddressEntry];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"addressdetail",
                                          @"areaid",
                                          @"lat",
                                          @"lng",
                                          @"userid",
                                          @"sex",
                                          @"phone",
                                          @"name",
                                          @"housenum"]
                              andResult:@[@"EditAddress",
                                          addrId,
                                          addressdetail,
                                          areaid,
                                          lat,
                                          lng,
                                          [ProjectTools getUserID],
                                          sex,
                                          phone,
                                          name,
                                          housenum]];
        
        NSDictionary * prm=@{@"args":json};
        DLog(@"%@",prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}


-(void)delAddressWithID:(NSString *)addrid
{

    
    if (addrid) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,AddressEntry];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id"]
                              andResult:@[@"DeleteAddressById",
                                          addrid]];
        
        NSDictionary * prm=@{@"args":json};
        DLog(@"%@",prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}




@end
