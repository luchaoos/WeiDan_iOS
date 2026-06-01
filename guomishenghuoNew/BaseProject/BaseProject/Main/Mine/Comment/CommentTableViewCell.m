//
//  CommentTableViewCell.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

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
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 50, 50)];
    _headImage.image = [UIImage imageNamed:@"tukulvise"];
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 25;
    [self addSubview:_headImage];
    
    _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame)+5, CGRectGetMinY(_headImage.frame)+5, 200, 25)];
    _nameLbl.text = @"";
    _nameLbl.textColor = [UIColor darkGrayColor];
    _nameLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:_nameLbl];
    
    _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame)+5, CGRectGetMaxY(_nameLbl.frame), 200, 20)];
    _timeLbl.text = @"2016-04-23";
    _timeLbl.textColor = [UIColor lightGrayColor];
    _timeLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:_timeLbl];
    
    NSString *commentStr = @"东西不错，好吃";
    CGFloat height = [Toolkit heightWithString:commentStr fontSize:15 width:SCREEN_WIDTH-16];
    _commentLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_headImage.frame)+5, SCREEN_WIDTH-16, height)];
    _commentLbl.text = commentStr;
    _commentLbl.numberOfLines = 0;
    _commentLbl.textColor = [UIColor darkGrayColor];
    _commentLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:_commentLbl];
    
    _guigeLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_commentLbl.frame)+5, 200, 25)];
    _guigeLbl.text = @"";
    _guigeLbl.textColor = [UIColor lightGrayColor];
    _guigeLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:_guigeLbl];
    
    _goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_guigeLbl.frame)+5, 75, 75)];
    _goodImage.image = [UIImage imageNamed:@"tukulvise"];
    [self addSubview:_goodImage];
    
    _shopReply = [[UIView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_goodImage.frame)+5, SCREEN_WIDTH-16, 40)];
    _shopReply.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:_shopReply];
    
    _replyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _replyLbl.text = @"商家回复";
    _replyLbl.textColor = ORANGE_COLOR;
    _replyLbl.font = [UIFont systemFontOfSize:15];
    [_shopReply addSubview:_replyLbl];
    
    _replyContent = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_replyLbl.frame), _shopReply.frame.size.width, 20)];
    _replyContent.text = @"谢谢您的光临，欢迎下次光临！";
    _replyContent.textColor = [UIColor grayColor];
    _replyContent.font = [UIFont systemFontOfSize:14];
    [_shopReply addSubview:_replyContent];
}

@end
