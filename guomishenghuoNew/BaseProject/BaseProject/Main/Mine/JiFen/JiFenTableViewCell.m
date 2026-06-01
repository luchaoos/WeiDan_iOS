//
//  JiFenTableViewCell.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "JiFenTableViewCell.h"

#define CellHeight 50

@implementation JiFenTableViewCell

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
    _jifenWay = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 150, CellHeight/2)];
    _jifenWay.font = [UIFont systemFontOfSize:15];
    _jifenWay.textColor = [UIColor grayColor];
    [self addSubview:_jifenWay];
    
    _jifentime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150-8, 0, 150, CellHeight/2)];
    _jifentime.font = [UIFont systemFontOfSize:15];
    _jifentime.textAlignment = NSTextAlignmentRight;
    _jifentime.textColor = [UIColor lightGrayColor];
    [self addSubview:_jifentime];
    
    _jifendetail = [[UILabel alloc] initWithFrame:CGRectMake(8, CellHeight/2, 150, CellHeight/2)];
    _jifendetail.font = [UIFont systemFontOfSize:15];
    _jifendetail.textColor = [UIColor lightGrayColor];
    [self addSubview:_jifendetail];
    
    _jifenmoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150-8, CellHeight/2, 150, CellHeight/2)];
    _jifenmoney.font = [UIFont systemFontOfSize:15];
    _jifenmoney.textAlignment = NSTextAlignmentRight;
    _jifenmoney.textColor = ORANGE_COLOR;
    [self addSubview:_jifenmoney];
}

@end
