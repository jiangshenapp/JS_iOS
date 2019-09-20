//
//  JSConfirmAddressMapVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BMKLocationKit/BMKLocationManager.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "AddressInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSConfirmAddressMapVC : BaseVC
/** 0发货  1收货  2司机的园区地址 */
@property (nonatomic,assign) NSInteger sourceType;
/** <#object#> */
@property (nonatomic,copy) void (^getAddressinfo)(AddressInfoModel *info);
@property (weak, nonatomic) IBOutlet BMKMapView *bdMapView;
@property (retain, nonatomic)  UIView *titleView;
@property (retain, nonatomic)  UITextField *searchTF;
@property (retain, nonatomic)  UIButton *cityBtn;
@property (retain, nonatomic)  UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *ceterAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressInfoLab;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *editGoodsInfoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editInfoViewW;
- (IBAction)getAddressInfoAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *confrirmBtn;

@end

@interface SearchTabcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end

NS_ASSUME_NONNULL_END
