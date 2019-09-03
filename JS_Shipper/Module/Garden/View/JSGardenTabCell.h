//
//  JSGardenTabCell.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordsModel.h"
#import "YYStarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSGardenTabCell : UITableViewCell

/** 0车源  1城市配送 2精品路线 */
@property (nonatomic,assign) NSInteger pageFlag;
/** 数据源 */
@property (nonatomic,retain) RecordsModel *model;

@property (weak, nonatomic) IBOutlet UILabel *startAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UIButton *iphoneCallBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (weak, nonatomic) IBOutlet YYStarView *starView;

@end

NS_ASSUME_NONNULL_END
