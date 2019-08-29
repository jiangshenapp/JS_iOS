//
//  JSAddRouteVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSAddRouteVC : BaseVC

/** 路线ID */
@property (nonatomic,copy) NSString *routeID;

@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UIButton *addStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *addEndBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

- (IBAction)addStartAddressAction:(UIButton *)sender;
- (IBAction)addEndAddressAction:(UIButton *)sender;
- (IBAction)selectCarTypeAction:(UIButton *)sender;
- (IBAction)addRouteAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
