//
//  IMRecentCell.h
//  BaseProject
//
//  Created by 陆超 on 2017/7/30.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMRecentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic, copy) void(^btn1Block)();
@property (nonatomic, copy) void(^btn2Block)();

@end
