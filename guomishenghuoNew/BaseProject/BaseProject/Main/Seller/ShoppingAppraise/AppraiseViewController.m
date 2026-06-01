//
//  AppraiseViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AppraiseViewController.h"
#import "ShopApraiseTableView.h"
#import "BottomView.h"
#import "DataProviderOther.h"
#import "RatingsViewController.h"
#import "JSONKit.h"

@interface AppraiseViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ShopApraiseTableViewDelegate, BottomViewDelegate>

@property (nonatomic, strong)ShopApraiseTableView *tableView;


@end

@implementation AppraiseViewController
{
    NSMutableArray * Img_dictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"购物券订单评价";
    Img_dictionary=[[NSMutableArray alloc] init];
    self.tapGesture.enabled = YES;//默认关闭
    [self.view addSubview:self.tableView];
    BottomView *bView = [[BottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-65, SCREEN_WIDTH, 65)];
    [self.view addSubview:bView];
    bView.delegate = self;
}
- (ShopApraiseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ShopApraiseTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-65) style:UITableViewStylePlain];
        _tableView.cellNum=self.orderDetail.orderGoods.count;
        _tableView.appraiseDelegate = self;
    }
    return _tableView;
}
// 提交
- (void)commit{
    
    
    if (Img_dictionary.count>0) {
        //得到词典中所有Value值
        DataProviderOther *dataProvider = [[DataProviderOther alloc] init];
        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"SubmitAllPingJia:" setFailBackFunctionName:nil];
        
        [dataProvider AppraiseBillWithbillid:self.orderDetail.orderId andshopscore:@"0" andshopappraise:@"" andshopappraisepicture:@"" andlist_ProAppraise:[Toolkit NSArrayToJsonString:Img_dictionary]];
    }
    
//    RatingsViewController *avc = [[RatingsViewController alloc]init];
//    [self.navigationController pushViewController:avc animated:YES];
}
-(void)SubmitAllPingJia:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"评价提交成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:@"评价提交失败，请重新提交"];
    }
}
- (void)postPic:(JSTextView *)view{
    _tableView.jsView = view;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"打开相册");
    }];
}
// 打开相册
- (void)uploadPicture:(UITextView *)view{
 

}
// 取消输入框的第一响应

#pragma mark imgViewDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

        [_tableView.jsView.btn setBackgroundImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    
    
    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"上传照片");
        NSData *imageData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
        NSString * base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
//        [SVProgressHUD showWithStatus:@"头像上传中......"];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"uploadImageCallBack:" setFailBackFunctionName:nil];
        [dataProvider uploadHeadImageWithFileName:@"headImage.png" filestream:base64];
       
    }];
    
}

-(void)uploadImageCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [YJXStatusHUD showSuccess:@"图片上传成功"];
        NSDictionary * itemdict=[[NSMutableDictionary alloc] init];
        NSString * imgPath=[NSString stringWithFormat:@"%@",dict[@"data"][@"SmallImagePath"]];
        NSArray * itemarray=[[NSArray alloc] initWithObjects:imgPath, nil];
        [itemdict setValue:itemarray forKey:@"PicturePath"];
        [itemdict setValue:_tableView.jsView.text forKey:@"Content"];
        [itemdict setValue:ZY_NSStringFromFormat(@"%.0f",_tableView.lView.level) forKey:@"Score"];
        [itemdict setValue:self.orderDetail.orderGoods[_tableView.jsView.tag%100].goodID forKey:@"ProductId"];
//        [Img_dictionary setValue:itemdict forKey:ZY_NSStringFromFormat(@"%d",_tableView.jsView.tag)];
        [Img_dictionary addObject:itemdict];
    }
    else{
        [YJXStatusHUD showSuccess:@"图片上传失败"];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_app_ hiddenTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
