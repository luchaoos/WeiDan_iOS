//
//  IndexCollectionViewCell.m
//  BaseProject
//
//  Created by Wangjc on 16/9/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IndexCollectionViewCell.h"

@implementation IndexCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height *0.7)];
    //    self.image.backgroundColor = [UIColor orangeColor];
//    self.image.layer.masksToBounds = YES;
    [self.contentView addSubview:self.image];
    
    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.image.frame) , self.contentView.frame.size.width, self.contentView.frame.size.height*0.15)];
    //    self.detail.backgroundColor = [UIColor orangeColor];
    self.detail.text = @"店铺描述";
    self.detail.font = [UIFont systemFontOfSize:12];
    self.detail.numberOfLines = 1;
    [self.contentView addSubview:self.detail];
    
    self.lbl_price=[[UILabel alloc] initWithFrame:CGRectMake(self.detail.frame.origin.x, CGRectGetMaxY(self.detail.frame), self.contentView.frame.size.width*0.5, self.contentView.frame.size.height*0.15)];
    self.lbl_price.font = [UIFont systemFontOfSize:11];
    self.lbl_price.numberOfLines=1;
    self.lbl_price.textColor=AppMainColor;
    [self.contentView addSubview:self.lbl_price];
    
//    self.image_iocn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbl_price.frame), self.lbl_price.frame.origin.y+5, self.contentView.frame.size.width*0.3, self.lbl_price.frame.size.height-10)];
//    [self.image_iocn setBackgroundImage:[UIImage imageNamed:@"daokai"] forState:UIControlStateNormal];
//    [self.image_iocn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.contentView addSubview:self.image_iocn];
}

@end
