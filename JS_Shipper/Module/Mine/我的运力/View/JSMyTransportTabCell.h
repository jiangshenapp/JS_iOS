//
//  JSMyTransportTabCell.h
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTransportModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyTransportTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
/** 数据源 */
@property (nonatomic,retain) JSTransportModel *dataModel;
/** <#object#> */
@property (nonatomic,assign) BOOL isAdd;
@end


NS_ASSUME_NONNULL_END
