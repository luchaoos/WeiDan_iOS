//
//  MingDianTableViewCell.h
//  BaseProject
//
//  Created by 于金祥 on 16/11/2.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MingDianTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UIImageView *starView1;
//@property (nonatomic, strong) UIImageView *starView2;
//@property (nonatomic, strong) UIImageView *starView3;
//@property (nonatomic, strong) UIImageView *starView4;
//@property (nonatomic, strong) UIImageView *starView5;

@property (nonatomic, strong) UIView * starView;
@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UILabel *other;
@property (nonatomic, strong) UILabel *dress;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *distance;

//@property (nonatomic, strong) SellerModel *s_model;

//类方法得到cell对象
+ (MingDianTableViewCell *)cellWithTableView:(UITableView *)tableView;
@end
