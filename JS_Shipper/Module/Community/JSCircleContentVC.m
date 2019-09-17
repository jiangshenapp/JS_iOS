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
{
    NSString *subjectStr;
    MyCustomButton *lastBtn;
    NSArray *subjectArr;;
}
/** 数据源 */
@property (nonatomic,retain) NSMutableArray <JSPostListModel *>*dataSource;
@end

@implementation JSCircleContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _dataModel.name;
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    subjectStr = @"";
    __weak typeof(self) weakSelf = self;
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNetData];
    }];
    [self getNetData];
    [self getUserSubjectList];
    [self initTopicListView];
}

- (void)initTopicListView {
    CGFloat leftSpace = 12;
    CGFloat maxRight = leftSpace;;
    CGFloat viewW = WIDTH/PageCount-leftSpace;
    subjectArr = [_dataModel.subjects componentsSeparatedByString:@","];
    NSMutableArray *allSub = [NSMutableArray arrayWithArray:@[@"全部"]];
    [allSub addObjectsFromArray:subjectArr];
    NSArray *subjectImgName = @[@"social_circle_icon_blue",@"social_circle_icon_red",@"social_circle_icon_green",@"social_circle_icon_yellow"];
    for (NSInteger index = 0; index<allSub.count; index++) {
        MyCustomButton *btn = [[MyCustomButton alloc]initWithFrame:CGRectMake(maxRight, 0, viewW, _titleScrollVew.height)];
        btn.cornerRadius = 2;
        [btn setTitle:allSub[index] forState:UIControlStateNormal];
        NSInteger tempIndex = index%subjectImgName.count;
        [btn setImage:[UIImage imageNamed:subjectImgName[tempIndex]] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn.index = index;
        [btn addTarget:self action:@selector(selectSubject:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollVew addSubview:btn];
        btn.borderColor = [UIColor clearColor];
        if (index==0) {
            btn.selected = YES;
            btn.borderColor = AppThemeColor;
            lastBtn = btn;
        }
        maxRight = btn.right+leftSpace;
    }
    _titleScrollVew.contentSize = CGSizeMake(maxRight, 0);
}

- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?circleId=%@&subject=%@&likeFlag=0&commentFlag=0&myFlag=0",URL_PostList,_circleId,subjectStr];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            weakSelf.dataSource = [JSPostListModel mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.baseTabView reloadData];
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
    }];
}

- (void)getUserSubjectList {
    NSDictionary *dic = [NSDictionary dictionary];
//    [[NetworkManager sharedManager] postJSON:URL_CircleLikeSubject parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
//        NSLog(@"%@",responseData);
//    }];
}

- (void)pushVC {
    JSManagerCircleVC *vc = (JSManagerCircleVC *)[Utils getViewController:@"Community" WithVCName:@"JSManagerCircleVC"];
    vc.circleID = _circleId;
    vc.adminID = _dataModel.admin;
    vc.titleStr = self.navItem.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectSubject:(MyCustomButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    sender.borderColor = AppThemeColor;
    if (lastBtn!=nil) {
        lastBtn.borderColor = [UIColor clearColor];
        lastBtn.selected = NO;
    }
    lastBtn = sender;
    if (sender.index==0) {
        subjectStr = @"";
    }
    else {
        subjectStr = sender.currentTitle;
    }
    [self getNetData];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleContentTabCell"];
    JSPostListModel *model = _dataSource[indexPath.row];
    cell.dataModel = model;
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
        vc.subjectArr = [NSArray arrayWithArray:subjectArr];
    }
}


@end

