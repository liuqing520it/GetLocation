//
//  ViewController.m
//  GetLocationInfo
//
//  Created by liuqing on 2017/12/9.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import "ViewController.h"
#import "LQGetLocationInfoVC.h"

#import <MapKit/MapKit.h>

@interface ViewController ()

@property(nonatomic,strong)UIButton * pushBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushBtn.center = self.view.center;
    [self.view addSubview:self.pushBtn];

}

- (UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushBtn.frame = CGRectMake(0, 0, 100, 50);
        [_pushBtn setTitle:@"跳转" forState:UIControlStateNormal];
        [_pushBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _pushBtn.backgroundColor = [UIColor redColor];
        [_pushBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBtn;
}

- (void)pushVC{
    
    LQGetLocationInfoVC *locationVC = [[LQGetLocationInfoVC alloc]initWithApiKey:@"491fb90b01e62409cf80ec44a14bd03d"];
    
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:locationVC] animated:YES completion:nil];
}


@end
