//
//  IndexCateTBCell.m
//  BaseProject
//
//  Created by Wangjc on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IndexCateTBCell.h"

@implementation IndexCateTBCell

- (instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    self.image = [[UIImageView alloc] init];
    //    self.image.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.image];
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"拉萨了带上来看到了";
    //    self.name.backgroundColor = [UIColor orangeColor];
    self.name.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.name];
    
    self.arrows = [[UIImageView alloc] init];
    self.arrows.image = [UIImage imageNamed:@"iconfont-fanhuiyou"];
    [self.contentView addSubview:self.arrows];
    
    self.arrows_switch = [[UISwitch alloc] init];
    //    [self.contentView addSubview:self.arrows_switch];
    
    
    self.type = [[UILabel alloc] init];
    self.type.hidden = YES;
    self.type.text = @"申请中";
    self.type.textColor = [UIColor orangeColor];
    self.type.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.type];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat img_w=self.contentView.frame.size.height*0.6-10;
    
    self.image.frame = CGRectMake(15, 5, img_w,img_w);
    
    self.name.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 15, 7, self.contentView.frame.size.width - CGRectGetMaxX(self.image.frame) - 15 - 3 - 60, 30);
    
    self.arrows.frame = CGRectMake(self.contentView.frame.size.width - 33, 9.5, 25, 25);
    
    self.arrows_switch.frame = CGRectMake(self.contentView.frame.size.width - 7 - 50, 7, 50, 30);
    
    self.type.frame = CGRectMake(self.contentView.frame.size.width - 7 - 50, 7, 50, 30);
}


@end
