//
//  TodayRecommendTableViewCell.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TodayRecommendTableViewCell.h"

#define CellHeight 100
#define Height (CellHeight-16)

@implementation TodayRecommendTableViewCell

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
    
    _goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, CellHeight-16, CellHeight-16)];
    _goodImage.backgroundColor = [UIColor orangeColor];
    _goodImage.image = [UIImage imageNamed:@"tukubaise"];
    [self addSubview:_goodImage];
    
    _goodName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodImage.frame)+8, 8, 200, 25)];
    _goodName.text = @"必胜客蛋炒饭";
//    _goodName.textColor = [UIColor lightGrayColor];
//    _goodName.font = [UIFont systemFontOfSize:14];
    [self addSubview:_goodName];
    
    _goodDetail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodImage.frame)+8, CGRectGetMaxY(_goodName.frame)+5, 200, 25)];
    _goodDetail.text = @"【颐高上海街】精品蛋炒饭一份";
    _goodDetail.textColor = [UIColor lightGrayColor];
    _goodDetail.font = [UIFont systemFontOfSize:14];
    [self addSubview:_goodDetail];
    
    _goodPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodImage.frame)+8, CGRectGetMaxY(_goodDetail.frame)+5, 200, 20)];
    _goodPrice.text = @"￥220";
    _goodPrice.textColor = [UIColor orangeColor];
    _goodPrice.font = [UIFont systemFontOfSize:17];
    [_goodPrice sizeToFit];
    [self addSubview:_goodPrice];
    
    _goodDiscount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodPrice.frame)+8, CGRectGetMaxY(_goodDetail.frame)+5, 200, 20)];
    _goodDiscount.text = @"限时8折起";
    _goodDiscount.textColor = [UIColor orangeColor];
    _goodDiscount.font = [UIFont systemFontOfSize:15];
    _goodDiscount.layer.borderColor = [UIColor orangeColor].CGColor;
    _goodDiscount.layer.borderWidth = 1;
    _goodDiscount.layer.masksToBounds = YES;
    _goodDiscount.layer.cornerRadius = 3;
    [_goodDiscount sizeToFit];
    [self addSubview:_goodDiscount];
    
    _goodDistance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-8, 8, 100, 25)];
    _goodDistance.text = @"<500m";
    _goodDistance.textColor = [UIColor orangeColor];
    _goodDistance.font = [UIFont systemFontOfSize:16];
    _goodDistance.textColor = [UIColor lightGrayColor];
    _goodDistance.font = [UIFont systemFontOfSize:15];
    _goodDistance.textAlignment = NSTextAlignmentRight;
    [self addSubview:_goodDistance];
    
    _goodType = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-8, CGRectGetMaxY(_goodDetail.frame)+5, 100, 25)];
    _goodType.text = @"快餐";
    _goodType.textColor = [UIColor lightGrayColor];
    _goodType.font = [UIFont systemFontOfSize:16];
    _goodType.textAlignment = NSTextAlignmentRight;
    [self addSubview:_goodType];
}

@end
