//
//  OrderDetailModel.m
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel


+(instancetype)OrderDetailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        @try {
//            OrderDetailModel *model = [[OrderDetailModel alloc] init];
//
//            AddressModel *address =  [[AddressModel alloc] init];
//            address.Address_phone = @"18810375184";
//            address.Address_name = @"奇衡三";
//            address.Address_addr = @"山东省临沂市兰山区沂蒙路与解放路交汇新华书店15楼1506室";
//            
//            model.orderCustomAddress = address;
//            
            
            //订单信息
            self.orderTime = Zy_JudgeObjIsNull(@"BuildTime");
            self.orderState = ZY_NSStringFromFormat(@"%@",Zy_JudgeObjIsNull(@"BillState"));
            self.orderId = ZY_NSStringFromFormat(@"%@",Zy_JudgeObjIsNull(@"Id"));
            if ([Zy_JudgeObjIsNull(@"Type") intValue]==1) {
                float lastPrice=[Zy_JudgeObjIsNull(@"TotalPrice") floatValue];
                
                self.orderPrice = ZY_NSStringFromFormat(@"%.2f",lastPrice);
            }
            else
            {
                self.orderPrice = ZY_NSStringFromFormat(@"%@",Zy_JudgeObjIsNull(@"TotalPrice"));
            }
            self.orderOwerShop = Zy_JudgeObjIsNull(@"ShopName");
            self.orderShopId=Zy_JudgeObjIsNull(@"ShopId");
            self.orderShopPhone=Zy_JudgeObjIsNull(@"ShopPhone");
            self.orderShopAddress=Zy_JudgeObjIsNull(@"ShopAddress");
            self.orderNumber = Zy_JudgeObjIsNull(@"BillNo");
            self.orderType = ZY_NSStringFromFormat(@"%@",Zy_JudgeObjIsNull(@"Type"));
            self.orderPayTime = Zy_JudgeObjIsNull(@"PayTime");
            self.orderBuyCode=Zy_JudgeObjIsNull(@"BuyCode");
            self.orderTuiKuanState=ZY_NSStringFromFormat(@"%@",Zy_JudgeObjIsNull(@"CancleState"));
            
            //地址信息
            NSArray *tempAddressArr = dict[@"AddressList"];
            
            if (tempAddressArr.count > 0) {
                NSDictionary *tempAddressDict = tempAddressArr[0];
                AddressModel *address =  [[AddressModel alloc] initWithDict:tempAddressDict];
//                address.Address_phone = Zy_JudgeIsNull(tempAddressDict[@"Phone"]);
//                address.Address_name = Zy_JudgeIsNull(tempAddressDict[@"Name"]);
//                address.Address_addr = Zy_JudgeIsNull(tempAddressDict[@"AddressDetail"]);
                
                self.orderCustomAddress = address;

            }
           
            
            //商品信息
            NSArray *tempGoodArr = dict[@"BillDetailList"];
            
            [tempGoodArr enumerateObjectsUsingBlock:^(NSDictionary *tempDict, NSUInteger idx, BOOL * _Nonnull stop) {
                
                GoodDetailModel *goodModel = [GoodDetailModel GoodDetailWithDict:tempDict];
                [self.orderGoods addObject:goodModel];
                
            }];
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            return self;
        }
        
        
    }
    
    return self;
}

+(NSString *)getStateStrWithState:(OrderState)orderState
{
    NSString *stateStr = @"";
    
    switch (orderState) {
        case OrderStateUnPay:
        {
            stateStr = @"等待买家付款";
        }
            break;
            
        case OrderStateUnRecv:
        {
            stateStr = @"买家已付款";
        }
            break;
        case OrderStateWaitSend:
        {
            stateStr = @"等待发货";
        }
            break;
            
//        case OrderStateAlreadySend:
//        {
//            stateStr = @"卖家已发货";
//        }
//            break;
            
        case OrderStateFinish:
        {
            stateStr = @"买家确认收货";
        }
            break;
            
        case OrderStateCancel:
        {
            stateStr = @"已取消";
        }
            break;
            
            
        default:
            break;
    }
    
    return stateStr;
}

-(NSMutableArray<GoodDetailModel *> *)orderGoods
{
    if (_orderGoods == nil) {
        _orderGoods = [NSMutableArray array];
    }
    
    return _orderGoods;
}

@end
