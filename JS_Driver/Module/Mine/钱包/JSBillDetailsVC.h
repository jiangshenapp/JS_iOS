//
//  JSBillDetailsVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/27.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "TradeRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBillDetailsVC : BaseVC

/**  0 全部  1余额  2保证金 */
@property (nonatomic,assign) NSInteger type;

- (IBAction)titleBtnAction:(UIButton *)sender;

@end

@interface JSBillListTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLab;

- (void)setContentWithModel:(TradeRecordModel *)model;

@end

NS_ASSUME_NONNULL_END
