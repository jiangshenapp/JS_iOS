//
//  JSCircleContentVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCircleContentVC : BaseVC
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollVew;

@end

@interface CircleContentTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *tag1Lab;
@property (weak, nonatomic) IBOutlet UILabel *tag2Lab;
@property (weak, nonatomic) IBOutlet UILabel *zanNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLab;

@end

NS_ASSUME_NONNULL_END
