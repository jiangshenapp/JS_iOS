//
//  SysMessageTabcell.h
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/7.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSSysMessageTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *msgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet UILabel *readLab;

@end

NS_ASSUME_NONNULL_END
