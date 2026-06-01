//
//  PanBuyTableViewCell.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PanBuyTableViewCell.h"

@implementation PanBuyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 85, 75)];
        [self addSubview:imgView];
        imgView.backgroundColor = [UIColor redColor];
        
        CustomLabel *name = [[CustomLabel alloc]initWithFrame:CGRectMake([Util ReturnViewFrame:imgView Direction:@"X"]+5, 5, 150, 25) withContent:@"必胜客蛋炒饭" font:16.0 andRGBr:49 RGBg:45 RGBb:50 adaptive:NO];
        
        [self addSubview:name];
        CustomLabel *distance = [[CustomLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60-10, 5, 60, 25) withContent:@"200m" font:16.0 andRGBr:177 RGBg:178 RGBb:181 adaptive:NO];
        [self addSubview:distance];
        distance.textAlignment = NSTextAlignmentRight;
        
        CustomLabel *detail = [[CustomLabel alloc]initWithFrame:CGRectMake([Util ReturnViewFrame:imgView Direction:@"X"]+5, [Util ReturnViewFrame:name Direction:@"Y"]-2, 200, 25) withContent:@"[颐高上海街] 精品蛋炒饭一份" font:14.0 andRGBr:177 RGBg:178 RGBb:187 adaptive:NO];
        [self addSubview:detail];
        UILabel *price = [UILabel new];
        [self addSubview:price];
        [price makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name);
            make.bottom.equalTo(imgView);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(25);
        }];
        price.text = @"¥220";
        price.font = [UIFont systemFontOfSize:16.0];
        price.textColor = RGB(218, 100, 54);
        
        UIButton *minus = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:minus];
        [minus makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(price.right).offset(0);
            make.bottom.equalTo(imgView);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];
        minus.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [minus setTitle:@"再减10元" forState:UIControlStateNormal];
        
        UIButton *panic = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:panic];
        [panic makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(distance);
            make.bottom.equalTo(minus.bottom);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        panic.backgroundColor = [UIColor orangeColor];
        [panic setTitle:@"¥210抢" forState:UIControlStateNormal];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
