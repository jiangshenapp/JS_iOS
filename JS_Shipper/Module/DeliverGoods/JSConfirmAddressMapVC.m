//
//  JSConfirmAddressMapVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSConfirmAddressMapVC.h"
#import "MKMapView+ZoomLevel.h"
#import "JSEditAddressVC.h"
#import "JSSelectCityVC.h"

@interface JSConfirmAddressMapVC ()<BMKLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    NSString *areaCode;
}
/** 地址模型 */
@property (nonatomic,retain) AddressInfoModel *dataModel;
/** 定位管理 */
@property (nonatomic,retain) BMKLocationManager *locationService;
/** 用户当前位置 */
@property (nonatomic,retain) MKUserLocation *myUserLoc;
/** 反地理编码 */
@property (nonatomic,retain) BMKReverseGeoCodeSearchResult *placemark;
/** 搜索对象 */
@property (nonatomic,retain) BMKPoiSearch *poisearch;
/** 搜索数据源 */
@property (nonatomic,retain) NSMutableArray *searchAddressArr;
@end

@implementation JSConfirmAddressMapVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_bdMapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_bdMapView viewWillDisappear];
    [_searchAddressArr removeAllObjects];
    [self.baseTabView reloadData];
    self.baseTabView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self createTitleView];
}

- (void)initView {

    if (self.sourceType==1) {
        _dataModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kReceiveAddressArchiver];
    } else if (self.sourceType==0) {
        _dataModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kSendAddressArchiver];
    } else if (self.sourceType==2) {
        [_confrirmBtn setTitle:@"确认地址" forState:UIControlStateNormal];
        _editInfoViewW.constant = 0;
    }
    
    if (!_dataModel) {
        _dataModel = [[AddressInfoModel alloc] init];
    }
    if (_dataModel.lat>0) {
        MKCoordinateRegion region;
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(_dataModel.lat, _dataModel.lng);
        region.center= centerCoordinate;
        [self fetchNearbyInfo:centerCoordinate.latitude andT:centerCoordinate.longitude];
        [self.bdMapView setCenterCoordinate:centerCoordinate animated:YES];
    } else {
        [self.locationService startUpdatingLocation];
    }
    
    //判断当前设备定位服务是否打开
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"设备尚未打开定位服务");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSString *message = @"您的手机目前未开启定位服务，如欲开启定位服务，请至设定开启定位服务功能";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法定位" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }

    _searchAddressArr = [NSMutableArray array];
    _bdMapView.delegate = self;
    _bdMapView.showsUserLocation = YES;
    _bdMapView.zoomLevel = 15;
    areaCode = @"";
    UIImage *image = [UIImage imageNamed:@"delivergoods_map_bg_location"];
    _centerView.layer.contents = (__bridge id)image.CGImage;
    self.baseTabView.hidden = YES;
    if (_sourceType==0) {
        [_editGoodsInfoBtn setTitle:@"发货人信息" forState:UIControlStateNormal];
    }
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (location.location.coordinate.latitude!=0) {
        [self.locationService stopUpdatingLocation];
        BMKUserLocation *loca = [[BMKUserLocation alloc]init];
        loca.location = location.location;
        [self.bdMapView updateLocationData:loca];
        [self.bdMapView setCenterCoordinate:location.location.coordinate animated:YES];
        [self fetchNearbyInfo:loca.location.coordinate.latitude andT:loca.location.coordinate.longitude];
    }
}

- (void)fetchNearbyInfo:(CLLocationDegrees )latitude andT:(CLLocationDegrees )longitude {
    BMKGeoCodeSearch *geocodesearch  = [[BMKGeoCodeSearch alloc] init];
    geocodesearch.delegate =self;
    // 显示所有信息
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeocodeSearchOption.location = CLLocationCoordinate2DMake(latitude, longitude);
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        _dataModel.lat = latitude;
        _dataModel.lng = longitude;
        NSLog(@"反geo检索发送成功");
    }
    else {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"%@    %@   %@    %@    ",result.addressDetail.streetName,result.addressDetail.streetNumber,result.addressDetail.direction,result.addressDetail.distance);
    if (error==0&&result!=nil) {
        NSString *businessCircle = result.businessCircle;
        if (businessCircle.length==0) {
            if (result.poiList.count) {
                BMKPoiInfo *info = [result.poiList firstObject];
                businessCircle = info.name;
            }
            if (businessCircle.length==0) {
                businessCircle = result.address;
            }
        }
        _ceterAddressLab.text =[NSString stringWithFormat:@"%@",businessCircle];
        _addressNameLab.text =[NSString stringWithFormat:@"%@",businessCircle];
        _addressInfoLab.text =[NSString stringWithFormat:@"%@",result.address];
        [_cityBtn setTitle:result.addressDetail.city forState:UIControlStateNormal];
        _placemark = result;
        areaCode = result.addressDetail.adCode;
        _dataModel.addressName = _addressNameLab.text;
        _dataModel.address = _addressInfoLab.text;
        if (result.location.latitude>0) {
            _dataModel.lat = result.location.latitude;
            _dataModel.lng = result.location.longitude;
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    [self fetchNearbyInfo:centerCoordinate.latitude andT:centerCoordinate.longitude];
}

#pragma mark - UITextField代理
/** UITextField代理 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.baseTabView.hidden = NO;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    NSString *textStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textStr.length==0) {
        [_searchAddressArr removeAllObjects];
        self.baseTabView.hidden = YES;
        return YES;
    }
     self.baseTabView.hidden = NO;
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    BMKPOICitySearchOption *boundSearchOption = [[BMKPOICitySearchOption alloc]init];
    boundSearchOption.city = _cityBtn.currentTitle;;
    //    boundSearchOption.pageCapacity = 20;
    boundSearchOption.keyword = textStr;
    BOOL flag = [_poisearch poiSearchInCity:boundSearchOption];
    if(flag) {
        NSLog(@"范围内检索发送成功");
    }
    else {
        NSLog(@"范围内检索发送失败");
    }
    [self.baseTabView reloadData];
    return YES;
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    _searchAddressArr = nil;
    if (errorCode==0) {
        _searchAddressArr = [NSMutableArray arrayWithArray:poiResult.poiInfoList];
    }
    [self.baseTabView reloadData];
}

#pragma mark - tablewView代理
/**  */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchAddressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTabcell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTabcell"];
     BMKPoiInfo *poiInfo = _searchAddressArr[indexPath.row];
    cell.nameLab.text = poiInfo.name;
    cell.addressLab.text = poiInfo.address;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JSEditAddressVC *vc = (JSEditAddressVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSEditAddressVC"];
    BMKPoiInfo *poiInfo = _searchAddressArr[indexPath.row];
//    NSString *title = @"";
//    if (![NSString isEmpty:poiInfo.name]) {
//        title = poiInfo.name;
//    }
//    NSString *address = @"";;
//    if (![NSString isEmpty:poiInfo.address]) {
//        address = poiInfo.address;
//    }
//    vc.addressInfo = @{@"title":title,@"address":address};
//    [self.navigationController pushViewController:vc animated:YES];
    _ceterAddressLab.text =[NSString stringWithFormat:@"%@",poiInfo.name];
    _addressNameLab.text =[NSString stringWithFormat:@"%@",poiInfo.name];
    _addressInfoLab.text =[NSString stringWithFormat:@"%@",poiInfo.address];
    [_bdMapView setCenterCoordinate:poiInfo.pt animated:YES];
    areaCode = @"";
    
    [_searchAddressArr removeAllObjects];
    [self.baseTabView reloadData];
    self.baseTabView.hidden = YES;
}

- (void)selectCityBtn:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    JSSelectCityVC *vc = (JSSelectCityVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSSelectCityVC"];
    vc.getSelectDic = ^(NSDictionary * _Nonnull dic) {
        [sender setTitle:dic[@"address"] forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.bdMapView setCenterCoordinate:CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue])];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createTitleView {
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(40, kStatusBarH+2, WIDTH-80, 40)];
    _titleView.cornerRadius = 2;
    _titleView.borderColor = PageColor;
    _titleView.borderWidth = 1;
    [self.navBar addSubview:_titleView];
    
    _cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(3, 0, 80, _titleView.height)];
    [_cityBtn setTitle:@"宁波市" forState:UIControlStateNormal];
    [_cityBtn addTarget:self action:@selector(selectCityBtn:) forControlEvents:UIControlEventTouchUpInside];
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cityBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    [_titleView addSubview:_cityBtn];
    
    _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_cityBtn.right, (_titleView.height-8)/2.0, 8, 8)];
    _iconImgView.image = [UIImage imageNamed:@"app_more_city_arrow_black"];
    [_titleView addSubview:_iconImgView];
    
    _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(_iconImgView.right+10, 0, _titleView.width-_iconImgView.right-10, _titleView.height)];
    
    if (_sourceType==1) {
        _searchTF.placeholder = @"选择收货地址";
    }
    else if (_sourceType==0) {
        _searchTF.placeholder = @"选择发货地址";
    }
    else if (_sourceType==2) {
        _searchTF.placeholder = @"选择园区地址";
    }
    _searchTF.delegate = self;
    _searchTF.font = [UIFont systemFontOfSize:14];
    [_titleView addSubview:_searchTF];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"address"]) {
        __weak typeof(self) weakSelf = self;
        JSEditAddressVC *vc = segue.destinationViewController;
        vc.isReceive = _sourceType;
        vc.areaCode = areaCode;
        vc.addressInfo = @{@"title":_addressNameLab.text,@"address":_addressInfoLab.text};
        vc.getAddressInfo = ^(NSDictionary * _Nonnull getAddressInfo) {
            weakSelf.dataModel.phone = getAddressInfo[@"phone"];
            weakSelf.dataModel.name = getAddressInfo[@"name"];
            weakSelf.dataModel.detailAddress = getAddressInfo[@"detailAddress"];
            weakSelf.dataModel.streetCode = getAddressInfo[@"streetCode"];
            weakSelf.dataModel.street = getAddressInfo[@"street"];
            
            if (weakSelf.sourceType==1) {
                [NSKeyedArchiver archiveRootObject:weakSelf.dataModel toFile:kReceiveAddressArchiver];
            } else {
                [NSKeyedArchiver archiveRootObject:weakSelf.dataModel toFile:kSendAddressArchiver];
            }
        };
    }
}

- (IBAction)getAddressInfoAction:(UIButton *)sender {
    if (_sourceType==2) {//园区地址
        if (self.getAddressinfo) {
            self.getAddressinfo(_dataModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    if(_dataModel.phone.length==0||_dataModel.name.length==0||[NSString isEmpty:_dataModel.streetCode]) {
        if (_sourceType==1) {
            [Utils showToast:@"请完善收货人信息"];
        } else {
            [Utils showToast:@"请完善发货人信息"];
        }
        return;
    }
    if (self.getAddressinfo) {
        if (_dataModel!=nil) {
            _dataModel.areaCode = areaCode;
            
            if (_sourceType==1) {
                [NSKeyedArchiver archiveRootObject:_dataModel toFile:kReceiveAddressArchiver];
            } else {
                [NSKeyedArchiver archiveRootObject:_dataModel toFile:kSendAddressArchiver];
            }
            self.getAddressinfo(_dataModel);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        _locationService.locatingWithReGeocode = YES;
    }
    return _locationService;
}

@end

@implementation SearchTabcell

@end
