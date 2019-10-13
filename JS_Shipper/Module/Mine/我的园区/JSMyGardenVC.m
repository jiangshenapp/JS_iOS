//
//  JSMyGardenVC.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSMyGardenVC.h"
#import "JSCarSourceDetailVC.h"
#import "JSLineDetaileVC.h"
#import "HomeDataModel.h"
#import "RecordsModel.h"
#import "JSGardenTabCell.h"
#import "CityDeliveryTabCell.h"

@interface JSMyGardenVC ()<UITableViewDelegate,UITableViewDataSource>

/** 分页 */
@property (nonatomic,assign) NSInteger page;
/** 0车源  1城市配送 2精品路线 */
@property (nonatomic,assign) NSInteger pageFlag;
/** 传参字典 0 */
@property (nonatomic,retain) NSDictionary *postUrlDic;
/** 数据源 */
@property (nonatomic,retain) HomeDataModel *dataModels;
/** 数据源 */
@property (nonatomic,retain) NSMutableArray <RecordsModel *>*dataSource;

@end

@implementation JSMyGardenVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"我的园区";
    
    self.view.backgroundColor = kWhiteColor;
    
    [self initView];
    [self getData];
}

- (void)initView {
    _pageFlag = 0;
    _page = 1;
    _dataSource = [NSMutableArray array];
    _postUrlDic = @{@(0):URL_LineList,@(1):URL_ParkList,@(2):URL_LineClassicList};
    
    __weak typeof(self) weakSelf = self;
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
    [self addTabMJ_FootView];
}

#pragma mark - 获取数据
- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?current=%ld&size=%@",_postUrlDic[@(_pageFlag)],_page,PageSize];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (weakSelf.page==1) {
            [weakSelf.dataSource removeAllObjects];
        }
        weakSelf.dataModels = nil;
        if (status == Request_Success) {
            weakSelf.dataModels = [HomeDataModel mj_objectWithKeyValues:responseData];
        }
        if (weakSelf.dataSource.count<[weakSelf.dataModels.total integerValue]) {
            [weakSelf.dataSource addObjectsFromArray:weakSelf.dataModels.records];
            weakSelf.page++;
        }
        [weakSelf.baseTabView reloadData];
        if ([weakSelf.baseTabView.mj_footer isRefreshing]) {
            [weakSelf.baseTabView.mj_footer endRefreshing];
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
        if (weakSelf.dataSource.count==[weakSelf.dataModels.total integerValue]) {
            weakSelf.baseTabView.mj_footer = nil;
        }
        else {
            [weakSelf addTabMJ_FootView];
        }
    }];
}

#pragma mark - UITableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordsModel *model = self.dataSource[indexPath.section];
    if (_pageFlag==0 || _pageFlag==2) {
        JSGardenTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSGardenTabCell"];
        cell.pageFlag = _pageFlag;
        cell.model = model;
        cell.iphoneCallBtn.tag = 1000+indexPath.section;
        cell.sendMsgBtn.tag = 2000+indexPath.section;
        [cell.iphoneCallBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendMsgBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (_pageFlag == 1) {
        CityDeliveryTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityDeliveryTabCell"];
        cell.model = model;
        cell.serviceBtn.tag = 3000+indexPath.section;
        cell.iphoneCallBtn.tag = 1000+indexPath.section;
        cell.sendMsgBtn.tag = 2000+indexPath.section;
        [cell.serviceBtn addTarget:self action:@selector(showDevileryText:) forControlEvents:UIControlEventTouchUpInside];
        [cell.iphoneCallBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendMsgBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    RecordsModel *model = self.dataSource[section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(80))];
    view.backgroundColor = PageColor;
    view.clipsToBounds = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, view.width-24, view.height-20)];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.text = model.remark;
    [label sizeToFit];
    label.width = view.width-24;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_pageFlag==1) {
        RecordsModel *model =self.dataSource[section];
        if (model.showFlag) {
            return autoScaleW(80);
        }
    }
    return 0.01;
}

#pragma mark - Cell跳转

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordsModel *model =self.dataSource[indexPath.section];
    NSString *className = @"";
    if (_pageFlag==0) {
        className = @"JSCarSourceDetailVC";
    }
    else if (_pageFlag==1) {
        className = @"JSCityDeliveryDetaileVC";
    }
    else if (_pageFlag==2) {
        className = @"JSLineDetaileVC";
    }
    JSHomeDetaileVC *vc = (JSHomeDetaileVC *)[Utils getViewController:@"Garden" WithVCName:className];
    vc.carSourceID = model.ID;
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 服务范围查看

/** 服务范围查看 */
- (void)showDevileryText:(UIButton*)sender {
    RecordsModel *model = self.dataSource[sender.tag-3000];
    sender.selected = !sender.selected;
    for (RecordsModel *recordsModel in self.dataSource) {
        if ([recordsModel.ID isEqualToString:model.ID]) {
            recordsModel.showFlag = sender.selected;
        }
    }
    [self.baseTabView reloadData];
}

/** 打电话 */
- (void)callAction:(UIButton *)sender {
    if (![Utils isVerified]) {
        return;
    }
    RecordsModel *model = self.dataSource[sender.tag-1000];
    NSString *phone;
    if (_pageFlag==0 || _pageFlag==2) {
        phone = model.driverPhone;
    } else {
        phone = model.contractPhone;
    }
    if ([Utils isBlankString:phone]) {
        [Utils showToast:@"手机号码为空"];
    } else {
        [Utils call:phone];
    }
}

/** 聊天 */
- (void)chatAction:(UIButton *)sender {
    if (![Utils isVerified]) {
        return;
    }
    RecordsModel *model = self.dataSource[sender.tag-2000];
    NSString *phone = model.driverPhone;
    if ([Utils isBlankString:phone]) {
        [Utils showToast:@"手机号码为空"];
    } else {
        NSString *chatID = [NSString stringWithFormat:@"driver%@",phone];
        [CustomEaseUtils EaseChatConversationID:chatID];
    }
}

#pragma mark - 顶部切换

- (IBAction)titleBtnAction:(UIButton*)sender {
    _pageFlag = sender.tag-100;
    for (NSInteger tag = 100; tag<103; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        if ([btn isEqual:sender]) {
            btn.backgroundColor = AppThemeColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [self.baseTabView.mj_header beginRefreshing];
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
