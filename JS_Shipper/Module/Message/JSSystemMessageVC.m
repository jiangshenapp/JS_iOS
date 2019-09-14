//
//  JSSystemMessageVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/9.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSSystemMessageVC.h"
#import "JSSysMsgDetailVC.h"

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
    self.view.backgroundColor = PageColor;
    self.mainTabView.delegate = self;
    self.mainTabView.dataSource = self;
    _dataSource = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    self.mainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
//    [self addTabMJ_FootView];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)getData {
    NSString *type = [AppChannel isEqualToString:@"1"]?@"3":@"2";
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
        if ([weakSelf.mainTabView.mj_footer isRefreshing]) {
            [weakSelf.mainTabView.mj_footer endRefreshing];
        }
        if ([weakSelf.mainTabView.mj_header isRefreshing]) {
            [weakSelf.mainTabView.mj_header endRefreshing];
        }
        if (weakSelf.dataSource.count==[responseData[@"total"] integerValue]) {
            weakSelf.mainTabView.mj_footer = nil;
        }
        else {
            [weakSelf addTabMJ_FootView];
        }
        [weakSelf hiddenNoDataView:weakSelf.dataSource.count];
        [weakSelf.mainTabView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMessageTabcell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMessageTabcell"];
    SysMessageModel *model = _dataSource[indexPath.section];
    cell.titleLab.text = model.title;
    cell.contentLab.text = model.content;
    cell.readLab.text = [model.isRead boolValue]?@"已读":@"未读";
    cell.imgH.constant = model.image.length==0?0:140;
    if ([model.isRead boolValue]) {
        cell.readLab.backgroundColor = RGBValue(0xF5F5F5);
        cell.readLab.textColor = RGBValue(0xB4B4B4);
    }
    else {
        cell.readLab.backgroundColor = RGBValue(0xD0021B);
        cell.readLab.textColor = RGBValue(0xFFFFFF);
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    SysMessageModel *model = _dataSource[section];
    timelab.text = model.publishTime;
    timelab.textAlignment = NSTextAlignmentCenter;
    timelab.textColor= RGBValue(0xB4B4B4);
    timelab.font = [UIFont systemFontOfSize:12];
    [view addSubview:timelab];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMessageModel *model = _dataSource[indexPath.section];
    JSSysMsgDetailVC *vc = (JSSysMsgDetailVC *)[Utils getViewController:@"Message" WithVCName:@"JSSysMsgDetailVC"];
    vc.msgID = model.ID;
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
@implementation SysMessageTabcell

@end

@implementation SysMessageModel

@end
