//
//  JSCommunityVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSCommunityVC.h"
#import "JSSelectCityVC.h"
#import "JSTieziListVC.h"
#import "JSCircleContentVC.h"

@interface JSCommunityVC ()
{
    
}
/** 展现端，1货主APP,2司机APP */
@property (nonatomic,copy) NSString *showSide;
/** 导航栏按钮 */
@property (nonatomic,retain) UIButton *leftNavbarBtn;
/** 定位管理 */
@property (nonatomic,retain) BMKLocationManager *locationService;
/** 用户当前位置 */
@property (nonatomic,retain) MKUserLocation *myUserLoc;
/** <#object#> */
@property (nonatomic,retain) BMKGeoCodeSearch *geocodesearch;;
/** 城市编码 */
@property (nonatomic,copy) NSString *cityCode;
/** <#object#> */
@property (nonatomic,retain) NSMutableArray <JSCommunityModel *>*dataSource;
@end

@implementation JSCommunityVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [locationService startUserLocationService];
    _locationService.delegate=self;
    _geocodesearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [locationService stopUserLocationService];
    _locationService.delegate=nil;
    _geocodesearch.delegate = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区";
    _leftNavbarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [_leftNavbarBtn setTitle:@"" forState:UIControlStateNormal];
    [_leftNavbarBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    _leftNavbarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftNavbarBtn addTarget:self action:@selector(pushCity) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftNavbarBtn];
    
    [self initData];
}

- (void)initData {
    _showSide = AppChannel;
    _dataSource = [NSMutableArray array];
    _cityCode = @"";
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    [self.locationService startUpdatingLocation];
}

- (void)pushCity {
    __weak typeof(self) weakSelf = self;
    JSSelectCityVC *vc = (JSSelectCityVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSSelectCityVC"];
    vc.getSelectDic = ^(NSDictionary * _Nonnull dic) {
        NSLog(@"%@",dic);//code 
        [weakSelf.leftNavbarBtn setTitle:dic[@"address"] forState:UIControlStateNormal];
        weakSelf.cityCode = dic[@"code"];
        [weakSelf getNetData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    _cityCode = @"330200";
    NSString *url = [NSString stringWithFormat:@"%@?city=%@&showSide=%@",URL_CircleAll,_cityCode,_showSide];
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
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy loading
- (BMKLocationManager *)locationService {
    if (!_locationService) {
        //初始化BMKLocationManager类的实例
        _locationService = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationService.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationService.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationService.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationService.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationService.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationService.locationTimeout = 10;
        _locationService.reGeocodeTimeout = 10;
        _locationService.distanceFilter=50;
        _locationService.locatingWithReGeocode = NO;
    }
    return _locationService;
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (location.location.coordinate.latitude!=0) {
        [self.locationService stopUpdatingLocation];
        __weak typeof(self) weakSelf = self;
        // 显示所有信息
        BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
        reverseGeocodeSearchOption.isLatestAdmin = YES;
        reverseGeocodeSearchOption.location = location.location.coordinate;
        NSLog(@"%f",reverseGeocodeSearchOption.location.latitude);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        });
      }
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
        [_leftNavbarBtn setTitle:result.addressDetail.city forState:UIControlStateNormal];
        [self getNetData];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"comment"]) {
        JSTieziListVC *vc = segue.destinationViewController;
        vc.type = 2;
    }
    else if ([segue.identifier isEqualToString:@"collect"]) {
        JSTieziListVC *vc = segue.destinationViewController;
        vc.type = 1;
    }
}


@end
