//
//  MingDianTableViewCell.m
//  BaseProject
//
//  Created by 于金祥 on 16/11/2.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MingDianTableViewCell.h"

@implementation MingDianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _logoView = [UIImageView new];
        _logoView.layer.cornerRadius = 8;
        _logoView.layer.masksToBounds = YES;
        _logoView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_logoView];
        [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.and.top.mas_equalTo(10);
        }];
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.text = @"哈根达斯";
        _nameLabel.textColor = RGB(32, 32, 32);
        _nameLabel.font=[UIFont systemFontOfSize:13];
        [_nameLabel sizeToFit];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 30));
            make.top.mas_equalTo(_logoView);
            make.left.equalTo(_logoView.mas_right).offset(10);
        }];
        
        //        _starView1 = [UIImageView new];
        //        [self.contentView addSubview:_starView1];
        //        [_starView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.size.mas_equalTo(CGSizeMake(15, 15));
        //            make.left.equalTo(_nameLabel);
        //            make.top.equalTo(_nameLabel.bottom).offset(5);
        //        }];
        //        _starView2 = [UIImageView new];
        //        [self.contentView addSubview:_starView2];
        //        [_starView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.size.equalTo(_starView1);
        //            make.left.equalTo(_starView1.right).offset(2);
        //            make.top.equalTo(_starView1);
        //        }];
        //        _starView3 = [UIImageView new];
        //        [self.contentView addSubview:_starView3];
        //        [_starView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.size.equalTo(_starView1);
        //            make.left.equalTo(_starView2.right).offset(2);
        //            make.top.equalTo(_starView1);
        //        }];
        //        _starView4 = [UIImageView new];
        //        [self.contentView addSubview:_starView4];
        //        [_starView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.size.equalTo(_starView1);
        //            make.left.equalTo(_starView3.right).offset(2);
        //            make.top.equalTo(_starView1);
        //        }];
        //        _starView5 = [UIImageView new];
        //        [self.contentView addSubview:_starView5];
        //        [_starView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.size.equalTo(_starView1);
        //            make.left.equalTo(_starView4.right).offset(2);
        //            make.top.equalTo(_starView1);
        //        }];
        //        NSArray *imgArr = [NSArray arrayWithObjects:_starView1, _starView2, _starView3, _starView4, _starView5, nil];
        //        for (UIImageView *imgView in imgArr) {
        //            imgView.image = [UIImage imageNamed:@"sch"];
        //        }
        //
        _starView=[UIView new];
        [self.contentView addSubview:_starView];
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 18));
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom);
        }];
        //        _starView=[[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_logoView.frame),CGRectGetMaxY(_nameLabel.frame)+5,100,15) numberOfStars:5];
        //        _starView.scorePercent = 1;
        //        _starView.allowIncompleteStar = NO;
        //        _starView.hasAnimation = YES;
        [self.contentView addSubview:_starView];
        
        _other = [UILabel new];
        [self.contentView addSubview:_other];
        _other.text = @"其他饮品";
        //        [_other sizeToFit];
        _other = [UILabel new];
        [self.contentView addSubview:_other];
        _other.text = @"其他饮品";
        //        [_other sizeToFit];
        _other.font=[UIFont systemFontOfSize:12];
        _other.textColor = RGB(195, 195, 195);
        [_other mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 23));
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_starView.mas_bottom).offset(5);
            make.bottom.equalTo(_logoView);
        }];
        
        _price = [UILabel new];
        _price.text = @"人均$400";
        _price.font=[UIFont systemFontOfSize:12];
        [_price sizeToFit];
        _price.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_price];
        _price.textColor = RGB(195, 195, 195);;
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 20));
            make.top.equalTo(_starView.mas_top).offset(0);
            make.right.mas_equalTo(-10);
        }];
        
        _distance = [UILabel new];
        _distance.text = @"<400m";
        [_distance sizeToFit];
        _distance.font=[UIFont systemFontOfSize:12];
        _distance.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_distance];
        _distance.textColor = RGB(195, 195, 195);;
        
        [_distance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 20));
            make.right.equalTo(_price);
            make.bottom.equalTo(_other);
            make.top.equalTo(_starView.mas_bottom).offset(5);
        }];
        
        _score = [UILabel new];
        [self.contentView addSubview:_score];
        _score.text = @"100评价";
        [_score sizeToFit];
        _score.font=[UIFont systemFontOfSize:11];
        _score.textColor = RGB(195, 195, 195);
        [_score mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.equalTo(_starView.mas_right).offset(5);
            make.right.equalTo(_price.mas_left).offset(0);
            make.top.equalTo(_starView.mas_top).offset(0);
        }];
        _dress = [UILabel new];
        _dress.text = @"颐高上海街";
        _dress.textColor = RGB(195, 195, 195);;
        [self.contentView addSubview:_dress];
        [_dress sizeToFit];
        [_dress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
            make.left.equalTo(_other.mas_right);
            make.right.equalTo(_distance.mas_left).offset(0);
            make.bottom.equalTo(_other);
            make.top.equalTo(_starView.mas_bottom).offset(5);
        }];
        
        //        struct utsname systemInfo;
        //        uname(&systemInfo);
        //        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        //        if ([deviceString isEqualToString:@"iPhone4,1"]||[deviceString isEqualToString:@"iPhone5,1"]||[deviceString isEqualToString:@"iPhone5,2"]||[deviceString isEqualToString:@"iPhone6,1"]||[deviceString isEqualToString:@"iPhone6,2"]) {
        //            _nameLabel.font = [UIFont systemFontOfSize:18];
        //            _score.font = [UIFont systemFontOfSize:13];
        //            _dress.font = [UIFont systemFontOfSize:13];
        //            _price.font = [UIFont systemFontOfSize:13];
        //            _distance.font = [UIFont systemFontOfSize:13];
        //        }else{
        //            _nameLabel.font = [UIFont systemFontOfSize:18];
        //            _score.font = [UIFont systemFontOfSize:16];
        //            _dress.font = [UIFont systemFontOfSize:16];
        //            _price.font = [UIFont systemFontOfSize:16];
        //            _distance.font = [UIFont systemFontOfSize:16];
        //        }
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _score.font = [UIFont systemFontOfSize:12];
        _dress.font = [UIFont systemFontOfSize:12];
        _price.font = [UIFont systemFontOfSize:12];
        _distance.font = [UIFont systemFontOfSize:12];
        
    }
    return self;
}

+ (MingDianTableViewCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ident = @"cell";
    MingDianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[MingDianTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident
                ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
