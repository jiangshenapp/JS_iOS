//
//  JSCommunityVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSCommunityVC.h"
#import "JSTieziListVC.h"
#import "JSCircleContentVC.h"
#import "JSSearchCircleVC.h"
#import "JSMyTieZiListSwitchVC.h"

@interface JSCommunityVC ()<CLLocationManagerDelegate>
{
    
}
/** 展现端，1货主APP,2司机APP */
@property (nonatomic,copy) NSString *showSide;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLab;
/** <#object#> */
@property (nonatomic,retain) NSMutableArray <JSCommunityModel *>*dataSource;

- (IBAction)titleBtnActionClick:(UIButton *)sender;
@end

@implementation JSCommunityVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNetData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区";
    _commentCountLab.hidden = YES;
    [self initData];
    
    __weak typeof(self) weakSelf = self;
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNetData];
    }];
    
}

- (void)initData {
    _showSide = AppChannel;
    _dataSource = [NSMutableArray array];
}

- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CircleMyList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            weakSelf.dataSource = [JSCommunityModel mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.baseTabView reloadData];
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
    }];
}


#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleTabCell"];
    JSCommunityModel *model = _dataSource[indexPath.row];
    cell.circleNameLab.text = model.name;
    [cell.circleIconImView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:DefaultImage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCommunityModel *model = _dataSource[indexPath.row];
    JSCircleContentVC *vc = (JSCircleContentVC *)[Utils getViewController:@"Community" WithVCName:@"JSCircleContentVC"];
    vc.circleId = model.ID;
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     if ([segue.identifier isEqualToString:@"searchCircle"]) {
//        JSSearchCircleVC *searchVC = segue.destinationViewController;
//        searchVC.cityID = _cityCode;
//    }
}


- (IBAction)titleBtnActionClick:(UIButton *)sender {
    JSMyTieZiListSwitchVC *v2c = [[JSMyTieZiListSwitchVC alloc]init];
    v2c.type = sender.tag - 100;
    [self.navigationController pushViewController:v2c animated:YES];
}
@end
