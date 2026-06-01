//
//  ReportMapViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/25.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ReportMapViewController.h"

@interface ReportMapViewController ()



@property (nonatomic, strong) NSMutableArray *annotations;


@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@end

@implementation ReportMapViewController
@synthesize annotations = _annotations;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.mapView addAnnotations:self.annotations];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

// 自定义大头针标注
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.draggable=YES;
        annotationView.canShowCallout=YES;
        annotationView.image = [UIImage imageNamed:@"pin"];
        //设置中心心点偏移,使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -20);
        
        return annotationView;
    }
    return nil;
}
- (void)initAnnotations
{
    // 举报商家的经纬度
    self.annotations = [NSMutableArray array];
    CLLocationCoordinate2D coordinates[1] = {
        {35.1056267804, 118.3564511632},
    };
    
    for (int i = 0; i < 1; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = @"正确位置";
        [self.annotations addObject:a1];
    }
}
- (id)init
{
    self = [super init];
    if (self)
    {
        [self initAnnotations];
    }
    
    return self;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"你点的谁");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
