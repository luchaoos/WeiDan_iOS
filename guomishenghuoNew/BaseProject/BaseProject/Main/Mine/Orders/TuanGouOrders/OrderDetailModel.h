//
//  OrderDetailModel.h
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodDetailModel.h"
#import "AddressModel.h"

typedef NS_ENUM(NSInteger,OrderState)//购物券商城订单状态
{
    OrderStateUnPay,
    OrderStateWaitSend,//待发货
//    OrderStateAlreadySend,//已发货
    OrderStateUnRecv,//待收货
    OrderStateUnComment,
    OrderStateFinish,//已完成
    OrderStateCancel//已取消
};

typedef NS_ENUM(NSInteger,OrderTuanGouState)//团购订单状态
{
    
    OrderTuanGouStateUnPay,//未支付
    OrderTuanGouStateUnUse,//未使用
    OrderTuanGouStateUnComment,//未评论
//    OrderTuanGouStateTuiKuan,//退款
    OrderTuanGouStatePayOnShop//到店支付
};

typedef NS_ENUM(NSInteger,OrderTuanGouTuiKunState)  //退款状态
{
    OrderTuanGouTuiKunStateNormal,//正常订单，未申请退款的
    OrderTuanGouTuiKunStateApplyTuiKuan,//申请退款，退款中
    OrderTuanGouTuiKunStateTuiKuanFinish,//退款成功
    OrderTuanGouTuiKunStateTuiKuanRejected,//退款被拒绝

};


typedef NS_ENUM(NSInteger,OrderType) {
    OrderTypeTuanGou,
    OrderTypeJiFen
    
};


@interface OrderDetailModel : NSObject
@property(nonatomic) NSString *orderId;
@property(nonatomic) NSString *orderNumber;
@property(nonatomic) NSString *orderTime;//创建时间
@property(nonatomic) NSString *orderPayTime;//付款时间
@property(nonatomic) NSString *orderReviceTime;//收货时间
@property(nonatomic) NSString *orderBuyCode;//券码
@property(nonatomic) NSString *orderShopPhone;
@property(nonatomic) NSString *orderShopId;
@property(nonatomic) NSString *orderShopAddress;

@property(nonatomic) AddressModel *orderCustomAddress;
@property(nonatomic) NSString *orderPrice;
@property(nonatomic) NSString *orderState;//订单状态
@property(nonatomic) NSString *orderTuiKuanState;//退款状态
@property(nonatomic) NSString *orderType;
@property(nonatomic) NSString *orderOwerShop;//商家
@property(nonatomic) NSMutableArray <GoodDetailModel *> *orderGoods;

+(NSString *)getStateStrWithState:(OrderState)orderState;

+(instancetype)OrderDetailWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
