//
//  ViewController.m
//  GetPositionInfo
//
//  Created by liuqing on 2017/12/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import "ViewController.h"
#import "GetPositionInfoVC.h"

@interface ViewController ()

@property(nonatomic,strong)UIButton *pushBtn;

@property(nonatomic,strong)UILabel *showResultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.pushBtn];
    [self.view addSubview:self.showResultLabel];
}

- (UILabel *)showResultLabel{
    if (!_showResultLabel) {
        _showResultLabel = [[UILabel alloc]init];
        _showResultLabel.frame = CGRectMake(0, 0, 300, 100);
        _showResultLabel.center = CGPointMake(self.view.center.x, 300);
        _showResultLabel.textColor = [UIColor blackColor];
    }
    return _showResultLabel;
}

- (UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushBtn.frame = CGRectMake(0, 0, 80, 30);
        _pushBtn.center = CGPointMake(self.view.center.x, 500);
        [_pushBtn setTitle:@"push" forState:UIControlStateNormal];
        [_pushBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _pushBtn.backgroundColor = [UIColor orangeColor];
        [_pushBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBtn;
}

- (void)pushVC{
    
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:[[GetPositionInfoVC alloc]init]] animated:YES completion:nil];
}

@end
