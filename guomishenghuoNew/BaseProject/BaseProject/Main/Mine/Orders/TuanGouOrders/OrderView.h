//
//  OrderView.h
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
#import "RoundButton.h"

@class OrderView;
@protocol OrderViewDelegate <NSObject>

-(void)OrderView:(OrderView*)orderView clickTableViewIndexPath:(NSIndexPath*)indexPath;
-(void)OrderView:(OrderView*)orderView LeftBtnClick:(UIButton *)sender;
-(void)OrderView:(OrderView*)orderView RightBtnClick:(UIButton *)sender;

@end

@interface OrderView : UIView
@property(nonatomic) OrderDetailModel *orderDetail;
@property(nonatomic) id<OrderViewDelegate> delegate;


+(CGFloat)CalculateViewHeightWithOrderDetail:(OrderDetailModel *)orderDetail;
+(instancetype)OrderViewWithOrderDetail:(OrderDetailModel *)orderDetail;
-(instancetype)initWithOrderDetail:(OrderDetailModel *)orderDetail;


@end
