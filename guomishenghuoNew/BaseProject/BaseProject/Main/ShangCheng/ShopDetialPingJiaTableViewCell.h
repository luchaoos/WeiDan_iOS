//
//  ShopDetialPingJiaTableViewCell.h
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/4/27.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDetialPingJiaCellModel.h"
#import "LHRatingView.h"

@interface ShopDetialPingJiaTableViewCell : UITableViewCell<ratingViewDelegate>
@property (nonatomic,strong)ShopDetialPingJiaCellModel *model;
//@property (nonatomic,strong)
+(CGFloat)JiSuanCellHeight:(ShopDetialPingJiaCellModel *)model;
-(void)BuildAllCellView;

@end
