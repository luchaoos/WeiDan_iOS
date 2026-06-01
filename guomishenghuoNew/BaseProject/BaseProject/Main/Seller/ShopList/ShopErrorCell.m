//
//  ShopErrorCell.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/17.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopErrorCell.h"

@interface ShopErrorCell ()<UITextFieldDelegate>

@end

@implementation ShopErrorCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 50, 30)];
        [self.contentView addSubview:_leftLabel];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.tag = 114;
        
        UITextField *textField = [UITextField new];
        [self.contentView addSubview:textField];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftLabel);
            make.left.equalTo(_leftLabel.right).offset(10);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(30);
        }];
        textField.font = [UIFont systemFontOfSize:15];
        textField.tag = 113;
        textField.delegate = self;
    }
    return self;
}

+ (ShopErrorCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *errIdent = @"errIdent";
    ShopErrorCell *cell = [tableView dequeueReusableCellWithIdentifier:errIdent];
    if (!cell) {
        cell = [[ShopErrorCell alloc]init];
    }
    UILabel *leftLable = [cell viewWithTag:114];
    if (indexPath.row == 0) {
        leftLable.text = @"名称";
    }else if (indexPath.row == 1){
        leftLable.text = @"地址";
    }else{
        leftLable.text = @"电话";
    }
    
    UITextField *textField = [cell viewWithTag:113];
    if (indexPath.section == 0) {
        textField.hidden = YES;
        UILabel *rightLabel = [UILabel new];
        [cell.contentView addSubview:rightLabel];
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLable.right).offset(5);
            make.top.equalTo(leftLable);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(30);
        }];
        rightLabel.font = [UIFont systemFontOfSize:15.0];
        rightLabel.backgroundColor = [UIColor magentaColor];
        if (indexPath.row == 1) {
            rightLabel.text = @"临沂市兰山区沂蒙路与上海路交汇颐高上海街二期家家悦超市东";
        }
    }else if (indexPath.section == 1) {
        leftLable.textColor = [UIColor orangeColor];
        if (indexPath.row == 0) {
            textField.placeholder = @"请输入更改的名字";
        }else if (indexPath.row == 1){
            textField.placeholder = @"请输入更改后的地址";
        }else{
            textField.placeholder = @"请输入更改后的电话";
        }
    }
    
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
