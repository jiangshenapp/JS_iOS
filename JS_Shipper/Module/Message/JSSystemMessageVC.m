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
/** 1运力端，2货主端 */
@property (nonatomic,copy) NSString *pushSide;
/** 分页 */
@property (nonatomic,assign) NSInteger page;
/** 数据源 */
@property (nonatomic,retain) NSMutableArray *dataSource;
@end

@implementation JSSystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    if (_isPush) {
        self.title = @"推送消息";
    }
    _pushSide = [AppChannel isEqualToString:@"1"]?@"2":@"1";
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [sender setTitle:@"全部已读" forState:UIControlStateNormal];
    sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(allReadAction) forControlEvents:UIControlEventTouchUpInside];
    sender.titleLabel.font = [UIFont systemFontOfSize:12];
//    if (_isPush) {
        self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
//    }
    
    self.baseTabView.delegate = self;
    self.baseTabView.dataSource = self;
    _dataSource = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
    _page = 1;
    [self getData];
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_isPush) {
        NSString *url = [NSString stringWithFormat:@"%@?pushSide=%@",URL_GetPushLog,_pushSide];
        [[NetworkManager sharedManager] getJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            [weakSelf handleDataStatus:status resultData:responseData];
        }];
    }
    else {
        NSString *url = [NSString stringWithFormat:@"%@?pushSide=%@&current=%ld&size=%@",URL_GetMessagePage,_pushSide,_page,PageSize];
        [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            [weakSelf handleDataStatus:status resultData:responseData];
        }];
    }
    
}

- (void)handleDataStatus:(RequestState)status resultData:(id)responseData {
    __weak typeof(self) weakSelf = self;
    if (weakSelf.page==1) {
        [weakSelf.dataSource removeAllObjects];
    }
    NSArray *tempArr;
    if ([responseData isKindOfClass:[NSArray class]]) {//推送
        tempArr = [PushMessageModel mj_objectArrayWithKeyValuesArray:responseData];;
        [weakSelf.dataSource addObjectsFromArray:tempArr];
    }
    else {
        if (status == Request_Success) {
            tempArr = [SysMessageModel mj_objectArrayWithKeyValuesArray:responseData[@"records"]];
        }
        if (weakSelf.dataSource.count<[responseData[@"total"] integerValue]) {
            [weakSelf.dataSource addObjectsFromArray:tempArr];
            weakSelf.page++;
        }
        if (weakSelf.dataSource.count==[responseData[@"total"] integerValue]) {
            weakSelf.baseTabView.mj_footer = nil;
        }
        else {
            [weakSelf addTabMJ_FootView];
        }
    }
    if ([weakSelf.baseTabView.mj_footer isRefreshing]) {
        [weakSelf.baseTabView.mj_footer endRefreshing];
    }
    if ([weakSelf.baseTabView.mj_header isRefreshing]) {
        [weakSelf.baseTabView.mj_header endRefreshing];
    }
    [weakSelf hiddenNoDataView:weakSelf.dataSource.count];
    [weakSelf.baseTabView reloadData];
}

- (void)allReadAction {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = @"";
    if (_isPush) {
        url = [NSString stringWithFormat:@"%@?pushSide=%@",URL_ReadAllPushLog,_pushSide];
        
    }
    else {
        url = [NSString stringWithFormat:@"%@?pushSide=%@",URL_ReadAllMessage,_pushSide];
    }
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        [weakSelf.baseTabView.mj_header beginRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSSysMessageTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMessageTabcell"];
    BOOL isRead;
    if (_isPush) {
        PushMessageModel *model = _dataSource[indexPath.section];
        cell.titleLab.text = model.templateName;
        cell.contentLab.text = model.pushContent;
        isRead = [model.state boolValue];
    }
    else {
        SysMessageModel *model = _dataSource[indexPath.section];
        [cell.msgImgView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        cell.titleLab.text = model.title;
        cell.contentLab.text = model.content;
        cell.imgH.constant = model.image.length==0?0:140;
        isRead = [model.isRead boolValue];

    }
    
    if (isRead) {
        cell.readLab.backgroundColor = RGBValue(0xF5F5F5);
        cell.readLab.textColor = RGBValue(0xB4B4B4);
    }
    else {
        cell.readLab.backgroundColor = RGBValue(0xD0021B);
        cell.readLab.textColor = RGBValue(0xFFFFFF);
    }
    cell.readLab.text = isRead?@" 已读 ":@" 未读 ";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    if (_isPush==NO) {
        SysMessageModel *model = _dataSource[section];
        timelab.text = model.publishTime;
    }
    else {
        PushMessageModel *model = _dataSource[section];
        timelab.text = model.pushTime;
    }
    timelab.textAlignment = NSTextAlignmentCenter;
    timelab.textColor= RGBValue(0xB4B4B4);
    timelab.font = [UIFont systemFontOfSize:12];
    [view addSubview:timelab];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMessageModel *model = _dataSource[indexPath.section];
    if ([NSString isEmpty:model.image]) {
        return 100;
    } else {
        return 240;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMessageModel *model=_dataSource[indexPath.section] ;
    JSSysMsgDetailVC *vc = (JSSysMsgDetailVC *)[Utils getViewController:@"Message" WithVCName:@"JSSysMsgDetailVC"];
    if (_isPush) {
        PushMessageModel *tempModel = _dataSource[indexPath.section];
        vc.pushModel = tempModel;
        if ([tempModel.state boolValue]==NO) {
            __weak typeof(self) weakSelf = self;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@?id=%@&pushSide=%@",URL_ReadPushLog,model.ID,_pushSide] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
                if (status==Request_Success) {
                    tempModel.state = @"1";
                }
                [weakSelf.baseTabView reloadData];
            }];
        }
    }
    else {
        SysMessageModel *tempModel = _dataSource[indexPath.section];
        vc.sysModel = tempModel;
        if ([tempModel.isRead boolValue]==NO) {
            __weak typeof(self) weakSelf = self;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@?messageId=%@&pushSide=%@",URL_ReadMessage,model.ID,_pushSide] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
                if (status==Request_Success) {
                    tempModel.isRead = @"1";
                }
                [weakSelf.baseTabView reloadData];
            }];
        }
    }
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
