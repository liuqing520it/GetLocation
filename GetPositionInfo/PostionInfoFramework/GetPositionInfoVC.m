//
//  GetPositionInfoVC.m
//  PostionInfoFramework
//
//  Created by liuqing on 2017/12/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import "GetPositionInfoVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
/** 搜索栏高度 */
#define SEARCHBAR_HEIGHT                44.f
/** 导航栏和状态栏高 */
#define NAVANDSTATUSHEIGHT              64.f
/** 搜索结果tableViewcell的高度 */
#define CELL_HEIGHT                     55.f
/** 搜索结果每次展示几个 */
#define CELL_COUNT                      5

@interface GetPositionInfoVC ()<CLLocationManagerDelegate,
                                UISearchResultsUpdating,
                                MKMapViewDelegate>
/** 地图view展示地图信息 */
@property(nonatomic,strong)MKMapView *mapView;
/** 授权信息 */
@property(nonatomic,strong)CLLocationManager *locationManager;
/** 搜索控制器 */
@property(nonatomic,strong)UISearchController * searchController;
/** 搜索类 */
@property(nonatomic,strong)MKLocalSearch * localSearch;
/** 记录第一次定位 */
@property(nonatomic,assign)BOOL isFirstLocated;
/** 由于点击searchBar要将整体上移,移动self.view不起作用,迫不得已添加一个contentView在view上移动contentView */
@property(nonatomic,strong)UIView * mapContentView;
/** 回到定位点图标 */
@property(nonatomic,strong)UIImageView *centerMaker;
/** 定位按钮 */
@property(nonatomic,strong)UIButton *locationButton;


@end

@implementation GetPositionInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///开启定位服务
    [self checkLocationServices];
    
    //设置导航栏
    [self setUpNavigationBar];
    
    [self configUI];
    
}

/**
 设置状态栏
 @return 黑底白字
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - privite method
/**
 检查定位服务是否开启
 */
- (void)checkLocationServices{
    ///info.plist字典
    NSArray *infoKeys = [[[NSBundle mainBundle] infoDictionary] allKeys];
    
    if (![infoKeys containsObject:@"NSLocationAlwaysAndWhenInUseUsageDescription"]) {
        NSLog(@"请在info.plist中配置相关key--> Privacy - Location Always and When In Use Usage Description");
    }
    if(![infoKeys containsObject:@"NSLocationWhenInUseUsageDescription"]){
        NSLog(@"请在info.plist中配置相关key--> Privacy - Location When In Use Usage Description");
    }
    ///如果没有授权则申请授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

/**
 设置导航栏
 */
- (void)setUpNavigationBar{
    ///左侧取消按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    ///标题
    self.navigationItem.title = @"位置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    ///右侧 确定按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(conformBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.4475560784 green:0.8532296419 blue:0.1005850509 alpha:1.0],NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    
    [self setUpNavigationItem];
}

/**
 设置导航栏背景色
 */
- (void)setUpNavigationItem{
    if (@available(iOS 11.0,*)) {
        self.navigationItem.searchController = self.searchController;
        UISearchBar *searchBar = self.searchController.searchBar;
        searchBar.tintColor = [UIColor whiteColor];
        searchBar.barTintColor = [UIColor whiteColor];
        UITextField *textfield = [searchBar valueForKey:@"searchField"];
        textfield.textColor = [UIColor blackColor];
        UIView *backgroundView = textfield.subviews.firstObject;
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.layer.cornerRadius = 10;
        backgroundView.clipsToBounds = TRUE;
    }
    self.definesPresentationContext = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)configUI{
    [self.view addSubview:self.mapContentView];
    [self.mapContentView addSubview:self.mapView];
    [self.mapView addSubview:self.locationButton];
    [self.mapView addSubview:self.centerMaker];
}

///回到定位点
- (void)actionLocation{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

#pragma mark - click event

- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)conformBtnClick{
    
}

#pragma mark - Lazyload 懒加载

- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 52 + NAVANDSTATUSHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - CELL_HEIGHT * CELL_COUNT)];
        _mapView.mapType = MKMapTypeMutedStandard;//地图样式
        _mapView.delegate = self;
        _mapView.showsScale = YES;
        _mapView.showsCompass = YES;
        _mapView.zoomEnabled = YES;
        _mapView.scrollEnabled = YES;
        _mapView.rotateEnabled = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;//跟踪用户的位置变化
    }
    return _mapView;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (MKLocalSearch *)localSearch{
    if (!_localSearch) {
        _localSearch = [[MKLocalSearch alloc]init];
    }
    return _localSearch;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.placeholder = @"搜索地点";
    }
    return _searchController;
}

- (UIView *)mapContentView{
    if (!_mapContentView) {
        _mapContentView = [[UIView alloc]initWithFrame:self.view.bounds];
    }
    return _mapContentView;
}

- (UIImageView *)centerMaker{
    if (!_centerMaker) {
        UIImage *image = [UIImage imageNamed:@"AMap3D.bundle/redPin_lift"];
        _centerMaker = [[UIImageView alloc]initWithImage:image];
        [_centerMaker setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _centerMaker.center =  CGPointMake(SCREEN_WIDTH / 2, CGRectGetHeight(_mapView.bounds)*0.5f);
    }
    return _centerMaker;
}


- (UIButton *)locationButton{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.frame = CGRectMake(CGRectGetWidth(self.mapView.bounds)-50, CGRectGetHeight(self.mapView.bounds)-50, 40, 40);
        _locationButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_locationButton setImage:[UIImage imageNamed:@"AMap3D.bundle/gpsnormal"] forState:UIControlStateNormal];
        [_locationButton setImage:[UIImage imageNamed:@"AMap3D.bundle/gpsselected"] forState:UIControlStateSelected];
        [_locationButton addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还未决定授权定位服务!");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"定位服务受限!");
            break;
        case kCLAuthorizationStatusDenied:
            if([CLLocationManager locationServicesEnabled]){
                NSLog(@"定位服务授权被用户拒绝!");
            }
            else{
                NSLog(@"定位服务未开启!");
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"定位服务始终开启!");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"定位服务使用期间开启!");
            break;
        default:
            break;
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (userLocation && !_isFirstLocated) {
        
        [self didStartRequestNearPositions];
        //创建编码对象
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        //反地理编码
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error!=nil || placemarks.count==0) {
                return ;
            }
            //获取地标
            CLPlacemark *placemark = [placemarks firstObject];
            //设置标题
            userLocation.title = placemark.locality;
            //设置子标题
            userLocation.subtitle = placemark.name;
            
            //[self fetchNearbyInfo:userLocation.location.coordinate.latitude andT:userLocation.location.coordinate.longitude];
        }];
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        _isFirstLocated = YES;
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self didStartRequestNearPositions];
}
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    return nil;
//}

- (void)didStartRequestNearPositions{
    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc]init];

    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    //创建一个以center为中心，上下各500米，左右500米的区域，但其是一个矩形
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000 ,1000 );
    
    requst.region = region;
    requst.naturalLanguageQuery = @"wuhan";
    
    self.localSearch = [[MKLocalSearch alloc]initWithRequest:requst];
    
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSLog(@"%@",response.mapItems);
        }
        else{
            NSLog(@"<<<<<<----->>>>>>>%@",error.localizedDescription);
        }
    }];
    
}



@end
















