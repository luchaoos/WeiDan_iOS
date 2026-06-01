//
//  ShoppingCarCellTableViewCell.h
//  LikeAttention
//
//  Created by 于金祥 on 15/8/18.
//  Copyright (c) 2015年 zykj.LikeAttention. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
@property (weak, nonatomic) IBOutlet UIButton *btn_jian;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;

@end
