//
//  JSCircleContentVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSCircleContentVC.h"
#import "JSPostListModel.h"
#import "JSSendTopicVC.h"
#import "JSTopicDetailVC.h"

@interface JSCircleContentVC ()
/** 数据源 */
@property (nonatomic,retain) NSMutableArray <JSPostListModel *>*dataSource;
@end

@implementation JSCircleContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XXX的圈子";
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self getNetData];
}

- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?circleId=%@",URL_PostList,_circleId];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            weakSelf.dataSource = [JSPostListModel mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.baseTabView reloadData];
        }
    }];
}

- (void)pushVC {
    UIViewController *vc = [Utils getViewController:@"Community" WithVCName:@"JSManagerCircleVC"];
    [self.navigationController pushViewController:vc animated:YES];}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleContentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleContentTabCell"];
    JSPostListModel *model = _dataSource[indexPath.row];
    cell.timeLab.text = [NSString stringWithFormat:@"%@发布",[Utils getTimeStrToCurrentDateWith:model.createTime]];
    cell.zanNumberLab.text = model.likeCount;
    cell.commentNumLab.text = model.commentCount;
    cell.contentLab.text = model.content;
    cell.nameLab.text = model.nickName;
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:DefaultImage];
    cell.tag1Lab.hidden = YES;
    cell.tag2Lab.hidden = YES;
    if ([model.star boolValue]) {
        cell.tag1Lab.hidden = NO;
        cell.tag1Lab.text = @"精品";
    }
    if ([model.type boolValue]) {
        cell.tag2Lab.hidden = NO;
        cell.tag2Lab.text = @"官方";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSPostListModel *model = _dataSource[indexPath.row];
    JSTopicDetailVC *vc = (JSTopicDetailVC *)[Utils getViewController:@"Community" WithVCName:@"JSTopicDetailVC"];
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[JSSendTopicVC class]]) {
        JSSendTopicVC *vc = segue.destinationViewController;
        vc.circleId = _circleId;
    }
}


@end


@implementation CircleContentTabCell


@end
