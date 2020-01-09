//
//  JSMyTransportAddVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyTransportAddVC : BaseVC
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *addViewCarTitleLab;
- (IBAction)selectTypeClickAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;
- (IBAction)cancleBtnAction:(UIButton *)sender;
- (IBAction)addCarAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/** <#object#> */
@property (nonatomic,copy) dispatch_block_t doneBlock;
@end

NS_ASSUME_NONNULL_END
