//
//  TakeOutViewCell.m
//  智慧社区
//
//  Created by 陈程 on 15/5/26.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "TakeOutViewCell.h"
#import "TakeOutModel.h"

@interface TakeOutViewCell()
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UILabel *sold;
@property (nonatomic,weak) UILabel *price;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,weak) UILabel *countLabel;
@property (nonatomic,weak) UIView *countView;
@property (nonatomic,weak) UIButton *addButton;
@property (nonatomic,weak) UIImageView *icon;
@property (nonatomic,strong)UIButton * btn_moreGuiGe;
@end

@implementation TakeOutViewCell

- (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"TakeOutViewCell";
    TakeOutViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左边的图标
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
//        icon.backgroundColor = [UIColor orangeColor];
//        [icon sd_setImageWithURL:[NSURL URLWithString:self.model.iconPath] placeholderImage:[UIImage imageNamed:@"goback"]];
        icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(JumpToGoodDetial)];
        [icon addGestureRecognizer:singleTap1];
        self.icon = icon;
        [self.contentView addSubview:icon];
        //右边添加按钮
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(200*(SCREEN_WIDTH/320), 30, 25, 25)];
//        addButton.backgroundColor = [UIColor orangeColor];
        [addButton setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
        self.addButton = addButton;
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addButton];
        
        
        UIButton *jumpButton = [[UIButton alloc] initWithFrame:CGRectMake(200*(SCREEN_WIDTH/320)-25, 25, 60, 30)];
        [jumpButton setTitle:@"选规格" forState:UIControlStateNormal];
        [jumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        jumpButton.backgroundColor=AppMainColor;
        jumpButton.layer.masksToBounds=YES;
        jumpButton.layer.cornerRadius=15;
        self.btn_moreGuiGe = jumpButton;
        [jumpButton addTarget:self action:@selector(JumpToGoodDetial) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.contentView addSubview:jumpButton];
        
        
        
        
        //计数的view
        UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(180*(SCREEN_WIDTH/320)-20, 30, 100, 25)];
        self.countView = countView;
        [self.contentView addSubview:countView];
        
        UIButton *addCountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        addCountButton.backgroundColor = [UIColor orangeColor];
        [addCountButton setImage:[UIImage imageNamed:@"-0"] forState:UIControlStateNormal];
        [addCountButton addTarget:self action:@selector(countSubButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [countView addSubview:addCountButton];
        
        UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addCountButton.frame)+2*(SCREEN_WIDTH/320), 0, 20, 20)];
        count.textAlignment = NSTextAlignmentCenter;
        count.font = [UIFont systemFontOfSize:13];
        self.countLabel = count;
        [countView addSubview:count];
        
        UIButton *subButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(count.frame)+2*(SCREEN_WIDTH/320), 0, 25, 25)];
//        subButton.backgroundColor = [UIColor orangeColor];
        [subButton setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
        [subButton addTarget:self action:@selector(addCountButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [countView addSubview:subButton];
    }
    return self;
}

- (void)addButtonClick:(UIButton *)button
{
    if ([self.delegate  respondsToSelector:@selector(cellShowCountViewWithPath:)]) {
        [self.delegate cellShowCountViewWithPath:self.indexPath];
    }
    if ([self.delegate  respondsToSelector:@selector(cellOrderAddPath:)]) {
        [self.delegate cellOrderAddPath:self.indexPath];
    }
}

- (void)setModel:(TakeOutModel *)model
{
    _model = model;
//    self.title.text = model.title;
    self.count = model.orderCount<=0?1:model.orderCount;
//    self.sold.text = [NSString stringWithFormat:@"已售%ld份",model.soldCount];
//    self.price.text = [NSString stringWithFormat:@"￥%ld",model.price];
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.iconPath] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    if (self.model.moreGuiGe) {
        self.btn_moreGuiGe.hidden=NO;
        self.addButton.hidden = YES;
        self.countView.hidden = YES;
    }
    else
    {
        self.btn_moreGuiGe.hidden=YES;
        if (model.showCount) {
            self.addButton.hidden = YES;
            self.countView.hidden = NO;
        }else
        {
            self.addButton.hidden = NO;
            self.countView.hidden = YES;
        }
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.model.title drawAtPoint:CGPointMake(CGRectGetMaxX(self.icon.frame)+5*(SCREEN_WIDTH/320),10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//    if (!get_Bsp(@"IsBusiness")) {
//        NSString *soldCount = [NSString stringWithFormat:@"接受预定,%@开始配送",get_sp(@"DeliveryTime")];;
//        [soldCount drawAtPoint:CGPointMake(CGRectGetMaxX(self.icon.frame)+5*(SCREEN_WIDTH/320),23) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithRed:137/255.0 green:199/255.0 blue:221/255.0 alpha:1.0]}];
//    }
    
    NSString *soldCount = [NSString stringWithFormat:@"已售%ld份",(long)self.model.soldCount];;
    [soldCount drawAtPoint:CGPointMake(CGRectGetMaxX(self.icon.frame)+5*(SCREEN_WIDTH/320),34) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    //画价格
    NSString *price = [NSString stringWithFormat:@"￥%.2f",self.model.price];
    [price drawAtPoint:CGPointMake(CGRectGetMaxX(self.icon.frame)+5*(SCREEN_WIDTH/320), 55) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor orangeColor]}];
}

- (void)addCountButtonClick
{
    self.count++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    if ([self.delegate  respondsToSelector:@selector(cellOrderAddPath:)]) {
        [self.delegate cellOrderAddPath:self.indexPath];
    }
}

- (void)countSubButtonClick
{
    self.count--;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    if (self.count <=0) {
        if ([self.delegate  respondsToSelector:@selector(cellNotShowCountViewWithPath:)]) {
            [self.delegate cellNotShowCountViewWithPath:self.indexPath];
        }
    }
    if ([self.delegate  respondsToSelector:@selector(cellOrderSubPath:)]) {
        [self.delegate cellOrderSubPath:self.indexPath];
    }
    
}

-(void)JumpToGoodDetial
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moreguige" object:self.indexPath];
}
@end
