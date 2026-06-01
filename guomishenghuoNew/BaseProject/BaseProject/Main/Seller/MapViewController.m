//
//  MapViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/19.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()<CLLocationManagerDelegate>


@property (nonatomic, strong)CLLocation *currentLocation;
@property (nonatomic, strong)AMapSearchAPI *search;
@property(nonatomic,strong)CLLocationManager *locMgr;
@end

@implementation MapViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_app_ hiddenTabBar];
    // 定位开启
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}
- (CLLocationManager *)locMgr{
    if (_locMgr==nil) {
        //1.创建位置管理器（定位用户的位置）
        self.locMgr=[[CLLocationManager alloc]init];
        //2.设置代理
        self.locMgr.delegate=self;
    }
    return _locMgr;
}

#pragma mark-CLLocationManagerDelegate
/**
 53  *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
 54  */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *loc = [locations firstObject];
    //维度：loc.coordinate.latitude
    //经度：loc.coordinate.longitude
    NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    NSLog(@"%lu",(unsigned long)locations.count);
    //35.1046267804,
    //118.3564511632
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(loc.coordinate.latitude,loc.coordinate.longitude);
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    [self.locMgr stopUpdatingLocation];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_app_ showTabBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AMapServices sharedServices].apiKey = @"1a12c8f1a5512850a4958e4fcbf8673c";
    [self.view addSubview:self.mapView];
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位用户的位置
        [self.locMgr startUpdatingLocation];
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locMgr.distanceFilter=kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locMgr.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
    }else
    {
        //不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
    }
}
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, SCREEN_HEIGHT-64)];
        _mapView.delegate = self;
        _mapView.mapType = MAMapTypeStandard;
        //        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        [_mapView setZoomLevel:15.1 animated:YES];
    }
    return _mapView;
}



/*
// 获取用户经纬度
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    // 获取经纬度并记录在这个变量中
    _currentLocation = [userLocation.location copy];
}



// 点击定位annotation时进行范地理编码进行编码查询
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self initAction];
    }
}
- (void)initAction{
    if (_currentLocation) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];// 经度和纬度
        [_search AMapReGoecodeSearch:request];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    NSLog(@"======%@=====", response);
    NSString *str = response.regeocode.addressComponent.city;//addressComponent包含用户当前地址
    if (str.length == 0) {
        str = response.regeocode.addressComponent.province;
    }
    _mapView.userLocation.title = str; // 定位标注点要显示的标题信息
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;// 子标题
}
#pragma mark 搜索
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    //发起输入提示搜索
//    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
//    //关键字
//    tipsRequest.keywords = _searchController.searchBar.text;
//    //城市
//    tipsRequest.city = _currentCity;
//    
//    //执行搜索
//    [_search AMapInputTipsSearch: tipsRequest];
    
}
//周边搜索
- (IBAction)searchAction:(id)sender {
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    //当前位置
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    
    //关键字
//    request.keywords = _searchController.searchBar.text;
//    NSLog(@"%@",_searchController.searchBar.text);
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    //    request.types = @"餐饮服务|生活服务";
    request.radius =  5000;//<! 查询半径，范围：0-50000，单位：米 [default = 3000]
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch:request];
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
//    
//    [self.dataList removeAllObjects];
//    for (AMapPOI *p in response.pois) {
//        NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@,%@", p.description,p.name,p.address]);
//        
//        //搜索结果存在数组
//        [self.dataList addObject:p];
//    }
//    
//    _isSelected = YES;
//    [self.tableView reloadData];
    
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
