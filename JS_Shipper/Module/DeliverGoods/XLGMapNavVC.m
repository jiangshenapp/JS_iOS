//
//  XLGMapNavVC.m
//  SharenGo
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGMapNavVC.h"
#import "LocationTransform.h"

@interface XLGMapNavVC ()
@end

static XLGMapNavVC *navi = nil;

@implementation XLGMapNavVC

+ (XLGMapNavVC *)share {
    if (navi == nil) {
        navi=[[XLGMapNavVC alloc]init];
    }
    return navi;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 根据起点、终点导航
+ (void)startNavWithEndPt:(CLLocationCoordinate2D)endP {
    if (endP.latitude==0 || endP.longitude ==0) {
        [Utils showToast:@"位置错误"];
        return;
    }
    [[XLGMapNavVC share] doNavigationWithEndLocation:endP];
    //节点数组
//    NSMutableArray *nodesArray = [[NSMutableArray alloc] initWithCapacity:2];
//
//    //起点
//    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
//    startNode.pos = [[BNPosition alloc] init];
//    startNode.pos.x = stp.longitude;
//    startNode.pos.y = stp.latitude;
//    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:startNode];
//
//    //终点
//    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
//    endNode.pos = [[BNPosition alloc] init];
//    endNode.pos.x = endP.longitude;
//    endNode.pos.y = endP.latitude;
//    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:endNode];
//
//    [BNCoreServices_RoutePlan setDisableOpenUrl:YES];
//    //发起路径规划
//    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:navi  userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");

    //路径规划成功，开始导航
//    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
//    switch ([error code]%10000)
//    {
//        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
//            NSLog(@"暂时无法获取您的位置,请稍后重试");
//            break;
//        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
//            NSLog(@"无法发起导航");
//            break;
//        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
//            NSLog(@"定位服务未开启,请到系统设置中打开定位服务。");
//            break;
//        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
//            NSLog(@"起终点距离起终点太近");
//            break;
//        default:
//            NSLog(@"算路失败");
//            break;
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航只需要目的地经纬度，endLocation为纬度、经度的数组
-(void)doNavigationWithEndLocation:(CLLocationCoordinate2D)endP
{
    
    //NSArray * endLocation = [NSArray arrayWithObjects:@"26.08",@"119.28", nil];
    
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=bd09ll",endP.latitude,endP.longitude,[XLGMapNavVC share].destionName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:endP.latitude andLongitude:endP.longitude];
        //高德转化为GPS
        LocationTransform *afterLocation = [beforeLocation transformFromBDToGD];
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",@"龙巅鱼邻",afterLocation.latitude,afterLocation.longitude,[XLGMapNavVC share].destionName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
//        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",kAPPScheme,afterLocation.latitude,afterLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
//        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"导航测试",@"nav123456",endP., endLocation[1]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        googleMapDic[@"url"] = urlString;
//        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
//        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0",[XLGMapNavVC share].destionName,endP.latitude, endP.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        qqMapDic[@"url"] = urlString;
//        [maps addObject:qqMapDic];
    }
    
    
    //选择
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSInteger index = maps.count;
    if (index==0) {
        [Utils showToast:@"请先安装百度地图或高德地图"];
        return;
    }
    for (int i = 0; i < index; i++) {
        NSString * title = maps[i][@"title"];
        //苹果原生地图方法
        if (i == 0) {
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMap:endP];
            }];
            [alert addAction:action];
            continue;
        }
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = maps[i][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [alert addAction:action];
    }
   
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:cancelAction];
    AppDelegate *del =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.tabVC presentViewController:alert animated:YES completion:nil];
}

//苹果地图
- (void)navAppleMap:(CLLocationCoordinate2D)loc
{
    //    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:self.destinationCoordinate2D];
    
    //终点坐标
    LocationTransform *beforeLocation = [[LocationTransform alloc] initWithLatitude:loc.latitude andLongitude:loc.longitude];
    //百度转高德
    LocationTransform *afterLocation = [beforeLocation transformFromBDToGD];
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(afterLocation.latitude, afterLocation.longitude) addressDictionary:nil] ];
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    //第二个，都可以用
    //    NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    //                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    toLocation.name = [XLGMapNavVC share].destionName;
    currentLoc.name = @"我的位置";
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
    
}


@end
