//
//  JSMyTransportVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "JSMyTransportVC.h"
#import "JSMyTransportAddVC.h"
#import "JSDeliverConfirmVC.h"

@interface JSMyTransportVC ()<UITableViewDelegate,UITableViewDataSource>
/** <#object#> */
@property (nonatomic,retain) NSMutableArray *dataSource;
/** 1 自由运力 2外调 */
@property (nonatomic,copy) NSString *type;
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
    _type = @"0";
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:[NSString stringWithFormat:@"%@?type=%@",URL_ConsignorcarList,self.type] parameters:param completion:^(id responseData, RequestState status, NSError *error) {
        [weakSelf.dataSource removeAllObjects];
        if (status == Request_Success) {
            [weakSelf.dataSource addObjectsFromArray:[JSTransportModel mj_objectArrayWithKeyValuesArray:responseData]];
        }
        [weakSelf hiddenNoDataView:weakSelf.dataSource.count];
        [weakSelf.mainTab reloadData];
    }];
}

- (void)rightBtnAction {
    JSMyTransportAddVC *vc = (JSMyTransportAddVC *)[Utils getViewController:@"Mine" WithVCName:@"JSMyTransportAddVC"];
    __weak typeof(self) weakSelf = self;
    vc.doneBlock = ^{
        [weakSelf requestData];
    };
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
    [cell.bookOrderBtn addTarget:self action:@selector(bookOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contactBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";//默认文字为 Delete
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JSTransportModel *currentModel = _dataSource[indexPath.section];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@?id=%@",URL_ConsignorcarRemoveCar,currentModel.ID] parameters:param completion:^(id responseData, RequestState status, NSError *error) {
            if (status==Request_Success) {
                [weakSelf.dataSource removeObject:currentModel];
            }
            [weakSelf.mainTab reloadData];
        }];
        
    }
}

- (void)bookOrderAction:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_mainTab indexPathForCell:cell];
    JSTransportModel *currentModel = _dataSource[indexPath.section];
    JSDeliverConfirmVC *vc = (JSDeliverConfirmVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSDeliverConfirmVC"];
    vc.isAll = YES;
    vc.carModel = currentModel.carModelId;
    vc.carLength = currentModel.carLengthId;
    vc.carModelName = currentModel.carModelName;
    vc.carLengthName = currentModel.carLengthName;
    if (![Utils isBlankString:currentModel.subscriberId]
        && ![currentModel.subscriberId isEqualToString:@"0"]) {
        vc.subscriberId = currentModel.subscriberId;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)callAction:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_mainTab indexPathForCell:cell];
    JSTransportModel *currentModel = _dataSource[indexPath.section];
    [Utils call:currentModel.mobile];
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
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    for (NSInteger tag = 10; tag<13; tag++) {
        if (tag!=sender.tag) {
            UIButton *btn = [sender.superview viewWithTag:tag];
            btn.selected = NO;
        }
    }
    _type = [NSString stringWithFormat:@"%ld",sender.tag-10];
    [self requestData];
}
@end

