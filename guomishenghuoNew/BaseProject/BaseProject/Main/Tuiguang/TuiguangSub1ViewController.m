//
//  TuiguangSub1ViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/5.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "TuiguangSub1ViewController.h"

@interface TuiguangSub1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;


@end

@implementation TuiguangSub1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"TuiguangSub1Cell" owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 25.f;
    self.image.layer.masksToBounds = YES;
}

@end

@interface TuiguangSub1ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *list;

@end

@implementation TuiguangSub1ViewController

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)segmentSelect:(UISegmentedControl *)sender {
    NSLog(@"%ld", [sender selectedSegmentIndex]);
    [self getData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[].copy;
    
    _lblTitle.text=@"推广团队";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getData];
}

- (void)getData {
    [SVProgressHUD show];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getDataFinish:" setFailBackFunctionName:nil];
    [dataProvider shopIndexServiceGetSubordinateListWithShopid:get_sp(user_ID) type:[NSString stringWithFormat:@"%ld", self.segment.selectedSegmentIndex]];
}



- (void)getDataFinish:(NSDictionary *)data {
    NSLog(@"%@", data);
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            self.list = [data[@"data"] copy];
            [self.tableView reloadData];
        });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"TuiguangSub1Cell";
    TuiguangSub1Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TuiguangSub1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:self.list[indexPath.row][@"PhotoPath"]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    cell.label1.text = self.list[indexPath.row][@"Name"];
    if (!cell.label1.text || cell.label1.text.length == 0) {
        cell.label1.text = @"(未设置)";
    }
    cell.label2.text = self.list[indexPath.row][@"RegTime"];
    cell.label3.text = [NSString stringWithFormat:@"佣金：%.2lf", [self.list[indexPath.row][@"Money"] doubleValue]];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
