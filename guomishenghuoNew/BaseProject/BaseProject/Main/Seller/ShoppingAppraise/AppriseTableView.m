//
//  AppriseTableView.m
//  BaseProject
//
//  Created by 刘顺 on 16/11/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AppriseTableView.h"

@implementation AppriseTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 190;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
#pragma mark TableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellNum+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"AppriseTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    if ([cell.contentView.subviews lastObject] != nil) {
    //        [[cell.contentView.subviews lastObject] removeFromSuperview];
    //    }
    // 打分
    if (indexPath.row==0) {
        UILabel *grade1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 35)];
        [cell.contentView addSubview:grade1];
        grade1.text = @"店铺评价";
        
        _lView = [[CWStarRateView alloc] initWithFrame:CGRectMake(130, 5, 125, 25) numberOfStars:5];
        _lView.scorePercent =1;
        _lView.isChangeStarNum=YES;
        _lView.allowIncompleteStar = NO;
        _lView.hasAnimation = YES;
        [cell.contentView addSubview:_lView];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, 25+10, SCREEN_WIDTH-10, 1)];
        [cell.contentView addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        
        _jsView = [[JSTextView alloc]initWithFrame:CGRectMake(5, 25+10+1, SCREEN_WIDTH-10, 130) size:45 numLimit:YES];
        [cell.contentView addSubview:_jsView];
        
        _jsView.myPlaceholder=@"请输入评价内容...";
        _jsView.LSDelegate = self;
        _jsView.myPlaceholderColor= [UIColor lightGrayColor];
        _jsView.tag = 10000000+indexPath.row;
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:_jsView Direction:@"Y"], SCREEN_WIDTH, 1)];
        line2.backgroundColor = RGB(235, 235, 241);
        [cell.contentView addSubview:line2];
        return cell;
    }
    
    
    
    
    UILabel *grade2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 35)];
    [cell.contentView addSubview:grade2];
    grade2.text = @"商品评价";
    
    _lView = [[CWStarRateView alloc] initWithFrame:CGRectMake(130, 5, 125, 25) numberOfStars:5];
    _lView.scorePercent =1;
    _lView.isChangeStarNum=YES;
    _lView.allowIncompleteStar = NO;
    _lView.hasAnimation = YES;
    [cell.contentView addSubview:_lView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, 25+10, SCREEN_WIDTH-10, 1)];
    [cell.contentView addSubview:line];
    line.backgroundColor = [UIColor lightGrayColor];
    
    _jsView = [[JSTextView alloc]initWithFrame:CGRectMake(5, 25+10+1, SCREEN_WIDTH-10, 130) size:45 numLimit:YES];
    [cell.contentView addSubview:_jsView];
    
    _jsView.myPlaceholder=@"请输入评价内容...";
    _jsView.LSDelegate = self;
    _jsView.myPlaceholderColor= [UIColor lightGrayColor];
    _jsView.tag = 10000000+indexPath.row;
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:_jsView Direction:@"Y"], SCREEN_WIDTH, 1)];
    line2.backgroundColor = RGB(235, 235, 241);
    [cell.contentView addSubview:line2];

//    UILabel *label = [[UILabel alloc]init];
//    [cell.contentView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(5);
//    }];
//    label.backgroundColor = RGB(235, 235, 241);
    return cell;
}
// 打开相册

- (void)uploadPicture:(JSTextView *)view{
    if ([self.appDelegate respondsToSelector:@selector(postPic:)]) {
        [self.appDelegate postPic:view];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.editing = NO;
}

@end
