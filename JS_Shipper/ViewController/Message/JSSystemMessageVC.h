//
//  JSSystemMessageVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/9.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSystemMessageVC : BaseVC

@end

@interface SysMessageTabcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *msgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *contentLab;

@end

NS_ASSUME_NONNULL_END
