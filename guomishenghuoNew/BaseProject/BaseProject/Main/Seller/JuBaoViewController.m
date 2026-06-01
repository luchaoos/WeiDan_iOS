//
//  JuBaoViewController.m
//  BaseProject
//
//  Created by 于金祥 on 2017/1/2.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "JuBaoViewController.h"
#import "MyTextView.h"
#import "DataProviderOther.h"

@interface JuBaoViewController ()
@property (nonatomic,strong)UITableView * mainTableView;
@end

@implementation JuBaoViewController
{
    MyTextView * txt_content;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    _lblTitle.text=@"用户反馈";
    [self InitViews];
}
-(void)InitViews
{
    [self addRightbuttontitle:@"提交"];
    UILabel * lbl_shopName=[[UILabel alloc] initWithFrame:CGRectMake(0, 66, SCREEN_WIDTH, 50)];
    lbl_shopName.backgroundColor=[UIColor whiteColor];
    lbl_shopName.text=[NSString stringWithFormat:@"    店铺名称:%@",self.shopName];
    [self.view addSubview:lbl_shopName];
    
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbl_shopName.frame), SCREEN_WIDTH, 30)];
    lbl_title.text=@"    反馈内容";
//    lbl_title.backgroundColor=[UIColor]
    [self.view addSubview:lbl_title];
    
    txt_content=[[MyTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbl_title.frame), lbl_shopName.frame.size.width, SCREEN_HEIGHT-CGRectGetMaxY(lbl_title.frame))];
    txt_content.placeHolder.text=@"   请输入反馈内容";
    [self.view addSubview:txt_content];
}
-(void)clickRightButton:(UIButton *)sender
{
    if (txt_content.text.length<=0) {
        return;
    }
    DataProviderOther * dataprovider=[[DataProviderOther alloc] init];
    [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"SendErrorMessageCallBack:" setFailBackFunctionName:nil];
    [dataprovider SendErrorMessageWithShopID:self.shopId andshopName:self.shopName andcategory:@"用户反馈" andcontent:txt_content.text];
}
-(void)SendErrorMessageCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"已提交，谢谢您的反馈"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:@"提交失败，请稍后再试"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
