//
//  JSMyTransportVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "JSMyTransportVC.h"

@interface JSMyTransportVC ()<UITableViewDelegate,UITableViewDataSource>
/** <#object#> */
@property (nonatomic,retain) NSMutableArray *dataSource;
/** <#object#> */
@property (nonatomic,retain) HomeDataModel *dataModels;
@end

@implementation JSMyTransportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的运力";
    self.view.backgroundColor = PageColor;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"+" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:35];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    _dataSource = [NSMutableArray array];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@?current=%ld&size=%@",URL_LineList,self.currentPage,PageSize] parameters:param completion:^(id responseData, RequestState status, NSError *error) {
        if (weakSelf.currentPage==1) {
            [weakSelf.dataSource removeAllObjects];
        }
        weakSelf.dataModels = nil;
        if (status == Request_Success) {
            weakSelf.dataModels = [HomeDataModel mj_objectWithKeyValues:responseData];
        }
        if (weakSelf.dataSource.count<[weakSelf.dataModels.total integerValue]) {
            [weakSelf.dataSource addObjectsFromArray:weakSelf.dataModels.records];
            weakSelf.currentPage++;
        }
        if ([weakSelf.baseTabView.mj_footer isRefreshing]) {
            [weakSelf.baseTabView.mj_footer endRefreshing];
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
        if (weakSelf.dataSource.count==[weakSelf.dataModels.total integerValue]) {
            weakSelf.mainTab.mj_footer = nil;
        }
        else {
            [weakSelf addTabMJ_FootView];
        }
        [weakSelf hiddenNoDataView:weakSelf.dataSource.count];
        [weakSelf.mainTab reloadData];
    }];
}

- (void)rightBtnAction {
    UIViewController *vc = [Utils getViewController:@"Mine" WithVCName:@"JSMyTransportAddVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMyTransportTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSMyTransportTabCell"];
    cell.dataModel = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)titleBtnClickAction:(UIButton *)sender {
}
@end

