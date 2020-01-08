//
//  JSSysMsgDetailVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/12.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "JSMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSysMsgDetailVC : BaseVC
/** <#object#> */
@property (nonatomic,retain) SysMessageModel *sysModel;
@property (nonatomic,retain) PushMessageModel *pushModel;

@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@end

@interface SysMsgDetailTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *contendLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopH;

@end

NS_ASSUME_NONNULL_END
