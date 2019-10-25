//
//  JSGardenVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSGardenVC.h"
#import "CityCustomView.h"
#import "SortView.h"
#import "FilterCustomView.h"
#import "JSCarSourceDetailVC.h"
#import "JSLineDetaileVC.h"
#import "HomeDataModel.h"
#import "RecordsModel.h"
#import "FilterButton.h"
#import "JSGardenTabCell.h"
#import "CityDeliveryTabCell.h"


@interface JSGardenVC ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    NSArray *titleArr1;
    NSArray *titleArr2;
    NSArray *titleViewArr1;
    NSArray *titleViewArr2;
    NSMutableArray *_titleBtnArr;
    CityCustomView *cityView1;
    CityCustomView *cityView2;
    SortView *mySortView1;
    SortView *mySortView2;
    CityCustomView *cityView3;
}
/** 分页 */
@property (nonatomic,assign) NSInteger page;
/** 0车源  1城市配送 2精品路线 */
@property (nonatomic,assign) NSInteger pageFlag;
/** 传参字典 0 */
@property (nonatomic,retain) NSDictionary *postUrlDic;
/** 区域编码1 */
@property (nonatomic,copy) NSString *areaCode1;
/** 区域编码2 */
@property (nonatomic,copy) NSString *areaCode2;
/** 区域编码3(城市配送) */
@property (nonatomic,copy) NSString *areaCode3;

/** 数据源 */
@property (nonatomic,retain) HomeDataModel *dataModels;
/** 筛选视图 */
@property (nonatomic,retain) FilterCustomView *myfilteView;
/** 筛选条件 */
@property (nonatomic,retain) NSDictionary *allDicKey;
/** 数据源 */
@property (nonatomic,retain) NSMutableArray <RecordsModel *>*dataSource;
/** 排序，1发货时间 2距离; */
@property (nonatomic,copy) NSString *sort1;
/** 排序，1服务中心 2车代点  3网点; */
@property (nonatomic,copy) NSString *companyType;
/** 定位管理器 */
@property (retain, nonatomic) CLLocationManager *locationManager;
/** 当前经纬度 */
@property (nonatomic,assign) CLLocationCoordinate2D currentLoc;

@end

@implementation JSGardenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    [self initView];
    [self getData];
    [self getDicList];
}

#pragma mark 定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;//遵循代理
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        [self.locationManager startUpdatingLocation];//开始定位
    }else{//不能定位用户的位置的情况再次进行判断，并给与用户提示
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    _currentLoc = currLocation.coordinate;
    NSDictionary *locDic = @{@"lat":@(_currentLoc.latitude),@"lng":@(_currentLoc.longitude)};
    [[NSUserDefaults standardUserDefaults] setObject:locDic forKey:@"loc"];;
    [self.baseTabView reloadData];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
}

- (void)initView {
    _pageFlag = 0;
    _page = 1;
    _sort1 = @"1";
    _companyType = @"";
    _areaCode1 = @"";
    _areaCode2 = @"";
    _areaCode3 = @"";
    _dataSource = [NSMutableArray array];
    _titleBtnArr = [NSMutableArray array];
    NSDictionary *locDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"loc"];
    _currentLoc = CLLocationCoordinate2DMake([locDic[@"lat"] floatValue], [locDic[@"lng"] floatValue]);
    _titleView.top = 7+kStatusBarH;
    _titleView.centerX = WIDTH/2.0;
    [self.navBar addSubview:_titleView];
    titleArr1 = @[@"发货地",@"收货地",@"默认排序",@"筛选"];
    CGFloat btW1 = WIDTH/titleArr1.count;
    for (NSInteger index = 0; index<titleArr1.count; index++) {
        FilterButton *sender = [[FilterButton alloc]initWithFrame:CGRectMake(index*btW1, 0, btW1, self.filterView1.height)];
        sender.tag = 20000+index;
        [sender setTitle:titleArr1[index] forState:UIControlStateNormal];
        [sender addTarget:self action:@selector(showViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterView1 addSubview:sender];
        [_titleBtnArr addObject:sender];
    }
    
    titleArr2 = @[@"区域",@"全部",@"默认排序"];
    CGFloat btW2 = WIDTH/titleArr2.count;
    for (NSInteger index = 0; index<titleArr2.count; index++) {
        FilterButton *sender = [[FilterButton alloc]initWithFrame:CGRectMake(index*btW2, 0, btW2, self.filterView2.height)];
        sender.tag = 30000+index;
        [sender setTitle:titleArr2[index] forState:UIControlStateNormal];
        [sender addTarget:self action:@selector(showViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterView2 addSubview:sender];
         [_titleBtnArr addObject:sender];
    }
    
    __weak typeof(self) weakSelf = self;
    cityView1 = [[CityCustomView alloc]init];
    cityView1.getCityData = ^(NSDictionary * _Nonnull dataDic) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20000];
        tempBtn.isSelect = NO;
        [tempBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
        weakSelf.areaCode1 = dataDic[@"code"];
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    cityView2 = [[CityCustomView alloc]init];
    cityView2.getCityData = ^(NSDictionary * _Nonnull dataDic) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20001];
        [tempBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
        weakSelf.areaCode2 = dataDic[@"code"];
        tempBtn.isSelect = NO;
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    cityView3 = [[CityCustomView alloc]init];
    cityView3.getCityData = ^(NSDictionary * _Nonnull dataDic) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:30000];
        [tempBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
        weakSelf.areaCode3 = dataDic[@"code"];
        tempBtn.isSelect = NO;
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    
    
    mySortView1 = [[SortView alloc]init];
    mySortView1.titleArr = @[@"默认排序",@"距离排序"];
    mySortView1.getSortString = ^(NSString * _Nonnull sorts) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20002];
        tempBtn.isSelect = NO;
        if ([sorts containsString:@"默认"]) {
            weakSelf.sort1 = @"1";
        }
        else {
            weakSelf.sort1 = @"2";
        }
         [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    _myfilteView = [[FilterCustomView alloc]init];
    _myfilteView.getPostDic = ^(NSDictionary * _Nonnull dic, NSArray * _Nonnull titles) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20003];
        tempBtn.isSelect = NO;
        weakSelf.allDicKey = dic;
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    
    mySortView2 = [[SortView alloc]init];
    mySortView2.titleArr = @[@"全部",@"服务中心",@"车代点",@"网点"];
    mySortView2.getSortString = ^(NSString * _Nonnull sorts) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:30001];
        [tempBtn setTitle:sorts forState:UIControlStateNormal];
        tempBtn.isSelect = NO;
        weakSelf.companyType = kCompanyTypeStrDic[sorts];
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    
    titleViewArr1 = @[cityView1,cityView2,mySortView1,_myfilteView];
    titleViewArr2 = @[cityView3,mySortView2,mySortView1];
    _postUrlDic = @{@(0):URL_Find,@(1):URL_CityParkList,@(2):URL_Classic};
    _allDicKey = @{@"useCarType":@"",@"carLength":@"",@"carModel":@"",@"goodsType":@""};
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.baseTabView setContentOffset:CGPointMake(0, 0)];
        [weakSelf getData];
    }];
     [self addTabMJ_FootView];
}

#pragma mark - 获取数据
- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.pageFlag==1) { //城市配送
//        if (_areaCode3.length==6) {
//            [dic setObject:_areaCode3 forKey:@"addressCode"];
//        }
        if (![NSString isEmpty:_companyType]) {
            [dic setObject:_companyType forKey:@"companyType"];
        }
    } else { //车源、精品路线
        if (_areaCode1.length==6) {
            [dic setObject:_areaCode1 forKey:@"startAddressCode"];
        }
        if (_areaCode2.length==6) {
            [dic setObject:_areaCode2 forKey:@"arriveAddressCode"];
        }
        if (![NSString isEmpty:self.allDicKey[@"carLength"]]) {
            [dic setObject:self.allDicKey[@"carLength"] forKey:@"carLength"];
        }
        if (![NSString isEmpty:self.allDicKey[@"carModel"]]) {
            [dic setObject:self.allDicKey[@"carModel"] forKey:@"carModel"];
        }
    }
    if (![NSString isEmpty:_sort1]) {
        [dic setObject:_sort1 forKey:@"sort"];
    }
    NSDictionary *currentDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc"];
    [dic setObject:currentDic[@"lat"] forKey:@"latitude"];
    [dic setObject:currentDic[@"lng"] forKey:@"longitude"];
    NSString *url = [NSString stringWithFormat:@"%@?current=%ld&size=%@",_postUrlDic[@(_pageFlag)],_page,PageSize];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (weakSelf.page==1) {
            [weakSelf.dataSource removeAllObjects];
        }
        weakSelf.dataModels = nil;
        if (status == Request_Success) {
            weakSelf.dataModels = [HomeDataModel mj_objectWithKeyValues:responseData];
        }
        if (weakSelf.dataSource.count<[weakSelf.dataModels.total integerValue]) {
            [weakSelf.dataSource addObjectsFromArray:weakSelf.dataModels.records];
            weakSelf.page++;
        }
        if ([weakSelf.baseTabView.mj_footer isRefreshing]) {
            [weakSelf.baseTabView.mj_footer endRefreshing];
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
        if (weakSelf.dataSource.count==[weakSelf.dataModels.total integerValue]) {
            weakSelf.baseTabView.mj_footer = nil;
        }
        else {
            [weakSelf addTabMJ_FootView];
        }
        [weakSelf hiddenNoDataView:weakSelf.dataSource.count];
        [weakSelf.baseTabView reloadData];
    }];
}

#pragma mark - 获取配置
- (void)getDicList {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetDictList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.myfilteView.dataDic = responseData;
        }
    }];
}

#pragma mark - UITableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordsModel *model = self.dataSource[indexPath.section];
    if (_pageFlag==0 || _pageFlag==2) {
        JSGardenTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSGardenTabCell"];
        cell.pageFlag = _pageFlag;
        cell.model = model;
        cell.iphoneCallBtn.tag = 1000+indexPath.section;
        cell.sendMsgBtn.tag = 2000+indexPath.section;
        [cell.iphoneCallBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendMsgBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.starView.hidden = _pageFlag;
        return cell;
    }
    else if (_pageFlag == 1) {
        CityDeliveryTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityDeliveryTabCell"];
        cell.model = model;
        cell.serviceBtn.tag = 3000+indexPath.section;
        cell.iphoneCallBtn.tag = 1000+indexPath.section;
        cell.sendMsgBtn.tag = 2000+indexPath.section;
        cell.navBtn.dataDic = model;
        [cell.serviceBtn addTarget:self action:@selector(showDevileryText:) forControlEvents:UIControlEventTouchUpInside];
        [cell.iphoneCallBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendMsgBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    RecordsModel *model = self.dataSource[section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(80))];
    view.backgroundColor = PageColor;
    view.clipsToBounds = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, view.width-24, view.height-20)];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.text = model.remark;
    [label sizeToFit];
    label.width = view.width-24;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_pageFlag==0) {
        return 145;
    }
    else if(_pageFlag==1){
        return 120;
    }
    else if(_pageFlag==2){
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_pageFlag==1) {
        RecordsModel *model =self.dataSource[section];
        if (model.showFlag) {
            return autoScaleW(80);
        }
    }
    return 0.01;
}

#pragma mark - Cell跳转

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordsModel *model =self.dataSource[indexPath.section];
    NSString *className = @"";
    if (_pageFlag==0) {
        className = @"JSCarSourceDetailVC";
    }
    else if (_pageFlag==1) {
         className = @"JSCityDeliveryDetaileVC";
    }
    else if (_pageFlag==2) {
        className = @"JSLineDetaileVC";
    }
    JSHomeDetaileVC *vc = (JSHomeDetaileVC *)[Utils getViewController:@"Garden" WithVCName:className];
    vc.carSourceID = model.ID;
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 服务范围查看

/** 服务范围查看 */
- (void)showDevileryText:(UIButton*)sender {
    RecordsModel *model = self.dataSource[sender.tag-3000];
    sender.selected = !sender.selected;
    for (RecordsModel *recordsModel in self.dataSource) {
        if ([recordsModel.ID isEqualToString:model.ID]) {
            recordsModel.showFlag = sender.selected;
        }
    }
    [self.baseTabView reloadData];
}

/** 打电话 */
- (void)callAction:(UIButton *)sender {
    if (![Utils isVerified]) {
        return;
    }
    RecordsModel *model = self.dataSource[sender.tag-1000];
    NSString *phone;
    if (_pageFlag==0 || _pageFlag==2) {
        phone = model.driverPhone;
    } else {
        phone = model.contractPhone;
    }
    if ([Utils isBlankString:phone]) {
        [Utils showToast:@"手机号码为空"];
    } else {
        [Utils call:phone];
    }
}

/** 聊天 */
- (void)chatAction:(UIButton *)sender {
    if (![Utils isVerified]) {
        return;
    }
    RecordsModel *model = self.dataSource[sender.tag-2000];
    NSString *phone = model.driverPhone;
    if ([Utils isBlankString:phone]) {
        [Utils showToast:@"手机号码为空"];
    }else {
        NSString *chatID = [NSString stringWithFormat:@"driver%@",phone];
        [CustomEaseUtils EaseChatConversationID:chatID];
    }
}

#pragma mark - 筛选按钮选择

/** 筛选按钮选择 */
- (void)showViewAction:(FilterButton *)sender {
    sender.userInteractionEnabled = NO;
    sender.isSelect = !sender.isSelect;
    NSArray *tempArr;
    NSInteger baseTag;
    if (self.pageFlag==1) {
        tempArr = titleViewArr2;
        baseTag = 30000;
    }
    else {
        tempArr = titleViewArr1;
        baseTag = 20000;
    }
    for (NSInteger index = 0; index<tempArr.count; index++) {
        FilterButton *tempBtn = [self.view viewWithTag:baseTag+index];
        BaseCustomView *vv = tempArr[index];
        if (![sender isEqual:tempBtn]) {
            tempBtn.isSelect = NO;
            [vv hiddenView];
        }
        else {
            if (sender.isSelect) {
                [vv showView];
            }
            else {
                [vv hiddenView];
            }
        }
    }
    sender.userInteractionEnabled = YES;
}

#pragma mark - 顶部切换

- (IBAction)titleBtnAction:(UIButton*)sender {
    _pageFlag = sender.tag-100;
    for (NSInteger tag = 100; tag<103; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        if ([btn isEqual:sender]) {
            btn.backgroundColor = AppThemeColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [self.baseTabView.mj_header beginRefreshing];
    _filterView1.hidden = sender.tag==101?YES:NO;
    _filterView2.hidden = !_filterView1.hidden;
    NSMutableArray *titleViewArr = [NSMutableArray arrayWithArray:titleViewArr2];
    [titleViewArr addObjectsFromArray:titleViewArr1];
    for (BaseCustomView *view in titleViewArr) {
        [view hiddenView];
    }
    for (MyCustomButton *btn in _titleBtnArr) {
        btn.isSelect = NO;
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
