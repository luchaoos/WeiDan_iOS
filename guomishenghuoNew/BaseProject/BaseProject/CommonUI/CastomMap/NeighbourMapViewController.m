//
//  NeighbourMapViewController.m
//  LikeAttention
//
//  Created by 于金祥 on 15/8/29.
//  Copyright (c) 2015年 zykj.LikeAttention. All rights reserved.
//

#import "NeighbourMapViewController.h"
#import "MapView.h"
#import "Item.h"
#import "TestMapCell.h"
#import "AppDelegate.h"
#import "CCLocationManager.h"
#import "Index_ShopInfoViewController.h"

@interface NeighbourMapViewController ()<MapViewDelegate>
@property (nonatomic,strong)MapView *mapView;
@property (nonatomic,strong)NSMutableArray *annotations;

@end

@implementation NeighbourMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"附近商家";
    _lblTitle.textColor=[UIColor whiteColor];

    self.annotations = [[NSMutableArray alloc] init];
    
    for (NSDictionary * itemdict in self.shopArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:Zy_JudgeIsNull(ZY_NSStringFromFormat(@"%@",itemdict[@"Id"])) forKey:@"merchantid"];
        [dic setValue:Zy_JudgeIsNull(ZY_NSStringFromFormat(@"%@",itemdict[@"Lat"])) forKey:@"latitude"];
        [dic setValue:Zy_JudgeIsNull(ZY_NSStringFromFormat(@"%@",itemdict[@"Lng"])) forKey:@"longitude"];
        [dic setValue:Zy_JudgeIsNull(ZY_NSStringFromFormat(@"%@",itemdict[@"Name"])) forKey:@"title"];
        [dic setValue:Zy_JudgeIsNull(ZY_NSStringFromFormat(@"%@",itemdict[@"Address"])) forKey:@"subtitle"];
        [self.annotations addObject:dic];
    }
    
    
//    for (int i = 0; i < _shopArray.count; i++) {
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        NSLog(@"%@",_shopArray);
//        NSString *merchantid = [[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"merchantid"]] isEqual:@"<null>"]?@"":[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"merchantid"]];
//        [dic setValue:merchantid forKey:@"merchantid"];
//        NSString *latitude = [[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"latitude"]] isEqual:@"<null>"]?@"":[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"latitude"]];
//        [dic setValue:latitude forKey:@"latitude"];
//        NSString *longitude = [[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"longitude"]] isEqual:@"<null>"]?@"":[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"longitude"]];
//        [dic setValue:longitude forKey:@"longitude"];
//        NSString *name = [[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"name"]] isEqual:@"<null>"]?@"":[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"name"]];
//        [dic setValue:name forKey:@"title"];
//        NSString *remark = [[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"remark"]] isEqual:@"<null>"]?@"":[NSString stringWithFormat:@"%@",[_shopArray[i] valueForKey:@"remark"]];
//        [dic setValue:remark forKey:@"subtitle"];
//        [self.annotations addObject:dic];
//    }
    
    self.mapView = [[MapView alloc] initWithDelegate:self];
    [self.view addSubview:_mapView];
    [_mapView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_mapView beginLoad];
}


#pragma mark -
#pragma mark delegate

- (NSInteger)numbersWithCalloutViewForMapView
{
    return _annotations.count;
}

- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index
{
    Item *item = [[Item alloc] initWithDictionary:[_annotations objectAtIndex:index]];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [item.latitude doubleValue];
    coordinate.longitude = [item.longitude doubleValue];
    return coordinate;
}

- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"pin"];
}

- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index
{
    Item *item = [[Item alloc] initWithDictionary:[_annotations objectAtIndex:index]];
    TestMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"TestMapCell" owner:self options:nil] objectAtIndex:0];
    cell.title.text = item.title;
    cell.subtitle.text = item.subtitle;
    return cell;
}

- (void)calloutViewDidSelectedWithIndex:(NSInteger)index
{
    NSLog(@"%@",[_annotations objectAtIndex:index]);
    Index_ShopInfoViewController *shopInfoVC = [[Index_ShopInfoViewController alloc] init];
    shopInfoVC.shopID = [_annotations objectAtIndex:index][@"merchantid"];
    [self.navigationController pushViewController:shopInfoVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


@end
