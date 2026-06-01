//
//  HealthMoneyTableViewCell.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "HealthMoneyTableViewCell.h"

#define CellHeight 60

@implementation HealthMoneyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initWithViews];
    }
    return self;
}

-(void)initWithViews{
    _usedWay = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, CellHeight/2)];
    _usedWay.text = @"充值";
    _usedWay.textColor = [UIColor grayColor];
    [self addSubview:_usedWay];

    _time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-10, 0, 100, CellHeight/2)];
    _time.text = @"16-12-20";
    _time.textColor = [UIColor lightGrayColor];
    _time.font = [UIFont systemFontOfSize:15];
    _time.textAlignment = NSTextAlignmentRight;
    [self addSubview:_time];
    
    _usedMoney = [[UILabel alloc] initWithFrame:CGRectMake(10, CellHeight/2, 100, CellHeight/2)];
    _usedMoney.text = @"金额：50";
    _usedMoney.textColor = [UIColor lightGrayColor];
    [self addSubview:_usedMoney];
    
    _integration = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-10, CellHeight/2, 100, CellHeight/2)];
    _integration.text = @"购物券+100";
    _integration.textColor = [UIColor orangeColor];
    _integration.textAlignment = NSTextAlignmentRight;
    [self addSubview:_integration];
}

@end
