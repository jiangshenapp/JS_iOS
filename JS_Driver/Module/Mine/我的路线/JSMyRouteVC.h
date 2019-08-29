//
//  JSMyRouteVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyRouteVC : BaseVC<UITableViewDelegate,UITableViewDataSource>

@end


@interface MyRouteTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *startAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *endAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

NS_ASSUME_NONNULL_END
