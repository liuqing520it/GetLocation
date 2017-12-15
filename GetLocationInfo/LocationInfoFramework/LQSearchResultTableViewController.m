//
//  LQSearchResultTableViewController.m
//  LocationInfoFramework
//
//  Created by liuqing on 2017/12/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

#import "LQSearchResultTableViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "UIScrollView+SVInfiniteScrolling.h"

@interface LQSearchResultTableViewController ()<AMapSearchDelegate>

@property(nonatomic,strong)AMapSearchAPI * searchAPI;

@property(nonatomic,strong)NSMutableArray * searchResultArray;

@property(nonatomic,assign)BOOL isFromMoreLoadRequest;

@property(nonatomic,assign)NSInteger searchPage;


@end

@implementation LQSearchResultTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];

    [self.refreshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof (self)weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
}



#pragma mark - lazy load

- (NSMutableArray *) searchResultArray
{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

- (AMapSearchAPI *)searchAPI{
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc]init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

#pragma mark - 内部控制方法

- (void)setSearchKeyword:(NSString *)searchKeyword{
    _searchKeyword = searchKeyword;
    [self searchPoi];
}

- (void)setCity:(NSString *)city{
    _city = city;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    AMapPOI *poi = [self.searchResultArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:poi.name];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
    //高亮
    NSRange textHighlightRange = [poi.name rangeOfString:self.searchKeyword];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:textHighlightRange];
    cell.textLabel.attributedText = text;
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:poi.address];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, detailText.length)];
    [detailText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, detailText.length)];
    //高亮
    NSRange detailTextHighlightRange = [poi.address rangeOfString:self.searchKeyword];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:detailTextHighlightRange];
    cell.detailTextLabel.attributedText = detailText;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectedLocationWithLocation:)]) {
        [self.delegate didSelectedLocationWithLocation:self.searchResultArray[indexPath.row]];
    }
}

- (void)searchPoi
{
    //POI关键字搜索
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = self.searchKeyword;
    request.city = self.city;
    request.cityLimit = NO;
    request.page = _searchPage;
    [self.searchAPI AMapPOIKeywordsSearch:request];
}

- (void)pullRefresh{
    _searchPage = 1;
    [self searchPoi];
}

- (void)loadMoreData
{
    _searchPage++;
    _isFromMoreLoadRequest = YES;
    [self searchPoi];
}

#pragma mark - AMapSearchDelegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    // 判断是否从更多拉取
    if (_isFromMoreLoadRequest) {
        _isFromMoreLoadRequest = NO;
    }
    else{
        [self.searchResultArray removeAllObjects];
    }
    // 刷新完成,没有数据时不显示footer
    if (response.pois.count){
        // 添加数据并刷新TableView
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            [self.searchResultArray addObject:obj];
        }];
        
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    }
}

@end
