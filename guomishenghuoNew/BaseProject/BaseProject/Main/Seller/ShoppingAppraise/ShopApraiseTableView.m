//
//  ShopApraiseTableView.m
//  BaseProject
//
//  Created by 刘顺 on 16/11/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopApraiseTableView.h"

@implementation ShopApraiseTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 220;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
#pragma mark TableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ShopApraiseTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if ([cell.contentView.subviews lastObject] != nil) {
//        [[cell.contentView.subviews lastObject] removeFromSuperview];
//    }
    // 打分
    UILabel *grade = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 35)];
    [cell.contentView addSubview:grade];
    grade.text = @"商家评价";
    
    _lView = [LPLevelView new];
    _lView.frame = CGRectMake(130, 5, 125, 25);
    _lView.iconColor = [UIColor lightGrayColor];
    _lView.iconSize = CGSizeMake(20, 20);
    _lView.canScore = YES;
    _lView.animated = NO;
    _lView.levelInt = YES;
    _lView.level = 0;
    // 评分
    
    [_lView setScoreBlock:^(float level) {
        NSLog(@"打分：%f", level);
    }];
    [cell.contentView addSubview:_lView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, 35+5, SCREEN_WIDTH-10, 1)];
    [cell.contentView addSubview:line];
    line.backgroundColor = [UIColor lightGrayColor];
    
    
    // 写评价
    _jsView = [[JSTextView alloc]initWithFrame:CGRectMake(5, 35+8, SCREEN_WIDTH-10, 170) size:75 numLimit:YES];
    [cell.contentView addSubview:_jsView];
    _jsView.tag = 10000000+indexPath.row;
    _jsView.myPlaceholder=@"请输入评价内容...";
    _jsView.LSDelegate = self;
    _jsView.myPlaceholderColor= [UIColor lightGrayColor];
    
    
    UILabel *label = [[UILabel alloc]init];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    label.backgroundColor = RGB(235, 235, 241);
    return cell;
}
// 打开相册
- (void)uploadPicture:(JSTextView *)view{
    if ([self.appraiseDelegate respondsToSelector:@selector(postPic:)]) {
        [self.appraiseDelegate postPic:view];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.editing = NO;
}

@end
