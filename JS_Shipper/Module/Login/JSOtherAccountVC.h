//
//  JSOtherAccountVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/23.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSOtherAccountVC : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

- (IBAction)anthWXActionClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
