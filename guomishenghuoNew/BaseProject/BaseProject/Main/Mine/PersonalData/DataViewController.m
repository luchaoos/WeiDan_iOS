//
//  DataViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "DataViewController.h"
#import "MyDataCell.h"
#import "PassWordViewController.h"
#import "ModifyViewController.h"
#import "UIImage+cutImage.h"
#import "BoundPhoneViewController.h"

#define arcWitch [UIScreen mainScreen].bounds.size.width/2


@interface DataViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imgView;
    UITextField *field;
    NSString *base64;
    BOOL isUploading;
    BOOL isEdited;
}
@property(nonatomic, strong)UITableView *perTableView;
@property(nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isUploading=NO;
    isEdited=NO;
    _lblTitle.text=@"个人资料";
    [self.view addSubview:self.perTableView];
    [self footView];
}
-(void)clickLeftButton:(UIButton *)sender
{
    if (isEdited) {
        [YJXStatusHUD showError:@"请保存已经修改的信息"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)perTableView{
    if (!_perTableView) {
        _perTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        _perTableView.delegate = self;
        _perTableView.dataSource = self;
        _perTableView.showsVerticalScrollIndicator = NO;
        
    }
    return _perTableView;
}
- (void)footView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [self.view addSubview:footView];
    footView.backgroundColor = RGB(235, 235, 241);
    UIButton *btn = [UIButton new];
    [footView addSubview:btn];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _perTableView.tableFooterView = footView;
}
- (void)btnClick{
    if (isUploading) {
        [YJXStatusHUD showError:@"等待图片上传"];
        return;
    }
    //头像上传
    if (imgView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像"];
        return;
    }
    if ([field.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写昵称"];
        return;
    }
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"addInfoCallBack:" setFailBackFunctionName:nil];
    [dataProvider changePersonalInfoWithId:[Toolkit getUserDefaultByKey:user_ID] photopath:[NSString stringWithFormat:@"%@",[Toolkit judgeIsNull:[Toolkit getUserDefaultByKey:SmallImagePath]]] nicname:field.text];
}
-(void)uploadImageCallBack:(id)dict{
    NSLog(@"%@",dict);
    isUploading=NO;
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
        [Toolkit setUserDefaultWithObject:dict[@"data"][@"BigImagePath"] forKey:BigImagePath];
        [Toolkit setUserDefaultWithObject:dict[@"data"][@"SmallImagePath"] forKey:SmallImagePath];
        [Toolkit setUserDefaultWithObject:[NSString stringWithFormat:@"%@",dict[@"data"][@"SmallImagePath"]] forKey:@"PhotoPath"];
        
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}
-(void)addInfoCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
//        [SVProgressHUD showSuccessWithStatus:@"个人信息上传成功"];
        [YJXStatusHUD showSuccess:@"个人信息上传成功"];
        set_sp(@"Name", field.text);
        isEdited=NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}
#pragma mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([NSString stringWithFormat:@"%@",get_sp(@"Phone")].length>10) {
        return 2;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDataCell *cell = [[MyDataCell alloc]init];
    [cell cellWithTableView:tableView forRowAtIndexPath:indexPath];
    if (indexPath.section == 0&& indexPath.row == 0) {
        UIButton *btn = [UIButton new];
        [cell.contentView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
            make.top.mas_equalTo(32);
            make.right.mas_equalTo(-10);
        }];
        [btn setImage:[UIImage imageNamed:@"iconfont-fanhuiyou"] forState:UIControlStateNormal];
        btn.tintColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
        if (!imgView) {
            imgView = [[UIImageView alloc]init];
            imgView.layer.cornerRadius = 25;
            imgView.layer.masksToBounds = YES;
            [imgView sd_setImageWithURL:[NSURL URLWithString:get_sp(@"PhotoPath")] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        }
        
        [cell.contentView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.equalTo(btn.mas_left).offset(-5);
            make.width.height.mas_equalTo(50);
            
        }];
        
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        UILabel *label = [UILabel new];
        [cell.contentView addSubview    :label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-15);
        }];
        label.textAlignment = NSTextAlignmentRight;
        label.text =  get_sp(@"Phone");
        label.textColor = RGB(203, 203, 204);
    }else if (indexPath.section == 1 && indexPath.row == 3){
        
    }
    if ((indexPath.section == 0 &&indexPath.row !=0)||(indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 3))||(indexPath.section == 2&& indexPath.row !=0)) {
        field = [UITextField new];
        [cell.contentView addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-15);
        }];
        field.textAlignment = NSTextAlignmentRight;
        field.delegate = self;
        if (indexPath.section == 0 && indexPath.row == 1) {
            field.text =get_sp(@"Name");
        }
//        if (indexPath.section == 1 ){
//            if (indexPath.row == 1) {
//                field.placeholder = @"1234567891";
//                
//            }else if (indexPath.row == 3){
//                field.placeholder = @"请输入所在城市";
//            }
//        }
        if (indexPath.section == 2) {
//             if (indexPath.row == 1) {
//                 field.placeholder = get_sp(@"Phone");
//             }
            if (indexPath.row == 1) {
                field.placeholder = @"范冰冰";
            }else if (indexPath.row == 2){
                field.placeholder = @"请输入邮政邮编";
            }
        }
    }
//    if (indexPath.section == 1 && indexPath.row == 2) {
//        UILabel *women = [UILabel new];
//        [cell.contentView addSubview:women];
//        women.text = @"女";
//        women.textColor = RGB(212, 213, 214);
//        [women makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-50);
//            make.width.height.mas_equalTo(25);
//            make.top.mas_equalTo(15);
//        }];
//        UIButton *womenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [cell.contentView addSubview:womenBtn];
//        womenBtn.layer.cornerRadius = 25/2;
//        womenBtn.layer.masksToBounds = YES;
//        [womenBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
//        [womenBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
//        womenBtn.tag = 100;
//        [womenBtn makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(25);
//            make.right.equalTo(women.left).offset(-5);
//            make.top.mas_equalTo(15);
//        }];
//        UILabel *man = [UILabel new];
//        [cell.contentView addSubview:man];
//        man.text = @"男";
//        man.textColor = RGB(212, 213, 214);
//        [man makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(womenBtn.left).offset(-50);
//            make.width.height.mas_equalTo(25);
//            make.top.mas_equalTo(15);
//        }];
//        UIButton *manBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [cell.contentView addSubview:manBtn];
//        manBtn.layer.cornerRadius = 25/2;
//        manBtn.layer.masksToBounds = YES;
//        [manBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
//        manBtn.tag = 101;
//        [manBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
//        [manBtn makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(25);
//            make.right.equalTo(man.left).offset(-5);
//            make.top.mas_equalTo(15);
//        }];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)changeIcon{
    
}

- (void)chooseSex:(UIButton *)btn{
    if (btn.tag == 100) {
        UIButton *manBtn = [self.view viewWithTag:101];
        if (manBtn.selected) {
            manBtn.selected = NO;
            [manBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        btn.selected = YES;
    }else if (btn.tag == 101){
        UIButton *womenBtn = [self.view viewWithTag:100];
        if (womenBtn.selected) {
            womenBtn.selected = NO;
            [womenBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        btn.selected = YES;
    }
}

#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }else if (section == 2){
        return 5;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 60;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
////    if (section == 2) {
////        UIView *view = [[UIView alloc]init];
////        view.backgroundColor = RGB(235, 235, 241);
////        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
////        [view addSubview:label];
////        label.text = @"其他信息";
////        label.textColor = RGB(185, 187, 189);
////        return view;
////    }
//    return nil;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍照", nil];
        [actionSheet showInView:self.view];
        isEdited=YES;
    }
//    if (indexPath.section == 1) {
//        if (indexPath.row == 1) {
//            PassWordViewController *pvc = [[PassWordViewController alloc]init];
//            [self.navigationController pushViewController:pvc animated:YES];
//        }
    if (indexPath.section == 1 && indexPath.row == 0) {
        ModifyViewController *pvc = [[ModifyViewController alloc]init];
        [self.navigationController pushViewController:pvc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([NSString stringWithFormat:@"%@",get_sp(@"Phone")].length<10) {
            BoundPhoneViewController *pvc = [[BoundPhoneViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing=YES;
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [imagePicker setModalPresentationStyle:UIModalPresentationFullScreen];
        [imagePicker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:imagePicker animated:YES completion:nil];
        isUploading=YES;
    }
    if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [imagePicker setModalPresentationStyle:UIModalPresentationFullScreen];
        [imagePicker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:imagePicker animated:YES completion:nil];
        isUploading=YES;
    }
    
}
#pragma mark ----- UIImagePickerControllerDelegate -----
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%@",NSStringFromCGSize(image.size));
    UIImage *image2 = [UIImage imagewithImage:image];
//    imageview.image = image2;
    
    imgView.image = image2;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"头像上传中......"];
    NSData *imageData = UIImagePNGRepresentation(imgView.image);
    base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"uploadImageCallBack:" setFailBackFunctionName:nil];
    [dataProvider uploadHeadImageWithFileName:@"headImage.png" filestream:base64];
}

#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [_app_ hiddenTabBar];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 3)
    {
        Method method = class_getInstanceMethod([self class], @selector(drawRect:));
        class_replaceMethod([[[[navigationController viewControllers][2].view subviews][1] subviews][0] class],@selector(drawRect:),method_getImplementation(method),method_getTypeEncoding(method));
    }
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextAddRect(ref, rect);
    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, M_PI*2, NO);
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]setFill];
    CGContextDrawPath(ref, kCGPathEOFill);
    
    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, M_PI*2, NO);
    [[UIColor whiteColor]setStroke];
    CGContextStrokePath(ref);
}
@end
