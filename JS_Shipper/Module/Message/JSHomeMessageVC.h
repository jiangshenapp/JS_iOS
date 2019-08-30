//
//  JSHomeMessageVC.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"
#import "EMConversationsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSHomeMessageVC : EMConversationsViewController
@property (weak, nonatomic) IBOutlet UIView *tabHeadView;
- (IBAction)chatWithCustomAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
