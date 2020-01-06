//
//  JSMyTransportVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "JSMyTransportTabCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyTransportVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mainTab;
- (IBAction)titleBtnClickAction:(UIButton *)sender;

@end


NS_ASSUME_NONNULL_END
