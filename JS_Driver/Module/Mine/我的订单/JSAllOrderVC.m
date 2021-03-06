//
//  JSAllOrderVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/28.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSAllOrderVC.h"
#import "JSOrderDetailsVC.h"

@interface JSAllOrderVC ()<UITableViewDelegate,UITableViewDataSource>
{
    __block NSInteger _page;
}
/** 列表的数据源 */
@property (nonatomic,retain) NSMutableArray *listData;
/** 订单状态 0全部 1发布中，2待司机接单，3待司机确认，4待支付，5待司机接货, 6待收货，7待评价，8已完成，9已取消，10已关闭 */
@property (nonatomic,copy) NSString *orderState;
/** 分页 从1开始 */
@property (nonatomic,assign) NSInteger page;
@end

@implementation JSAllOrderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.page = 1;
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.backPriority = -1;
    if (_typeFlage>0) {
        UIButton *sender = [self.view viewWithTag:100+_typeFlage];
        [self titleBtnAction:sender];
    }
    _listData = [NSMutableArray array];
    [self initOrderState:_typeFlage];
    __weak typeof(self) weakSelf = self;
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
    [self addTabMJ_FootView];
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化订单状态
- (void)initOrderState:(NSInteger)typeFlage {
    if (typeFlage == 0) { //全部
        self.orderState = @"0";
    }
    if (typeFlage == 1) { //待接单
        self.orderState = @"2";
    }
    if (typeFlage == 2) { //待确认
        self.orderState = @"3";
    }
    if (typeFlage == 3) { //待接货
        self.orderState = @"5";
    }
    if (typeFlage == 4) { //待送达
        self.orderState = @"6";
    }
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:self.orderState forKey:@"state"];
    NSString *urlStr = [NSString stringWithFormat:@"%@?current=%ld&size=%@",URL_DriverOrdeList,_page,PageSize];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:para completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSInteger count = [responseData[@"total"] integerValue];
            if (weakSelf.page==1) {
                [weakSelf.listData removeAllObjects];
            }
            NSArray *arr = [OrderInfoModel mj_objectArrayWithKeyValuesArray:responseData[@"records"]];
            if (weakSelf.listData.count<count) {
                [weakSelf.listData addObjectsFromArray:arr];
                weakSelf.page++;
            }
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
        if ([weakSelf.baseTabView.mj_footer isRefreshing]) {
            [weakSelf.baseTabView.mj_footer endRefreshing];
        }
        if (weakSelf.listData.count==[responseData[@"total"] integerValue]) {
            weakSelf.baseTabView.mj_footer = nil;
        }
        else {
            [weakSelf addTabMJ_FootView];
        }
        [weakSelf hiddenNoDataView:weakSelf.listData.count];
        [weakSelf.baseTabView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"MyOrderTabCell";
    MyOrderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[MyOrderTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    OrderInfoModel *model = self.listData[indexPath.row];
    [cell setContentWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.baseTabView deselectRowAtIndexPath:indexPath animated:YES];
    JSOrderDetailsVC *vc = (JSOrderDetailsVC *)[Utils getViewController:@"Mine" WithVCName:@"JSOrderDetailsVC"];
    OrderInfoModel *model = self.listData[indexPath.row];
    vc.orderID = model.ID;
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

- (IBAction)titleBtnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (NSInteger tag = 100; tag<105; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        btn.selected = [btn isEqual:sender]?YES:NO;;
    }
    _typeFlage = sender.tag - 100;
    [self initOrderState:_typeFlage];
    [self.baseTabView.mj_header beginRefreshing];
    [self.baseTabView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}
@end

@implementation MyOrderTabCell

- (void)setContentWithModel:(OrderInfoModel *)model {
    
    self.orderNoLab.text = [NSString stringWithFormat:@"订单编号:%@",model.orderNo];
    self.orderStatusLab.text = model.stateNameDriver;
    self.startAddressLab.text = model.sendAddress;
    self.endAddressLab.text = model.receiveAddress;
    
    NSDictionary *sendlocDic = [Utils dictionaryWithJsonString:model.sendPosition];
    NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc"];
    _distanceLab.text = [NSString stringWithFormat:@"距离:%@",[Utils distanceBetweenOrderBy:[locDic[@"lat"] floatValue] :[locDic[@"lng"] floatValue] andOther:[sendlocDic[@"latitude"] floatValue] :[sendlocDic[@"longitude"] floatValue]]];;
    NSString *info = @"";
    if (![NSString isEmpty:model.carModelName]) {
        info = [info stringByAppendingString:model.carModelName];
    }
    if (![NSString isEmpty:model.carLengthName]) {
        info = [info stringByAppendingString:model.carLengthName];
    }
    if (![NSString isEmpty:model.goodsVolume]) {
        info = [info stringByAppendingString:[NSString stringWithFormat:@"/%@方",model.goodsVolume]];
    }
    if (![NSString isEmpty:model.goodsWeight]) {
        info = [info stringByAppendingString:[NSString stringWithFormat:@"/%@吨",model.goodsWeight]];
    }
    self.goodsDetaileLab.text = info;
    if ([Utils isBlankString:model.fee]) {
        self.orderPriceLab.text = @"";
    } else {
        self.orderPriceLab.text = [NSString stringWithFormat:@"￥%@",model.fee];
    }
}

@end
