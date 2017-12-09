//
//  LQGetLocationInfoVC.h
//  LocationInfoFramework
//
//  Created by liuqing on 2017/12/9.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LQGetLocationInfoVCDelegate <NSObject>

/**
 获取地理位置信息
 @param latitude 经度
 @param longitude 纬度
 @param province 省市区
 @param position 详细位置信息
 */
- (void)getLocationLatitude:(double)latitude longitude:(double)longitude provinceInfo:(NSString *)province position:(NSString *)position;

@end

@interface LQGetLocationInfoVC : UIViewController
/** 代理 */
@property(nonatomic,weak)id<LQGetLocationInfoVCDelegate> delegate;
/**
 高德地图注册
 @param apiKey 高德地图开发者网站申请的key
 @return 对象
 */
- (instancetype)initWithApiKey:(NSString *)apiKey;

@end
