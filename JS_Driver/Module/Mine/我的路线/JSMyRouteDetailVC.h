//
//  JSMyRouteDetailVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyRouteDetailVC : BaseVC

/** 路线id */
@property (nonatomic,copy) NSString *routeID;

@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *carLengthLab;
@property (weak, nonatomic) IBOutlet UILabel *carModelLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UIButton *openOrCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyJingpinBtn;

- (IBAction)openOrCloseAction:(id)sender;
- (IBAction)applyJingpinAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
