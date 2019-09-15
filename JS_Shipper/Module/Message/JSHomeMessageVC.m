//
//  JSHomeMessageVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSHomeMessageVC.h"
#import "CustomEaseUtils.h"

@interface JSHomeMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JSHomeMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = PageColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = _tabHeadView;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavBarH);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:ACCOUNT_LOGIN_CHANGED object:nil];
}

- (void)loginStateChange:(NSNotification *)aNotif {
//    UINavigationController *navigationController = nil;
//    
//    BOOL loginSuccess = [aNotif.object boolValue];
//    if (loginSuccess) {//登录成功加载主窗口控制器
//    }
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)chatWithCustomAction:(UIButton *)sender {
    [CustomEaseUtils EaseChatConversationID:OnlineCustomerEaseMobKey];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
