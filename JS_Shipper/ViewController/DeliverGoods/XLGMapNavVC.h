//
//  XLGMapNavVC.h
//  SharenGo
//  Notes：地图导航
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

//#import "BNCoreServices.h"
#import "BaseVC.h"

@interface XLGMapNavVC : BaseVC

@property (nonatomic , copy)NSString *destionName;
+(XLGMapNavVC *)share;
//导航方法
+ (void)startNavWithEndPt:(CLLocationCoordinate2D)endP;
@end
