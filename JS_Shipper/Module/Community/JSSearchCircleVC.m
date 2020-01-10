//
//  JSSearchCircleVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSearchCircleVC.h"
#import "CircleListTabCell.h"
#import "JSSelectCityVC.h"
#import "LocationTransform.h"

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface JSSearchCircleVC ()<UISearchControllerDelegate,UISearchResultsUpdating,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate>
/** 展现端，1货主APP,2司机APP */
@property (nonatomic,copy) NSString *showSide;
/** <#object#> */
@property (nonatomic,strong) JSSearchCircleVC *searchResultVC;
@property (strong,nonatomic) UISearchController *searchController;
/** 定位管理器 */
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,assign) CLLocationCoordinate2D currentLoc;
/** 导航栏按钮 */
@property (nonatomic,retain) UIButton *leftNavbarBtn;
/** <#object#> */
@property (nonatomic,retain) BMKGeoCodeSearch *geocodesearch;;
/** 城市编码 */
@property (nonatomic,copy) NSString *cityCode;
@end

@implementation JSSearchCircleVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [locationService startUserLocationService];
    _geocodesearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [locationService stopUserLocationService];
    _geocodesearch.delegate = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找圈子";
    _showSide = AppChannel;
    if (!_isSearchResult) {
        self.searchResultVC = (JSSearchCircleVC *)[Utils getViewController:@"Community" WithVCName:@"JSSearchCircleVC"];
        self.searchResultVC.isSearchResult = YES;
        [self getNetData];
    }
    else {
        self.serachViewH.constant = 0;
    }
    // Do any additional setup after loading the view.
    _cityCode = @"";
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    _leftNavbarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    //    [_leftNavbarBtn setTitle:@"" forState:UIControlStateNormal];
    [_leftNavbarBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    _leftNavbarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftNavbarBtn addTarget:self action:@selector(pushCity) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftNavbarBtn];
    
    NSDictionary *locDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"loc"];
    _currentLoc = CLLocationCoordinate2DMake([locDic[@"lat"] floatValue], [locDic[@"lng"] floatValue]);
    if (_currentLoc.latitude==0||_currentLoc.longitude==0) {
        [self startLocation];
    }else {
        [self getCityInfoWithLoc];
    }
    //    [self.locationService startUpdatingLocation];
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
    [self getCityInfoWithLoc];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
}

- (void)getCityInfoWithLoc {
    
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:_currentLoc.latitude andLongitude:_currentLoc.longitude];
    //高德转化为GPS
    LocationTransform *afterLocation = [beforeLocation transformFromBDToGD];
    
    __weak typeof(self) weakSelf = self;
    // 显示所有信息
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeocodeSearchOption.isLatestAdmin = YES;
    reverseGeocodeSearchOption.location = CLLocationCoordinate2DMake(afterLocation.latitude, afterLocation.longitude);
    [weakSelf.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"%@    %@   %@    %@    ",result.addressDetail.streetName,result.addressDetail.streetNumber,result.addressDetail.streetNumber,result.addressDetail.distance);
    if (error==0&&result!=nil) {
        _cityCode = result.addressDetail.adCode;
        [self setCityName:result.addressDetail.city];
        if (!_isSearchResult) {
            [self getNetData];
        }
    }
}

- (void)setCityName:(NSString *)cityName {
    [_leftNavbarBtn setTitle:cityName forState:UIControlStateNormal];
    [_leftNavbarBtn setImage:[UIImage imageNamed:@"app_more_city_arrow_black"] forState:UIControlStateNormal];
    CGFloat padding = 5;
    CGRect titleRect = self.leftNavbarBtn.titleLabel.frame;
    CGRect imageRect = self.leftNavbarBtn.imageView.frame;
    _leftNavbarBtn.imageEdgeInsets=UIEdgeInsetsMake(0, titleRect.size.width+padding,0, -titleRect.size.width-padding);
    _leftNavbarBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -imageRect.size.width,0, imageRect.size.width);
}

- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?city=%@&showSide=%@",URL_CircleAll,_cityCode,_showSide];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            weakSelf.dataSource = [JSCommunityModel mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.baseTabView reloadData];
        }
    }];
}

- (void)pushCity {
    __weak typeof(self) weakSelf = self;
    JSSelectCityVC *vc = (JSSelectCityVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSSelectCityVC"];
    vc.getSelectDic = ^(NSDictionary * _Nonnull dic) {
        NSLog(@"%@",dic);//code
        [weakSelf setCityName:dic[@"address"]];
        weakSelf.cityCode = dic[@"code"];
        [weakSelf getNetData];
    };
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)searchActionClick:(UIButton *)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    self.searchController.searchBar.placeholder = @"搜索圈子名字";
    self.navigationController.definesPresentationContext = YES;
    [self.searchController setHidesNavigationBarDuringPresentation:NO];
    
    [self.navigationController presentViewController:self.searchController animated:YES completion:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyword = [self.searchController.searchBar text];
    if (keyword.length==0) {
        return;
    }
    if (self.searchResultVC.dataSource==nil) {
        self.searchResultVC.dataSource = [NSMutableArray array];
    }
    [self.searchResultVC.dataSource removeAllObjects];
    NSString *preStr = [NSString stringWithFormat:@"name contains '%@'",keyword];
    //定义谓词对象,谓词对象中包含了过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:preStr];
    NSArray *result = [_dataSource filteredArrayUsingPredicate:predicate];
    //使用谓词条件过滤数组中的元素,过滤之后返回查询的结果
    [self.searchResultVC.dataSource addObjectsFromArray:result];
    [self.searchResultVC.baseTabView reloadData];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [self.searchResultVC.dataSource removeAllObjects];
    [self.searchResultVC.baseTabView reloadData];
}

@end
