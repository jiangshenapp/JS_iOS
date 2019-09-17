//
//  JSManagerCircleVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSManagerCircleVC.h"

@interface JSManagerCircleVC ()
{
}
/** 是否是管理员 */
@property (nonatomic,assign)  BOOL isAdmin;;
@property (nonatomic,retain) NSArray <CircleMemberModel *>*dataSource;
@end

@implementation JSManagerCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    _isAdmin = ([self.adminID integerValue]==[[UserInfo share].userID integerValue]);
    [self getNetData];
    // Do any additional setup after loading the view.
}

- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?circleId=%@",URL_CircleMemberList,_circleID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            weakSelf.dataSource = [CircleMemberModel mj_objectArrayWithKeyValuesArray:responseData];
            if (!weakSelf.isAdmin) {//不是管理员
                NSString *preStr = [NSString stringWithFormat:@"status = '1'"];
                //定义谓词对象,谓词对象中包含了过滤条件
                NSPredicate *predicate = [NSPredicate predicateWithFormat:preStr];
                weakSelf.dataSource = [weakSelf.dataSource filteredArrayUsingPredicate:predicate];
            }
            
            [weakSelf.baseTabView reloadData];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerCircleTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerCircleTabCell"];
    CircleMemberModel *model = _dataSource[indexPath.row];
    cell.nameLab.text = model.nickName;
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:DefaultImage];
    cell.contentLab.text = @"";
    if ([model.status integerValue]==0) {
        cell.contentLab.text = @"(待审核)";
    }
    return cell;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isAdmin) {
        return @[];
    }
    CircleMemberModel *model = _dataSource[indexPath.row];
    __weak typeof(self) weakself = self;
    
    void(^deleteActionBlock)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakself deleteMember:model.ID];
    };
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:deleteActionBlock];
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"ff4545"];
    
    
    void(^agreeActionBlock)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakself applyMember:model.ID];
    };
    UITableViewRowAction *agreeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"同意" handler:agreeActionBlock];
    
    agreeAction.backgroundColor = [UIColor colorWithHexString:@"ffa902"];
    
    
    void(^refuseActionBlock)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakself refuseMember:model.ID];
    };
    
    UITableViewRowAction *refuseAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"拒绝" handler:refuseActionBlock];
    refuseAction.backgroundColor = [UIColor blueColor];
    
    if ([model.status integerValue]==1) {
        return @[deleteAction];
    }
    else if ([model.status integerValue]==0) {
        return @[agreeAction,refuseAction];
    }
    return @[deleteAction,agreeAction,refuseAction];
}


- (void)deleteMember:(NSString *)memberID {
    
    __weak typeof(self) weakSelf = self;
    XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"确定要删除吗" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alert.doneBlock = ^{
        NSDictionary *dic = [NSDictionary dictionary];
        NSString *url = [NSString stringWithFormat:@"%@?id=%@",URL_CircleDeleteSubscriber,memberID];
        [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status==Request_Success) {
                [Utils showToast:@"操作成功"];
                if ([memberID integerValue] == [[UserInfo share].userID integerValue]) {//删除自己
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                else {
                    [weakSelf getNetData];
                }
            }
        }];
    };
}

- (void)applyMember:(NSString *)memberID {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&status=1",URL_CircleAuditApply,memberID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"同意成功"];
            [weakSelf getNetData];
        }
    }];
}

- (void)refuseMember:(NSString *)memberID {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&status=2",URL_CircleAuditApply,memberID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"拒绝成功"];
            [weakSelf getNetData];
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteAction:(UIButton *)sender {
    [self deleteMember:[UserInfo share].userID];
}
@end

@implementation ManagerCircleTabCell

@end

@implementation CircleMemberModel

@end
