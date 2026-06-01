//
//  PhotoItemCollectionViewCell.m
//  BaseProject
//
//  Created by 于金祥 on 2016/12/3.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PhotoItemCollectionViewCell.h"

@implementation PhotoItemCollectionViewCell

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
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:self.image];
    
    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height*0.85 , self.contentView.frame.size.width, self.contentView.frame.size.height*0.15)];
    self.detail.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    self.detail.text = @"店铺描述";
    self.detail.textColor=[UIColor whiteColor];
    self.detail.textAlignment=NSTextAlignmentCenter;
    self.detail.font = [UIFont systemFontOfSize:12];
    self.detail.numberOfLines = 1;
    [self.contentView addSubview:self.detail];
    
    
    
    //    self.image_iocn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lbl_price.frame), self.lbl_price.frame.origin.y+5, self.contentView.frame.size.width*0.3, self.lbl_price.frame.size.height-10)];
    //    [self.image_iocn setBackgroundImage:[UIImage imageNamed:@"daokai"] forState:UIControlStateNormal];
    //    [self.image_iocn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.contentView addSubview:self.image_iocn];
}

@end
