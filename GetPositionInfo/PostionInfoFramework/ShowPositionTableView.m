//
//  ShowPositionTableView.m
//  PostionInfoFramework
//
//  Created by liuqing on 2017/12/15.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import "ShowPositionTableView.h"
#import <MapKit/MapKit.h>

@interface ShowPositionTableView()<UITableViewDelegate,UITableViewDataSource>
/** 记录选中哪一行 */
@property(nonatomic,strong)NSIndexPath * selectedIndexPath;

@end

@implementation ShowPositionTableView

static NSString * PROPERTYSTR = @"positionsInfo";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        
        //监听数组的变化
        [self addObserver:self forKeyPath:PROPERTYSTR options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:PROPERTYSTR];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:PROPERTYSTR]) {
        [self reloadData];
    }
    
}

#pragma mark - lazy-load

- (NSArray *)positionsInfo{
    if (!_positionsInfo) {
        _positionsInfo = [NSArray array];
    }
    return _positionsInfo;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.positionsInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    MKMapItem *map = self.positionsInfo[indexPath.row];
    
    cell.textLabel.text = map.placemark.name;
//    cell.textLabel.text = point.name;
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.frame = cell.frame;
        cell.textLabel.font = [UIFont systemFontOfSize:20.f];
        cell.detailTextLabel.text = @"";
    }
    else {
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.detailTextLabel.text = map.placemark.thoroughfare;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    cell.accessoryType = (self.selectedIndexPath.row == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ///单选打勾
    NSInteger newRow = indexPath.row;
    NSInteger oldRow = self.selectedIndexPath != nil ? self.selectedIndexPath.row : -1;
    if (newRow != oldRow) {
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.selectedIndexPath = indexPath;
    
    ///移动地图位置
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}


@end


