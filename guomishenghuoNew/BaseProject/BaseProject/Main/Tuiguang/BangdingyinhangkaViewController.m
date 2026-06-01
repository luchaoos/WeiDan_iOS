//
//  BangdingyinhangkaViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/5.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "BangdingyinhangkaViewController.h"
#import "GMPickerView.h"

@interface BangdingyinhangkaViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textView1;
@property (nonatomic, strong) GMPickerView *pick1;
@property (weak, nonatomic) IBOutlet UITextField *textView2;
@property (nonatomic, strong) GMPickerView *pick2;
@property (weak, nonatomic) IBOutlet UITextField *textView3;
@property (nonatomic, strong) GMPickerView *pick3;
@property (weak, nonatomic) IBOutlet UITextField *textView4;
@property (nonatomic, strong) GMPickerView *pick4;
@property (weak, nonatomic) IBOutlet UITextField *textView5;
@property (weak, nonatomic) IBOutlet UITextField *textView6;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons2;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation BangdingyinhangkaViewController

- (IBAction)bangding:(id)sender {
    
    if (!_textView1.text || _textView1.text.length == 0) {
        return [SVProgressHUD showErrorWithStatus:@"请选择银行"];
    }
    if (![_textView1.text isEqualToString:@"建设银行"]) {
        if (!_textView2.text || _textView2.text.length == 0) {
            return [SVProgressHUD showErrorWithStatus:@"请选择省份"];
        }
        if (!_textView3.text || _textView3.text.length == 0) {
            return [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        }
        if (!_textView4.text || _textView4.text.length == 0) {
            return [SVProgressHUD showErrorWithStatus:@"请选择分行"];
        }
    }
    if (!_textView5.text || _textView5.text.length == 0) {
        return [SVProgressHUD showErrorWithStatus:@"请填写开户姓名"];
    }
    if (!_textView6.text || _textView6.text.length == 0) {
        return [SVProgressHUD showErrorWithStatus:@"请填写卡号"];
    } else if (_textView6.text.length < 4) {
        return [SVProgressHUD showErrorWithStatus:@"请填写正确的卡号"];
    }
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"bindBankCardFinish:" setFailBackFunctionName:nil];
    [dataProvider commissionServiceBindBankCardWithShopid:get_sp(user_ID)
                                                   cardno:_textView6.text
                                           recopenaccdept:_textView4.text
                                              recvubankno:_pick4.currentSelectedObj ? _pick4.currentSelectedObj[@"Code"] : @"0"
                                              nameforbank:_textView5.text];
}

- (void)bindBankCardFinish:(NSDictionary *)data {
    NSLog(@"%@", data);
    if (RequestSuccess(data)) {
        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text = @"绑定银行卡";
    
    self.textView1.text = @"建设银行";
    self.cons1.constant = 0;
    self.cons2.constant = 0;
    self.view1.alpha = 0;
    self.view2.alpha = 0;
    
    MJWeakSelf
    GMPickerView *pick1 = [[GMPickerView alloc] init];
    pick1.textProperty = @"Name";
    pick1.selected = ^(id obj) {
        NSLog(@"%@", obj);
        weakSelf.textView1.text = obj[@"Name"];
        if ([obj[@"Name"] isEqualToString:@"建设银行"]) {
            [UIView animateWithDuration:0.3f animations:^{
                self.cons1.constant = 0;
                self.cons2.constant = 0;
                self.view1.alpha = 0;
                self.view2.alpha = 0;
            }];
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                self.cons1.constant = 50;
                self.cons2.constant = 50;
                self.view1.alpha = 1;
                self.view2.alpha = 1;
            }];
            if (weakSelf.pick3.currentSelectedObj) {
                [weakSelf getCode:weakSelf.pick3.currentSelectedObj[@"Code"] backCode:obj[@"Code"]];
            }
        }
    };
    self.pick1 = pick1;
    self.textView1.inputView = pick1;
    [self getBack];
    
    GMPickerView *pick2 = [[GMPickerView alloc] init];
    pick2.textProperty = @"Name";
    pick2.selected = ^(id obj) {
        NSLog(@"%@", obj);
        weakSelf.textView2.text = obj[@"Name"];
        [weakSelf getCity:obj[@"Name"]];
    };
    self.pick2 = pick2;
    self.textView2.inputView = pick2;
    [self getProvince];
    
    GMPickerView *pick3 = [[GMPickerView alloc] init];
    pick3.textProperty = @"CityName";
    pick3.selected = ^(id obj) {
        NSLog(@"%@", obj);
        weakSelf.textView3.text = obj[@"CityName"];
        if (weakSelf.pick1.currentSelectedObj) {
            [weakSelf getCode:obj[@"Code"] backCode:weakSelf.pick1.currentSelectedObj[@"Code"]];
        }
    };
    self.pick3 = pick3;
    self.textView3.inputView = pick3;
    
    GMPickerView *pick4 = [[GMPickerView alloc] init];
    pick4.textProperty = @"Name";
    pick4.selected = ^(id obj) {
        NSLog(@"%@", obj);
        weakSelf.textView4.text = obj[@"Name"];
    };
    self.pick4 = pick4;
    self.textView4.inputView = pick4;
    
}



- (void)getBack {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getbackFinish:" setFailBackFunctionName:nil];
    [dataProvider commissionServicGetBankMesWithShopid:@""];
}

- (void)getbackFinish:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *arr = @[@{@"Name" : @"建设银行"}].mutableCopy;
        [arr addObjectsFromArray:data[@"data"]];
        self.pick1.list = arr.copy;
    });
}

- (void)getProvince {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getProvinceFinish:" setFailBackFunctionName:nil];
    [dataProvider commissionServicGetProvinceWithShopid:@""];
}

- (void)getProvinceFinish:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pick2.list = data[@"data"];
    });
}

- (void)getCity:(NSString *)pName {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getCityFinish:" setFailBackFunctionName:nil];
    [dataProvider commissionServicGetAreaMesWithShopid:@"" provincename:pName];
}

- (void)getCityFinish:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pick3.list = data[@"data"];
        
    });
}

- (void)getCode:(NSString *)areaCode backCode:(NSString *)backcode {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getCodeFinish:" setFailBackFunctionName:nil];
    [dataProvider commissionServicGetCodeWithShopid:@"" areacode:areaCode bankcode:backcode];
}

- (void)getCodeFinish:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pick4.list = data[@"data"];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
