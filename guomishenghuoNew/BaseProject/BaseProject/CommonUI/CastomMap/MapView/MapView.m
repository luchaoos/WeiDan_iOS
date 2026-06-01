//
//  MapView.m
//
//
//  Created by Jian-Ye on 12-10-16.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "MapView.h"
#import "CallOutAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "CCLocationManager.h"


@interface MapView ()<MKMapViewDelegate,CallOutAnnotationViewDelegate>{
    BOOL isInitIFlag;
}

@property (nonatomic,weak)id<MapViewDelegate> delegate;

@property (nonatomic,strong)CalloutMapAnnotation *calloutAnnotation;
@end

@implementation MapView

@synthesize mapView = _mapView;
@synthesize delegate = _delegate;

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        mapView.delegate = self;
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            mapView.centerCoordinate = CLLocationCoordinate2DMake(locationCorrrdinate.latitude, locationCorrrdinate.longitude);
            
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(locationCorrrdinate.latitude, locationCorrrdinate.longitude);
            //放大地图到自身的经纬度位置。
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
            [self.mapView setRegion:region animated:YES];

        }];
        
        
        [self addSubview:mapView];
        self.mapView =  mapView;

        self.span = 40000;
        
        isInitIFlag = YES;
    }
    return self;
}

//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (isInitIFlag) {
        isInitIFlag = NO;
        CLLocationCoordinate2D loc = [userLocation coordinate];
        //放大地图到自身的经纬度位置。
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
        [self.mapView setRegion:region animated:YES];
    }
}

- (id)initWithDelegate:(id<MapViewDelegate>)delegate
{
    if (self = [self init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
    [super setFrame:frame];
}

- (void)beginLoad
{
    for (int i = 0; i < [_delegate numbersWithCalloutViewForMapView]; i++) {
        
        CLLocationCoordinate2D location = [_delegate coordinateForMapViewWithIndex:i];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location,_span ,_span );
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:location.latitude andLongitude:location.longitude tag:i];
        [_mapView   addAnnotation:annotation];
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        BasicMapAnnotation *annotation = (BasicMapAnnotation *)view.annotation;
        
        if (_calloutAnnotation.coordinate.latitude == annotation.latitude&&
            _calloutAnnotation.coordinate.longitude == annotation.longitude)
        {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            self.calloutAnnotation = nil;
        }
        self.calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:annotation.latitude
                              andLongitude:annotation.longitude
                                  tag:annotation.tag];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
}

- (void)didSelectAnnotationView:(CallOutAnnotationView *)view
{
    CalloutMapAnnotation *annotation = (CalloutMapAnnotation *)view.annotation;
    if([_delegate respondsToSelector:@selector(calloutViewDidSelectedWithIndex:)])
    {
        [_delegate calloutViewDidSelectedWithIndex:annotation.tag];
    }
    
    [self mapView:_mapView didDeselectAnnotationView:view];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_calloutAnnotation)
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            [mapView removeAnnotation:_calloutAnnotation];
            self.calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotation *calloutAnnotation = (CalloutMapAnnotation *)annotation;
        
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView)
        {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView" delegate:self];
        }
        for (UIView *view in  annotationView.contentView.subviews) {
            [view removeFromSuperview];
        }
        [annotationView.contentView addSubview:[_delegate mapViewCalloutContentViewWithIndex:calloutAnnotation.tag]];
        return annotationView;
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        BasicMapAnnotation *basicMapAnnotation = (BasicMapAnnotation *)annotation;
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [_delegate baseMKAnnotationViewImageWithIndex:basicMapAnnotation.tag];
        }
		
		return annotationView;
    }
	return nil;
}

@end
