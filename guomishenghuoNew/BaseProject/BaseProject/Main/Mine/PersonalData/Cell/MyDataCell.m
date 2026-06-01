//
//  MyDataCell.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MyDataCell.h"

@implementation MyDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [UILabel new];
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 30)];
        _leftLabel.font = [UIFont systemFontOfSize:16];
        _leftLabel.textColor = RGB(61, 62, 63);
        [self.contentView addSubview:_leftLabel];
//        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-5, 5, 100, 30)];
//        _rightLabel.backgroundColor = [UIColor clearColor];
//        _rightLabel.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:_rightLabel];
    }
    return self;
}
- (MyDataCell *)cellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"ident";
    MyDataCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[MyDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _leftLabel.text = @"头像";
            CGRect rect = _leftLabel.frame;
            rect.origin = CGPointMake(10, 30);
            _leftLabel.frame = rect;
        }else{
            _leftLabel.text = @"用户名";
            _rightLabel.text = @"李狗蛋";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
//            _leftLabel.text = @"账号";
//            _rightLabel.text = @"13126608722";
            _leftLabel.text = @"修改密码";
        }else if (indexPath.row == 1){
            _leftLabel.text = @"修改密码";
            _rightLabel.text = @"";
        }else if (indexPath.row == 2){
            _leftLabel.text = @"性别";
        }else if (indexPath.row == 3){
            _leftLabel.text = @"所在城市";
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            _leftLabel.text = @"绑定手机号";
        }else if (indexPath.row == 1){
            _leftLabel.text = @"真实姓名";
        }else if (indexPath.row == 2){
            _leftLabel.text = @"邮政邮编";
        }
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
