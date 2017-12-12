//
//  LQSearchResultManager.h
//  LocationInfoFramework
//
//  Created by liuqing on 2017/12/12.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AMapPOI;
@protocol LQSearchResultManagerDelegate <NSObject>
/**
 选中某一行搜索结果
 @param poi 选中的结果
 */
- (void)didSelectedLocationWithLocation:(AMapPOI *)poi;
/**
 请求到位置信息
 */
- (void)didGetLocationInfo;

@end

@interface LQSearchResultManager : NSObject<UITableViewDelegate,UITableViewDataSource>
/** 代理 */
@property(nonatomic,weak)id<LQSearchResultManagerDelegate>delegate;
/** 搜索关键字 */
@property(nonatomic,copy)NSString * searchKeyword;
/** 定位城市 */
@property(nonatomic,copy)NSString * city;

@end
