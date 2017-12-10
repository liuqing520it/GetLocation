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
}





#pragma mark lazy load

- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CELL_HEIGHT * CELL_COUNT)];
        _mapView.delegate = self;
        _mapView.showsCompass = YES;//显示罗盘
        _mapView.showsScale = YES;//显示缩放比例
        _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, _mapView.frame.size.height - 100);//比例尺原点位置
        _mapView.showsLabels = YES;
        _mapView.zoomLevel = 15;
        _mapView.showsUserLocation = YES;//是否显示用户位置
    }
    return _mapView;
}









@end
