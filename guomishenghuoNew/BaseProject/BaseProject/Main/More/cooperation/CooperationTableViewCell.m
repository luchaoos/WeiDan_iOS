//
//  CooperationTableViewCell.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/12.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CooperationTableViewCell.h"

#define CellHeight 45

@implementation CooperationTableViewCell

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
    
    _starSymbol = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 25, CellHeight)];
    _starSymbol.text = @"*";
    _starSymbol.textColor = [UIColor orangeColor];
    [self addSubview:_starSymbol];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10+25, 0, 100, CellHeight)];
    _title.textColor = [UIColor darkGrayColor];
    _title.font = [UIFont systemFontOfSize:16];
    [self addSubview:_title];
    
    _detail = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150-10, 0, 150, CellHeight)];
    _detail.font = [UIFont systemFontOfSize:14];
    _detail.textAlignment = NSTextAlignmentRight;
    [self addSubview:_detail];
}

@end
