//
//  GoodDetailCellTableViewCell.m
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GoodDetailCellTableViewCell.h"

@interface GoodDetailCellTableViewCell ()

@property(nonatomic) UILabel *goodNumberLab;
@property(nonatomic) UIButton *reduceBtn;
@property(nonatomic) UIButton *plusBtn;

@end

@implementation GoodDetailCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCanChangeGoodNumber:(BOOL)canChangeGoodNumber
{
    _canChangeGoodNumber = canChangeGoodNumber;
    if (_canChangeGoodNumber == YES) {
        self.goodCountLib.hidden = YES;
        
        self.reduceBtn.frame = CGRectMake(SCREEN_WIDTH - 40 - 40 -10, self.goodCountLib.frame.origin.y, 20, 20);
        [self addSubview:_reduceBtn];
        
        self.goodNumberLab.frame = CGRectMake(CGRectGetMaxX(self.reduceBtn.frame), self.reduceBtn.frame.origin.y, 40, self.reduceBtn.frame.size.height);
        ELog(self.goodCountLib.text);
        self.goodNumberLab.text = [self.goodCountLib.text substringFromIndex:1];
        [self addSubview:self.goodNumberLab];
        
        self.plusBtn.frame = CGRectMake(CGRectGetMaxX(self.goodNumberLab.frame), self.reduceBtn.frame.origin.y, 20, self.reduceBtn.frame.size.height);
        [self addSubview:self.plusBtn];
    }
    else
    {
        self.goodCountLib.hidden = NO;
        [self.reduceBtn removeFromSuperview];
        [self.goodNumberLab removeFromSuperview];
        [self.plusBtn removeFromSuperview];
    }
}

-(void)changeCountBtnClick:(UIButton *)sender
{
    NSInteger count = [self.goodNumberLab.text integerValue];
    if (sender == _reduceBtn) {
        if (count > 1) {
            count --;
        }
    }
    else if(sender == _plusBtn)
    {
        count ++;
    }
    
    self.goodNumberLab.text = ZY_NSStringFromFormat(@"%ld",count);
    
}


-(UILabel *)goodNumberLab
{
    if (_goodNumberLab == nil) {
        _goodNumberLab = [[UILabel alloc] init];
        _goodNumberLab.font = [UIFont systemFontOfSize:12];
        _goodNumberLab.textAlignment = NSTextAlignmentCenter;
    }
    
    return _goodNumberLab;
}

-(UIButton *)reduceBtn
{
    if (_reduceBtn == nil) {
        _reduceBtn = [[UIButton alloc] init];
        [_reduceBtn setImage:[UIImage imageNamed:@"-0"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(changeCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _reduceBtn;
}

-(UIButton *)plusBtn
{
    if (_plusBtn == nil) {
        _plusBtn = [[UIButton alloc] init];
        [_plusBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
        [_plusBtn addTarget:self action:@selector(changeCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _plusBtn;
}

@end
