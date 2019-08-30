//
//  JSGardenVC.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"
#import "CustomEaseUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSGardenVC : BaseVC
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *filterView1;
@property (weak, nonatomic) IBOutlet UIView *filterView2;

- (IBAction)titleBtnAction:(UIButton*)sender;

@end

NS_ASSUME_NONNULL_END
