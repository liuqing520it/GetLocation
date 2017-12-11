//
//  LQGetLocationInfoVC.m
//  LocationInfoFramework
//
//  Created by liuqing on 2017/12/9.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import "LQGetLocationInfoVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
/** 屏幕宽 */
#define SCREEN_WIDTH    CGRectGetWidth([UIScreen mainScreen].bounds)
/** 屏幕高 */
#define SCREEN_HEIGHT   CGRectGetHeight([UIScreen mainScreen].bounds)
/** 搜索栏高度 */
#define SEARCHBAR_HEIGHT                44.f
/** 导航栏和状态栏高 */
#define NAVANDSTATUSHEIGHT              64.f
/** 搜索结果tableViewcell的高度 */
#define CELL_HEIGHT                     55.f
/** 搜索结果每次展示几个 */
#define CELL_COUNT                      5

@interface LQGetLocationInfoVC () <MAMapViewDelegate>
/** 地图view 展示地图信息 */
@property(nonatomic,strong)MAMapView *mapView;
/** 搜索类 */
@property(nonatomic,strong)AMapSearchAPI *searchAPI;
/** 回到定位点图标 */
@property(nonatomic,strong)UIImageView *centerMaker;
/** 定位按钮 */
@property(nonatomic,strong)UIButton *locationButton;
/**  */
@property(nonatomic,assign)BOOL isMapViewRegionChangedFromTableView;
/** 记录第一次定位 */
@property(nonatomic,assign)BOOL isFirstLocated;
/** 记录当前page */
@property(nonatomic,assign)NSInteger searchPage;

@end

@implementation LQGetLocationInfoVC

/**
 初始化方法
 @param apiKey 高德地图注册的apiKey
 @return 示例对象
 */
- (instancetype)initWithApiKey:(NSString *)apiKey{
    if (self = [super init]){
        ///APIkey。设置key，需要绑定对应的bundle id。
        [AMapServices sharedServices].apiKey = apiKey;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [AMapServices sharedServices].enableHTTPS = YES;
    
    //设置导航栏
    [self setUpNavigationBar];
    ///添加子控件
    [self configUI];
    
}

#pragma mark - 内部控制方法

/**
 设置导航栏
 */
- (void)setUpNavigationBar{
    self.navigationItem.title = @"位置";
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    ///取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    
    ///确认按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmBtn];
    
}

//取消点击
- (void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//确认按钮点击
- (void)confirmClick{
    ///代理回调
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getLocationLatitude:longitude:province:city:district:position:) ]) {
        
    }
}

#pragma mark - addSubView

- (void)configUI{
    [self.view addSubview:self.mapView];
    [self.mapView addSubview:self.locationButton];
    [self.mapView addSubview:self.centerMaker];
}


- (void)actionLocation{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}


#pragma mark lazy load

- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CELL_HEIGHT * CELL_COUNT)];
        _mapView.delegate = self;
        _mapView.showsCompass = YES;//显示罗盘
        _mapView.showsScale = YES;//显示缩放比例
        _mapView.scaleOrigin = CGPointMake(_mapView.frame.origin.x + 10, _mapView.frame.size.height - 80);//比例尺原点位置
        _mapView.showsLabels = YES;
        _mapView.zoomLevel = 15;
        _mapView.showsUserLocation = YES;//是否显示用户位置
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
    return _mapView;
}

- (UIImageView *)centerMaker{
    if (!_centerMaker) {
        UIImage *image = [UIImage imageNamed:@"AMap3D.bundle/redPin_lift"];
        _centerMaker = [[UIImageView alloc]initWithImage:image];
        [_centerMaker setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _centerMaker.center =  CGPointMake(SCREEN_WIDTH / 2, CGRectGetHeight(_mapView.bounds)* 0.5f - SEARCHBAR_HEIGHT/2.f - 10.f);
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


#pragma mark - MAMapViewDelegate

//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    // 首次定位
//    if (updatingLocation && !self.isFirstLocated) {
//        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
//        self.isFirstLocated = YES;
//    }
//}
//
//- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    if (!self.isMapViewRegionChangedFromTableView && self.isFirstLocated) {
//        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
//        [self searchReGeocodeWithAMapGeoPoint:point];
//        [self searchPoiByAMapGeoPoint:point];
//        // 范围移动时当前页面数重置
//        self.searchPage = 1;
//        [self checkThePinIsInCurrentLocationCenter];
//    }
//    
//    self.isMapViewRegionChangedFromTableView = NO;
//}
//
//#pragma mark locationButton 的选中状态改变 根据 大头针是否在定位点
//
//- (void)checkThePinIsInCurrentLocationCenter{
//    NSString *mapViewLatitude = [NSString stringWithFormat:@"%0.4f",self.mapView.userLocation.location.coordinate.latitude];
//    NSString *mapViewLongitude = [NSString stringWithFormat:@"%0.4f",self.mapView.userLocation.location.coordinate.longitude];
//    NSString *pointLatitude = [NSString stringWithFormat:@"%0.4f",self.mapView.centerCoordinate.latitude];
//    NSString *pointLongitude = [NSString stringWithFormat:@"%0.4f",self.mapView.centerCoordinate.longitude];
//    
//    if ([mapViewLatitude isEqualToString:pointLatitude] && [mapViewLongitude isEqualToString:pointLongitude]) {
//        self.locationButton.selected = YES;
//    }
//    else{
//        self.locationButton.selected = NO;
//    }
//}
//
//
//
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
//        static NSString *reuseIndetifier = @"anntationReuseIndetifier";
//        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        if (!annotationView) {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
//            annotationView.image = [UIImage imageNamed:@"msg_location"];
//            annotationView.centerOffset = CGPointMake(0, -18);
//        }
//        return annotationView;
//    }
//    return nil;
//}
//
//// 搜索逆向地理编码-AMapGeoPoint
//- (void)searchReGeocodeWithAMapGeoPoint:(AMapGeoPoint *)location
//{
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = location;
//    // 返回扩展信息
//    regeo.requireExtension = YES;
//    [self.searchAPI AMapReGoecodeSearch:regeo];
//}
//
//// 搜索中心点坐标周围的POI-AMapGeoPoint
//- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location
//{
//    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
//    request.location = location;
//    // 搜索半径
//    request.radius = 1000;
//    // 搜索结果排序
//    request.sortrule = 1;
//    // 当前页数
//    request.page = self.searchPage;
//    [self.searchAPI AMapPOIAroundSearch:request];
//}




@end





























