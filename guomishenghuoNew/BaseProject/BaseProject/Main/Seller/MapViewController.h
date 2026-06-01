//
//  MapViewController.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/19.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface MapViewController : BaseViewController<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end
