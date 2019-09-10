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
#import "JSManagerCircleVC.h"
#import "MyCustomButton.h"

#define PageCount 3

@interface JSCircleContentVC ()
/** 数据源 */
@property (nonatomic,retain) NSMutableArray <JSPostListModel *>*dataSource;
@end

@implementation JSCircleContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _dataModel.name;
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self getNetData];
    [self initTopicListView];
}

- (void)initTopicListView {
    CGFloat leftSpace = 12;
    CGFloat maxRight = leftSpace;;
    CGFloat viewW = WIDTH/PageCount-leftSpace;
    NSArray *subjectArr = [_dataModel.subjects componentsSeparatedByString:@","];
    NSArray *subjectImgName = @[@"social_circle_icon_blue",@"social_circle_icon_red",@"social_circle_icon_green",@"social_circle_icon_yellow"];
    for (NSInteger index = 0; index<subjectArr.count; index++) {
        MyCustomButton *btn = [[MyCustomButton alloc]initWithFrame:CGRectMake(maxRight, 0, viewW, _titleScrollVew.height)];
        btn.cornerRadius = 5;
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitle:subjectArr[index] forState:UIControlStateNormal];
        NSInteger tempIndex = index%subjectImgName.count;
        [btn setImage:[UIImage imageNamed:subjectImgName[tempIndex]] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        btn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        btn.backgroundColor = [UIColor whiteColor];
        [_titleScrollVew addSubview:btn];
        btn.borderColor = [UIColor clearColor];
        if (index==0) {
            btn.borderColor = AppThemeColor;
        }
        maxRight = btn.right+leftSpace;
    }
    _titleScrollVew.contentSize = CGSizeMake(maxRight, 0);
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
    JSManagerCircleVC *vc = (JSManagerCircleVC *)[Utils getViewController:@"Community" WithVCName:@"JSManagerCircleVC"];
    vc.circleID = _circleId;
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
    cell.likeBtn.selected = [model.likeFlag boolValue];
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
