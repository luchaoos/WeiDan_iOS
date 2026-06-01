//
//  AddressTableViewCell.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "AddressTableViewCell.h"

#define CellHeight      60

@interface AddressTableViewCell ()
{
}

@property(nonatomic) UIButton *selectBtn;
//@property(nonatomic) UILabel *addressLab;
@property(nonatomic) UIView *editView;
@property(nonatomic) UIButton *editBtn;
@property(nonatomic) UIButton *delBtn;
@end

@implementation AddressTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self buidView];
        
    }
    
    return self;
}

-(void)buidView
{
    [self addSubview:self.selectBtn];
    
    self.editView.center = CGPointMake(SCREEN_WIDTH - 50, CellHeight/2);
    
    self.editBtn.center = CGPointMake(25, CellHeight/2);
    [self.editView addSubview:self.editBtn];
    
    self.delBtn.center = CGPointMake(55, CellHeight/2);
    [self.editView addSubview:self.delBtn];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.editMode == NO) {
        if (selected == YES) {
            _selectBtn.hidden = NO;
        }
        else
        {
            _selectBtn.hidden = YES;
        }
    }
}


#pragma mark - action
-(void)delBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addressCell:DelBtnClick:)]) {
        [self.delegate addressCell:self DelBtnClick:sender];
    }
}

-(void)editBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addressCell:editBtnClick:)]) {
        [self.delegate addressCell:self editBtnClick:sender];
    }
}

-(UIButton *)selectBtn
{
    if (_selectBtn == nil) {
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 25 , 5, 25, 25);
        [_selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    return _selectBtn;
}


-(UIView *)editView
{
    if (_editView == nil) {
        _editView = [[UIView alloc] init];
        _editView.bounds = CGRectMake(0, 0, 70, CellHeight);
        _editView.backgroundColor = [UIColor whiteColor];
    }
    
    return _editView;
}

-(UIButton *)editBtn
{
    if (_editBtn == nil) {
        _editBtn =[[UIButton alloc] init];
        _editBtn.bounds = CGRectMake(0, 0, 25, 25);
        [_editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editBtn;
}

-(UIButton *)delBtn
{
    if (_delBtn == nil) {
        _delBtn =[[UIButton alloc] init];
        _delBtn.bounds = CGRectMake(0, 0, 30, 30);
        
        [_delBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _delBtn;
}


-(void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    if (_editMode == YES) {
        [self addSubview:self.editView];
    }
    else
    {
        [self.editView removeFromSuperview];
    }
}

@end
