//
//  CircleListTabCell.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleListTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *circleIconImView;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLab;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@end

NS_ASSUME_NONNULL_END
