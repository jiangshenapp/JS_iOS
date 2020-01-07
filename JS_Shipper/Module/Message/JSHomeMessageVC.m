//
//  JSHomeMessageVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSHomeMessageVC.h"
#import "CustomEaseUtils.h"
#import "JSSystemMessageVC.h"

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
    [self getData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)getData {
    NSString *type = [AppChannel isEqualToString:@"1"]?@"3":@"2";
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [[NetworkManager sharedManager] getJSON:[NSString stringWithFormat:@"%@?type=%@",URL_GetUnreadMessageCount,type] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        NSInteger count = 0;
        if (status==Request_Success) {
            count = [responseData integerValue];
        }
        weakSelf.systermMsgCountLab.text = [NSString stringWithFormat:@"%ld",count];
        weakSelf.systermMsgCountLab.hidden = !count;
    }];
    
    NSString *pushSide = [AppChannel isEqualToString:@"1"]?@"2":@"1";
    [[NetworkManager sharedManager] getJSON:[NSString stringWithFormat:@"%@?pushSide=%@",URL_GetUnreadPushLogCount,pushSide] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
           NSInteger count = 0;
           if (status==Request_Success) {
               count = [responseData integerValue];
           }
           weakSelf.pushMsgCountLab.text = [NSString stringWithFormat:@"%ld",count];
           weakSelf.pushMsgCountLab.hidden = !count;
       }];
}

- (void)loginStateChange:(NSNotification *)aNotif {
//    UINavigationController *navigationController = nil;
//    
//    BOOL loginSuccess = [aNotif.object boolValue];
//    if (loginSuccess) {//登录成功加载主窗口控制器
//    }
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)messageAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    JSSystemMessageVC *vc = (JSSystemMessageVC *)[Utils getViewController:@"Message" WithVCName:@"JSSystemMessageVC"];
    vc.isPush = (btn.tag==11);
    [self.navigationController pushViewController:vc animated:YES];
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
