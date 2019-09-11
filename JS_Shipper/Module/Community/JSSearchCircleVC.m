//
//  JSSearchCircleVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSearchCircleVC.h"
#import "CircleListTabCell.h"
#import "JSCommunityModel.h"

@interface JSSearchCircleVC ()
@property (nonatomic,retain) NSMutableArray <JSCommunityModel *>*dataSource;
/** 展现端，1货主APP,2司机APP */
@property (nonatomic,copy) NSString *showSide;
@end

@implementation JSSearchCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找圈子";
    _showSide = AppChannel;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 34)];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 20, 20)];
    img.image = [UIImage imageNamed:@"equipment_icon_search_gray"];
    [view addSubview:img];
    self.searchTF.leftView = view;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self getNetData];
    // Do any additional setup after loading the view.
}

- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?city=%@&showSide=%@",URL_CircleAll,_cityID,_showSide];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            weakSelf.dataSource = [JSCommunityModel mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.baseTabView reloadData];
        }
    }];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCircleTabCell"];
    JSCommunityModel *model = _dataSource[indexPath.row];
    cell.circleNameLab.text = model.name;
    [cell.circleIconImView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:DefaultImage];
    [cell.applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (model.applyStatus.length==0||[model.applyStatus integerValue]==3) {
        [cell.applyBtn setTitle:@"申请加入" forState:UIControlStateNormal];
        cell.applyBtn.borderColor = cell.applyBtn.currentTitleColor;
        cell.applyBtn.borderWidth = 1;
        cell.applyBtn.cornerRadius = 17;
    }
    else {
        cell.applyBtn.borderColor = [UIColor clearColor];
        if ([model.applyStatus integerValue]==1) {
            [cell.applyBtn setTitle:@"已加入" forState:UIControlStateNormal];
        }
        else if ([model.applyStatus integerValue]==0) {
            [cell.applyBtn setTitle:@"已申请" forState:UIControlStateNormal];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController *vc = [Utils getViewController:@"Community" WithVCName:@"JSCircleContentVC"];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applyAction:(UIButton *)sender {
    NSIndexPath *indexPath = [self.baseTabView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    JSCommunityModel *model = _dataSource[indexPath.row];
    if (model.applyStatus.length==0||[model.applyStatus integerValue]==3) {
            __weak typeof(self) weakSelf = self;
        NSDictionary *dic = [NSDictionary dictionary];
        NSString *url = [NSString stringWithFormat:@"%@?circleId=%@",URL_CircleApply,model.ID];
        [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status==Request_Success) {
                [Utils showToast:@"申请成功"];
                [weakSelf getNetData];
            }
        }];

    }

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
