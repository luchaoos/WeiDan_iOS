//
//  AddNumView.m
//  TDS
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "AddNumView.h"
#import "Header.h"
#import "DataProviderOther.h"

@implementation AddNumView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        num = 1;
        self.backgroundColor = RGB(251, 251, 251);
        [Util makeCorner:0.5 view:self color:GrayLine];
        
        minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, frame.size.height)];
// 最好换成图片,文字  -  太丑
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        
        minusBtn.backgroundColor = RGB(191, 193, 194);
        [minusBtn setTitleColor:RGB(94, 95, 96) forState:UIControlStateNormal];
        minusBtn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [minusBtn addTarget:self action:@selector(MinusBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:minusBtn];
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, (frame.size.height - 18)/2, 35, 18)];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = TextColor;
        numLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:numLabel];
//        [Util setFoursides:numLabel Direction:@"left" sizeW:18];
//        [Util setFoursides:numLabel Direction:@"right" sizeW:18];
        
        addBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 25, frame.size.height)];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        addBtn.backgroundColor = RGB(191, 193, 194);
        [addBtn setTitleColor:RGB(94, 95, 96) forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [addBtn addTarget:self action:@selector(AddBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:addBtn];
        
        numLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(92, (frame.size.height - 18)/2, 35, 18)];
        numLabel1.textAlignment = NSTextAlignmentCenter;
        numLabel1.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:numLabel1];
        
    }
    return self;
}



-(void)MinusBtn:(UIButton *)sender{

    if ((num - 1) <= 0 || num == 0) {
        
        NSLog(@"超出范围");
        
    }else{
        num  = num -1;
    }
    
    numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    numLabel1.text = [NSString stringWithFormat:@"×%ld", (long)num];
//    [_delegate AddNumView:num];
    [self SetGoodNumwith:[NSString stringWithFormat:@"%ld", (long)num]];
}

-(void)AddBtn:(UIButton *)sender{
    
    if (num >= 10 ) {
        
        NSLog(@"超出范围");
        
    }else{
        
        num = num +1;
    }
    
    numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    numLabel1.text = [NSString stringWithFormat:@"×%ld", (long)num];
    [self SetGoodNumwith:[NSString stringWithFormat:@"%ld", (long)num]];
    
}
-(void)SetGoodNumwith:(NSString *)num1
{
    DataProviderOther * dataprovider=[[DataProviderOther alloc] init];
    
    [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"SetGoodNumCallBack:" setFailBackFunctionName:nil];
    
    [dataprovider ChangeProductNumForBasketWithdetailid:self.ID andnum:num1];
}

-(void)SetGoodNumCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"商品数量修改完成"];
//        [_delegate ShoppingTableViewCell:_model];
        [_delegate AddNumView:num];
    }
}


-(void)setNumInteger:(NSInteger)numInteger{

    _numInteger = numInteger;
     numLabel.text = [NSString stringWithFormat:@"%ld",(long)_numInteger];
    numLabel1.text = [NSString stringWithFormat:@"×%ld", (long)_numInteger];
    num = _numInteger;
}

-(void)setMinInteget:(NSInteger)minInteget{

    _minInteget = minInteget;
    if (_minInteget == 0) {
        [_delegate AddNumView:_minInteget];
        numLabel.text = @"0";
        num = 0;
        
    }else if (_minInteget<=[numLabel.text integerValue]){
        [_delegate AddNumView:_minInteget];
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)_minInteget];
        numLabel1.text = [NSString stringWithFormat:@"%ld",(long)_minInteget];
        num = _minInteget;
    }
}

@end
