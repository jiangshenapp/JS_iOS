//
//  JSTieziListVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/4.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSTieziListVC.h"
#import "JSTopicDetailVC.h"
#import "PostListTabCell.h"

@interface JSTieziListVC ()<UITableViewDataSource,UITableViewDelegate>
/** 数据源 */
@property (nonatomic,retain) NSMutableArray <JSPostListModel *>*dataSource;
@end

@implementation JSTieziListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子列表";
    NSLog(@"%@",_type);
    self.navBar.hidden = YES;
    _dataSource = [NSMutableArray array];
    self.baseTabView.delegate = self;
    self.baseTabView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
        [weakSelf getData];
    }];
    [self.baseTabView.mj_header beginRefreshing];
//    [self addTabMJ_FootView];
    // Do any additional setup after loading the view.
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    BOOL commentFlag=NO ;
    BOOL likeFlag=NO;
    BOOL myFlag=NO;
    if ([_type integerValue]==0) {
        commentFlag = NO;
        likeFlag = NO;
        myFlag = YES;
    }
    else if ([_type integerValue]==1) {
        commentFlag = NO;
        likeFlag = YES;
        myFlag = NO;
    }
    else if ([_type integerValue]==2) {
        commentFlag = YES;
        likeFlag = NO;
        myFlag = NO;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?circleId=&subject=&likeFlag=%d&commentFlag=%d&myFlag=%d",URL_PostList,likeFlag,commentFlag,myFlag];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            weakSelf.dataSource = [JSPostListModel mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.baseTabView reloadData];
            if ([weakSelf.baseTabView.mj_header isRefreshing]) {
                [weakSelf.baseTabView.mj_header endRefreshing];
            }
            [weakSelf hiddenNoDataView:weakSelf.dataSource.count];
        }
    }];
}


#pragma mark - UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tieziListCell"];
    JSPostListModel *model = _dataSource[indexPath.row];
    cell.dataModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSPostListModel *model = _dataSource[indexPath.row];
    JSTopicDetailVC *vc = (JSTopicDetailVC *)[Utils getViewController:@"Community" WithVCName:@"JSTopicDetailVC"];
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
