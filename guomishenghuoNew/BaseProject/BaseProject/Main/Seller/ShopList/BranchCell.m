//
//  BranchCell.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/17.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BranchCell.h"

@implementation BranchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:phoneBtn];
        
        CustomLabel *shopName = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 5, 200, 25) withContent:@"凤凰印云南(南坊的)" font:16.0 andRGBr:77 RGBg:81 RGBb:82 adaptive:NO];
        [self.contentView addSubview:shopName];
        
        CustomLabel *address = [[CustomLabel alloc]initWithFrame:CGRectMake(10, [Util ReturnViewFrame:shopName Direction:@"Y"], SCREEN_WIDTH-10-25-10-10-5, 25) withContent:@"临沂市北城新区上海路与沂蒙路交汇颐高上海街" font:14.0 andRGBr:200 RGBg:201 RGBb:203 adaptive:YES];
        [self.contentView addSubview:address];
        
        [phoneBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.width.height.mas_equalTo(25);
            make.top.equalTo(address);
        }];
        [phoneBtn setBackgroundImage:[UIImage imageNamed:@"bohao"] forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(makePhoneCall) forControlEvents:UIControlEventTouchUpInside];
        UILabel *line = [UILabel new];
        [self.contentView addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(phoneBtn.left).offset(-10);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(20);
        }];
        line.backgroundColor = [UIColor lightGrayColor];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, [Util ReturnViewFrame:address Direction:@"Y"]+5, 10, 13)];
        [self.contentView addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"ditutubiao"];
        UILabel *distance = [UILabel new];
        [self.contentView addSubview:distance];
        [distance makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(imgView);
            make.left.equalTo(imgView.right).offset(5);
            make.width.mas_equalTo(50);
        }];
        distance.font = [UIFont systemFontOfSize:14.0];
        distance.text = @"100m";
        distance.textColor = RGB(189, 194, 195);
    }
    return self;
}
+ (BranchCell *)cellForTableView:(UITableView *)tableView{
    static NSString *brnIdent = @"brnIden";
    BranchCell *bCell = [tableView dequeueReusableCellWithIdentifier:brnIdent];
    if (!bCell) {
        bCell = [[BranchCell alloc]init];
    }
    return bCell;
}
// 打电话
- (void)makePhoneCall{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"186xxxx6979"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
//    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"186xxxx6979"];
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
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
