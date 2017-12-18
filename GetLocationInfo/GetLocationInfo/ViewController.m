//
//  ViewController.m
//  GetLocationInfo
//
//  Created by liuqing on 2017/12/9.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import "ViewController.h"
//#import "LQGetLocationInfoVC.h"
#import <LocationInfoFramework/LQGetLocationInfoVC.h>

@interface ViewController ()<LQGetLocationInfoVCDelegate>

@property(nonatomic,strong)UIButton * pushBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.pushBtn];
}

- (UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushBtn.frame = CGRectMake(0, 0, 80, 30);
        _pushBtn.center = CGPointMake(self.view.center.x, 500);
        [_pushBtn setTitle:@"跳转" forState:UIControlStateNormal];
        [_pushBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _pushBtn.backgroundColor = [UIColor redColor];
        [_pushBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBtn;
}

- (void)pushVC{
    
    LQGetLocationInfoVC *locationVC = [[LQGetLocationInfoVC alloc]initWithApiKey:@"491fb90b01e62409cf80ec44a14bd03d"];
    locationVC.delegate = self;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:locationVC] animated:YES completion:nil];
}

- (void)getLocationLatitude:(double)latitude longitude:(double)longitude province:(NSString *)province city:(NSString *)city district:(NSString *)district position:(NSString *)position{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"位置信息" message:[NSString stringWithFormat:@"经度:%f;\n纬度:%f;\n%@-%@-%@-%@",latitude,longitude,province,city,district,position] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
   
}


@end
