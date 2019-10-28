//
//  CityDeliveryTabCell.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "CityDeliveryTabCell.h"
#import "XLGMapNavVC.h"

@implementation CityDeliveryTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _navBtn.layer.borderColor = _navBtn.currentTitleColor.CGColor;
    _navBtn.layer.borderWidth = 1;
    _navBtn.layer.cornerRadius = 10;
    _navBtn.layer.masksToBounds = YES;
    [_navBtn addTarget:self action:@selector(showNavAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setModel:(RecordsModel *)model {
    if (_model!=model) {
        _model = model;
    }
    self.dotNameLab.text = model.companyName;
    if ([model.companyType integerValue]>0) {
        NSString *value = [NSString stringWithFormat:@"%@",model.companyType];
         self.dotNameLab.text = [NSString stringWithFormat:@"%@[%@]",model.companyName,kCompanyTypeStrDic[value]];
    }
    self.addressLab.text = model.contactAddress;
    self.isShowImgView.image = model.showFlag?[UIImage imageNamed:@"app_list_arrow_up"]:[UIImage imageNamed:@"app_list_arrow_down"];
    NSString *distanceStr ;
    if ([model.distance floatValue]>1000) {
        distanceStr = [NSString stringWithFormat:@"距离您%.2fkm",[model.distance floatValue]/1000];
    }
    else {
        distanceStr = [NSString stringWithFormat:@"距离您%.2fm",[model.distance floatValue]];
    }
        self.dustanceLab.text = distanceStr;

//    if (![NSString isEmpty:model.contactLocation]) {
//        self.dustanceLab.hidden = NO;
//        NSDictionary *contactLocDic = [Utils dictionaryWithJsonString:model.contactLocation];
//        NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc"];
//        NSString *distanceStr = [NSString stringWithFormat:@"距离您%@",[Utils distanceBetweenOrderBy:[locDic[@"lat"] floatValue] :[locDic[@"lng"] floatValue] andOther:[contactLocDic[@"latitude"] floatValue] :[contactLocDic[@"longitude"] floatValue]]];
//        self.dustanceLab.text = distanceStr;
//    } else {
//        self.dustanceLab.hidden = YES;
//    }
}

#pragma mark - 导航
/** 导航 */
-(void)showNavAction:(MyCustomButton *)sender {
    NSDictionary *contactLocDic = [Utils dictionaryWithJsonString:_model.contactLocation];
    [XLGMapNavVC share].destionName = _model.companyName;
    [XLGMapNavVC startNavWithEndPt:CLLocationCoordinate2DMake([contactLocDic[@"latitude"] floatValue], [contactLocDic[@"longitude"] floatValue])];
}
@end
