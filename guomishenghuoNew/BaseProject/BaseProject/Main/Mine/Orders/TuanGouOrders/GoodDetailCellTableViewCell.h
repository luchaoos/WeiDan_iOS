//
//  GoodDetailCellTableViewCell.h
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GoodDetailHeight    90

@interface GoodDetailCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodSpecs;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;

@property (weak, nonatomic) IBOutlet UILabel *goodCountLib;

@property(nonatomic) BOOL canChangeGoodNumber;

@end
