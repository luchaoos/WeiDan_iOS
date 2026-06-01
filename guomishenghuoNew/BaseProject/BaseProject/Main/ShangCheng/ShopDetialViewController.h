//
//  ShopDetialViewController.h
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/4/25.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ShoppingCartManager.h"


@interface ShopDetialViewController :BaseViewController
@property (strong, nonatomic)  UITableView *shoppingCarTableview;

@property (strong, nonatomic)  UIView *shoppingCarvVew;
@property (strong, nonatomic)  UILabel *lbl_shoppingCarNum;
@property (strong, nonatomic)  NSString *parentid;

@end
