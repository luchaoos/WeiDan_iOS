//
//  CollectionTableViewCell.h
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell

@property(nonatomic)UIImageView *goodImage;
@property(nonatomic)UILabel *goodName;
@property(nonatomic)UILabel *goodDetail;
@property(nonatomic)UILabel *goodPrice;
//@property(nonatomic)UILabel *goodDiscount;
@property(nonatomic)UILabel *goodDistance;
@property(nonatomic)UIButton *buy;

+ (CollectionTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
