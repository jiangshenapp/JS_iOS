//
//  JSSystemMessageVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/9.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSSystemMessageVC.h"

@interface JSSystemMessageVC ()<UITableViewDelegate,UITableViewDataSource>
/** 分页 */
@property (nonatomic,assign) NSInteger page;
/** 数据源 */
@property (nonatomic,retain) NSMutableArray <SysMessageModel *>*dataSource;
@end

@implementation JSSystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    self.baseTabView.delegate = self;
    self.baseTabView.dataSource = self;
    _dataSource = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.baseTabView setContentOffset:CGPointMake(0, 0)];
        [weakSelf getData];
    }];
    [self addTabMJ_FootView];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)getData {
    NSString *type = [AppChannel isEqualToString:@"1"]?@"3":@"2";
    type = @"1";
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@?current=%ld&size=%@",URL_MessageList,type,_page,PageSize];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (weakSelf.page==1) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *tempArr;
        if (status == Request_Success) {
            tempArr = [SysMessageModel mj_objectArrayWithKeyValuesArray:responseData[@"records"]];
        }
        if (weakSelf.dataSource.count<[responseData[@"total"] integerValue]) {
            [weakSelf.dataSource addObjectsFromArray:tempArr];
            weakSelf.page++;
        }
        if ([weakSelf.baseTabView.mj_footer isRefreshing]) {
            [weakSelf.baseTabView.mj_footer endRefreshing];
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
        if (weakSelf.dataSource.count==[responseData[@"total"] integerValue]) {
            weakSelf.baseTabView.mj_footer = nil;
        }
        else {
            [weakSelf addTabMJ_FootView];
        }
        [weakSelf hiddenNoDataView:weakSelf.dataSource.count];
        [weakSelf.baseTabView reloadData];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMessageTabcell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMessageTabcell"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    timelab.text = @"02-28 13:03";
    timelab.textAlignment = NSTextAlignmentCenter;
    timelab.textColor= RGBValue(0xB4B4B4);
    timelab.font = [UIFont systemFontOfSize:12];
    [view addSubview:timelab];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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
@implementation SysMessageTabcell

@end

@implementation SysMessageModel

@end
