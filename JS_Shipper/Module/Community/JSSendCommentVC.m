//
//  JSSendCommentVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSendCommentVC.h"

@interface JSSendCommentVC ()
@property (weak, nonatomic) IBOutlet UITextView *commentTV;
- (IBAction)backAction:(UIButton *)sender;
- (IBAction)sendAction:(UIButton *)sender;

@end

@implementation JSSendCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendAction:(UIButton *)sender {
    [self backAction:nil];
}
@end
