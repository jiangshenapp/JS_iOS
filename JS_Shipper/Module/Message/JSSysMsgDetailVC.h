//
//  JSSysMsgDetailVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/12.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSysMsgDetailVC : BaseVC
/** <#object#> */
@property (nonatomic,copy) NSString *msgID;
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@end

@interface SysMsgDetailTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *contendLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;

@end

NS_ASSUME_NONNULL_END
