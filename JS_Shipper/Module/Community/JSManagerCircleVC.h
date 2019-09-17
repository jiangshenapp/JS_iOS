//
//  JSManagerCircleVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSManagerCircleVC : BaseVC
/** 圈子ID */
@property (nonatomic,copy) NSString *circleID;
/** 是否是管理员 */
@property (nonatomic,copy) NSString *adminID;
/** <#object#> */
@property (nonatomic,copy) NSString *titleStr;
- (IBAction)deleteAction:(UIButton *)sender;
@end

@interface ManagerCircleTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@interface CircleMemberModel : BaseItem
/** <#object#> */
@property (nonatomic,copy) NSString *circleId;
/** <#object#> */
@property (nonatomic,copy) NSString *ID;
/** <#object#> */
@property (nonatomic,copy) NSString *nickName;
/** 状态，0待审核，1通过，2拒绝 */
@property (nonatomic,copy) NSString *status;
/** 会员id */
@property (nonatomic,copy) NSString *subscriberId;
@end

NS_ASSUME_NONNULL_END
