//
//  JSMyTransportAddVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "JSMyTransportAddVC.h"
#import "JSMyTransportVC.h"
#import "JSTransportModel.h"

@interface JSMyTransportAddVC ()
{
    NSInteger _type;//1 自由运力 2外调
}
- (IBAction)searchActionClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTab;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
/** 数据源 */
@property (nonatomic,retain) NSMutableArray *dataSource;
/** <#object#> */
@property (nonatomic,retain) JSTransportModel *currentModel;
@end

@implementation JSMyTransportAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchTF.borderWidth = 1;
    _searchTF.borderColor = RGBValue(0x979797);
    self.title = @"添加合作运力";
    _searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 20)];
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _dataSource = [NSMutableArray array];
    _remarkTV.borderColor = kColor_Gray;
    _remarkTV.borderWidth = 1;
    _cancleBtn.borderColor = kColor_Gray;
    _cancleBtn.borderWidth = 1;
//    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
//    [myWindow addSubview:_addView];
    _addView.hidden = YES;
    _type = 1;
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMyTransportTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSMyTransportAddTabCell"];
    cell.isAdd = YES;
    cell.dataModel = _dataSource[indexPath.section];
    [cell.bookOrderBtn addTarget:self action:@selector(showAddView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)showAddView:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_mainTab indexPathForCell:cell];
    _addView.hidden = NO;
    _currentModel = _dataSource[indexPath.section];
    _addViewCarTitleLab.text = [NSString stringWithFormat:@"添加%@到我的运力",_currentModel.cphm];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)searchActionClick:(UIButton *)sender {
    if (_searchTF.text.length==0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
       NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?input=%@",URL_ConsignorcarCarList,_searchTF.text];
    [self.view endEditing:YES];
    [[NetworkManager sharedManager] getJSON:url parameters:param completion:^(id responseData, RequestState status, NSError *error) {
        [weakSelf.dataSource removeAllObjects];
        if (status==Request_Success) {
            [weakSelf.dataSource addObjectsFromArray:[JSTransportModel mj_objectArrayWithKeyValuesArray:responseData]];
        }
        [weakSelf.mainTab reloadData];
    }];
}
- (IBAction)selectTypeClickAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    if (sender.tag==10) {
        UIButton *btn = [_addView viewWithTag:11];
        btn.selected = NO;
        _type = 1;
    }
    else {
        UIButton *btn = [_addView viewWithTag:10];
        btn.selected = NO;
        _type = 2;
    }
    
}
- (IBAction)cancleBtnAction:(UIButton *)sender {
    _addView.hidden = YES;
}

- (IBAction)addCarAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
       NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?carId=%@&remark=%@&type=%ld",URL_ConsignorcarAddCar,_currentModel.carId,_remarkTV.text,_type];
    [self.view endEditing:YES];
    [[NetworkManager sharedManager] getJSON:url parameters:param completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"添加车辆成功"];
            weakSelf.addView.hidden = YES;
            if (weakSelf.doneBlock) {
                weakSelf.doneBlock();
            }
        }
    }];
}
@end
