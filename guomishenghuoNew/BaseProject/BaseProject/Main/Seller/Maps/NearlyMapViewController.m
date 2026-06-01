//
//  NearlyMapViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/26.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "NearlyMapViewController.h"

@interface NearlyMapViewController ()<AMapSearchDelegate>

@end

@implementation NearlyMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.draggable=NO;
        annotationView.canShowCallout=NO;
        //在大头针上绘制文字
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(5, 3, 30, 15)];
        lable.font=[UIFont systemFontOfSize:12];
        lable.backgroundColor = [UIColor blackColor];
        lable.textColor=[UIColor whiteColor];
        lable.layer.cornerRadius = lable.frame.size.width/8;
        
        // 搜索到附近商店的数量
        NSArray *titleArray=[NSArray arrayWithObjects:@"8 家",@"18 家",@"28 家", nil];
        for (int a=0;a<titleArray.count;a++) {
            lable.text=titleArray[a];
            NSLog(@"a is %d",a);
            NSLog(@"text is %@",lable.text);
        }
        lable.alpha = 0.6;
        [annotationView addSubview:lable];
        //设置中心心点偏移,使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -20);
        
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"点击");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
