//
//  JSTopicDetailVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSTopicDetailVC : BaseVC
@property (weak, nonatomic) IBOutlet UIImageView *circleImgView;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLab;

@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLab;

- (IBAction)followBtnClickAction:(UIButton *)sender;

@end

@interface TopicDetailTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;

@property (weak, nonatomic) IBOutlet UIImageView *commentHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentNameLab;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLab;



@end

NS_ASSUME_NONNULL_END
