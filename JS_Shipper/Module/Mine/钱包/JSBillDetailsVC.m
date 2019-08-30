//
//  JSBillDetailsVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/27.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSBillDetailsVC.h"

@interface JSBillDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSMutableArray *listData;

@end

@implementation JSBillDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账单明细";
    
    [self getData:@"0"];
}

#pragma mark - get data

- (void)getData:(NSString *)type {
    //type 0全部，1余额，2运力端保证金, 3货主端保证金
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:[NSString stringWithFormat:@"%@?type=%@",URL_GetTradeRecord,type] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            weakSelf.listData = [TradeRecordModel mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.baseTabView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"JSBillListTabCell1";
    JSBillListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JSBillListTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    TradeRecordModel *model = self.listData[indexPath.row];
    [cell setContentWithModel:model];
    
    return cell;
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
    [sender setTitleColor:AppThemeColor forState:UIControlStateNormal];
    if ([sender isEqual:_allOrderBtn]) {
        [_balanceOrderBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        [self getData:@"0"];
    }
    else {
        [_allOrderBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        [self getData:@"1"];
    }
}

@end

@implementation JSBillListTabCell

- (void)setContentWithModel:(TradeRecordModel *)model {
    
    self.orderNoLab.text = [NSString stringWithFormat:@"订单编号：%@",model.tradeNo];
    self.orderTitleLab.text = model.remark;
    self.orderTimeLab.text = model.createTime;
    self.orderMoneyLab.text = model.tradeMoney;
    if ([model.tradeMoney floatValue] < 0) {
        self.orderMoneyLab.textColor = RGBValue(0xD0021B);
    } else {
        self.orderMoneyLab.textColor = RGBValue(0x69BC0D);
    }
}

@end
