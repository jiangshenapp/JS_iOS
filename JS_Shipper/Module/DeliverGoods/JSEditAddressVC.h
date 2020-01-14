//
//  JSEditAddressVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/26.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSEditAddressVC : BaseVC
/** 地理编码 */
@property (nonatomic,copy) NSString *areaCode;
/** 是否是收货人 */
@property (nonatomic,assign) BOOL isReceive;
/** 用户信息 */
@property (nonatomic,retain) NSDictionary *addressInfo;
@property (weak, nonatomic) IBOutlet UILabel *titleAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressLab;
@property (weak, nonatomic) IBOutlet UITextField *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneLab;
/** 获取到收货人信息 */
@property (nonatomic,copy) void (^getAddressInfo)(NSDictionary *getAddressInfo);
- (IBAction)confirmAddressAction:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
