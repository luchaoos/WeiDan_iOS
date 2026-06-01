//
//  ShoppingTableViewCell.m
//  TDS
//
//  Created by 黎金 on 16/3/24.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "ShoppingTableViewCell.h"
#import "Util.h"
#import "Header.h"
#import "AddNumView.h"
#import "EditCartView.h"
#import "DataProviderOther.h"


@interface ShoppingTableViewCell ()<AddNumViewDelegate,EditCartViewDelegate>

@end
@implementation ShoppingTableViewCell
{

    NSIndexPath *indexPath;
    
    //图片
    UIImageView *headImageView;
    
    //标题
    UILabel *titleLabel;
    
    //价格
    UILabel *priceLabel;
    
    //颜色&尺码
    UILabel *styleLabel;
    
    EditCartView *editcartView;
    
    AddNumView *addnumView;
    
    //确定
    ShoppingBtn *okBtn;
    
    UILabel *mustLabel;
    
    BOOL isbool;
    
}
- (void)awakeFromNib {
    
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //勾选按钮
        okBtn = [[ShoppingBtn alloc] initWithFrame:CGRectMake(0, 0, 55, 100)];
        [okBtn addTarget:self action:@selector(OKBtn:) forControlEvents:UIControlEventTouchDown];
        
        
        //图片
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 15, 70, 70)];
        headImageView.backgroundColor = [UIColor purpleColor];
        
        //标题
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([Util ReturnViewFrame:headImageView Direction:@"X"] +10, 15, SCREEN_WIDTH - ([Util ReturnViewFrame:headImageView Direction:@"X"] +91)+150, 18)];
        titleLabel.textColor = TextColor;
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        //颜色 尺码
        styleLabel = [[UILabel alloc] initWithFrame:CGRectMake([Util ReturnViewFrame:headImageView Direction:@"X"] +10, [Util ReturnViewFrame:titleLabel Direction:@"Y"]+5, SCREEN_WIDTH-[Util ReturnViewFrame:headImageView Direction:@"X"] - 20, 18)];
        styleLabel.textColor = [UIColor orangeColor];
        
        styleLabel.font = [UIFont systemFontOfSize:11.0];
        
        //价格
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake([Util ReturnViewFrame:headImageView Direction:@"X"] +10, [Util ReturnViewFrame:headImageView Direction:@"Y"] - 25, 60, 18)];
        priceLabel.textColor = TextColor;
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont systemFontOfSize:12.0];
        
    
        addnumView = [[AddNumView alloc] initWithFrame:CGRectMake([Util ReturnViewFrame:priceLabel Direction:@"X"], [Util ReturnViewFrame:headImageView Direction:@"Y"] - 27, 150, 25)];
        addnumView.delegate = self;
       [self addSubview:addnumView];

        [self addSubview:okBtn];
        [self addSubview:headImageView];
        [self addSubview:mustLabel];
        [self addSubview:titleLabel];
        [self addSubview:styleLabel];
        [self addSubview:priceLabel];
        
        
        
        editcartView = [[EditCartView alloc ] initWithFrame:CGRectMake([Util ReturnViewFrame:headImageView Direction:@"X"] +10, 15, SCREEN_WIDTH - ([Util ReturnViewFrame:headImageView Direction:@"X"] +20) , 70)];
        editcartView.delegate = self;
        editcartView.backgroundColor = [UIColor orangeColor];
        [Util makeCorner:2 view:editcartView];
        [Util makeCorner:0.5 view:editcartView color:GrayLine];
        [self addSubview:editcartView];
        editcartView.hidden = YES;
        

        
    }
    
    return  self;
}


-(void)setModel:(ShoppingCellModel *)model{

    _model = model;
    
    indexPath = [NSIndexPath indexPathForRow:model.row inSection:model.section];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    titleLabel.text = model.title;
    styleLabel.text = [NSString stringWithFormat:@"颜色: %@   型号: %@",model.color,model.size];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    mustLabel.hidden = model.mustInteger == 0?YES:NO;
    addnumView.numInteger = model.numInt;
    addnumView.ID=model.ID;
    editcartView.numInteger = model.numInt;
    editcartView.styleString = styleLabel.text;
    
    if (model.cellClickState == 1) {

        isbool = YES;
        [okBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];

    } else {

        isbool = NO;
        [okBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
    
    if (model.cellEditState ==1) {
        
        editcartView.hidden = NO;
        
    }else{
    
        editcartView.hidden = YES;

    }

}

-(void)EditCartView:(NSInteger)num{

    _model.numInt = num;
    [_delegate ShoppingTableViewCell:_model];
}

-(void)EditCartView{

}

-(void)AddNumView:(NSInteger)num{
    
    _model.numInt = num;
    [_delegate ShoppingTableViewCell:_model];
}


-(void)OKBtn:(UIButton *)sendel{
    
        if (isbool) {
    
            _model.cellClickState = 0;
            [_delegate ShoppingTableViewCell:_model];
            [okBtn setImage:[UIImage imageNamed:@"iconfont-yuanquan"] forState:UIControlStateNormal];
            isbool = NO;
    
        }else{
    
            _model.cellClickState = 1;
            [_delegate ShoppingTableViewCell:_model ];
            [okBtn setImage:[UIImage imageNamed:@"iconfont-zhengque"] forState:UIControlStateNormal];
            isbool = YES;
        }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
