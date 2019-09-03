//
//  JSMineVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMineVC.h"
#import "JSAllOrderVC.h"
#import "AccountInfo.h"
#import "JSMyWalletVC.h"

#define LineCount 3

@interface JSMineVC ()
{
    NSArray *iconArr;
    NSArray *menuTileArr;
    CGFloat menuBtnH;
}
@end

@implementation JSMineVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    
//    [self getData];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kLoginSuccNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kUserInfoChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kChangeMoneyNotification object:nil];
    
    iconArr = @[@"personalcenter_icon_cars",@"personalcenter_icon_driver",@"personalcenter_icon_route",@"personalcenter_icon_service",@"personalcenter_icon_invoice",@"personalcenter_icon_collection"];
    menuTileArr = @[@"我的车辆",@"我的司机",@"我的路线",@"我的客服",@"我的发票",@"推广达人"];
    [self createUI];
}

- (void)createUI {
    self.starView.starScore = 4;
    self.starView.starSize = CGSizeMake(14, 14);
    self.signInBtn.borderColor = AppThemeColor;
    self.signInBtn.borderWidth = 1;
    self.signInBtn.cornerRadius = 2;
    menuBtnH = (WIDTH-2)/LineCount;
    NSInteger line = menuTileArr.count%LineCount==0?(menuTileArr.count/LineCount):(menuTileArr.count/LineCount+1);
    _bottomViewH.constant = menuBtnH*line;
    NSInteger index = 0;
    for (NSInteger j = 0; j<line; j++) {
        for (NSInteger i = 0; i < LineCount; i++) {
            NSString *title  = @"";
            NSString *imgName = @"";
            if (index<menuTileArr.count) {
                title = menuTileArr[index];
                imgName = iconArr[index];
            }
            UIButton *sender = [self createMenuButton:title andIconName:imgName];
            sender.frame = CGRectMake(i*(menuBtnH+1), j*(menuBtnH+1), menuBtnH, menuBtnH);
            [_bottomVIew addSubview:sender];
            [sender addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
    }
}

- (void)showAction:(UIButton *)sender {
    if (![Utils isVerified]) {
        return;
    }
    NSString *vcName = @"";
    if ([sender.currentTitle isEqualToString:@"我的司机"]) {
        vcName = @"JSMyDriverVC";
    }
    else if ([sender.currentTitle isEqualToString:@"我的车辆"]) {
        vcName = @"JSMyCarVC";
    }
    else if ([sender.currentTitle isEqualToString:@"我的路线"]) {
        vcName = @"JSMyRouteVC";
    }
    else {
        [Utils showToast:@"该功能暂未开通，敬请期待"];
    }
    if (vcName.length>0) {
        UIViewController *vc = [Utils getViewController:@"Mine" WithVCName:vcName];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - get data

- (void)getData {
    
    if ([Utils isLoginWithJump:YES]) {
        [self getUserInfo]; //获取用户信息
        [self getAccountInfo]; //获取账户信息
    }
}

/* 获取用户信息 */
- (void)getUserInfo {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:URL_Profile parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            //缓存用户信息
            NSDictionary *userDic = responseData;
            [[UserInfo share] setUserInfo:[userDic mutableCopy]];
            
            //将用户信息解析成model
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
            
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"personalcenter_driver_icon_head_land"]];
            self.phoneLab.text = userInfo.mobile;
            self.nameLab.text = userInfo.nickName;
           
            //失败》已审核〉审核中》未提交
            if ([[UserInfo share].driverVerified integerValue] == 3
                || [[UserInfo share].parkVerified integerValue] == 3) {
                self.stateLab.text = @"认证失败";
                return;
            }
            if ([[UserInfo share].driverVerified integerValue] == 2
                || [[UserInfo share].parkVerified integerValue] == 2) {
                self.stateLab.text = @"已认证";
                return;
            }
            if ([[UserInfo share].driverVerified integerValue] == 1
                || [[UserInfo share].parkVerified integerValue] == 1) {
                self.stateLab.text = @"认证中";
                return;
            }
            if ([[UserInfo share].driverVerified integerValue] == 0
                && [[UserInfo share].parkVerified integerValue] == 0) {
                self.stateLab.text = @"未提交";
                return;
            }
        }
    }];
}

/* 获取账户信息 */
- (void)getAccountInfo {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:URL_GetBySubscriber parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            AccountInfo *accountInfo = [AccountInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
            if (accountInfo!=nil) {
                self.balanceLab.text = accountInfo.balance;
            }
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    JSAllOrderVC *orderVc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"ingOrder"]) {
        orderVc.typeFlage = 1;
    }
    else  if ([segue.identifier isEqualToString:@"payOrder"]) {
        orderVc.typeFlage = 2;
    }
    else  if ([segue.identifier isEqualToString:@"publishOrder"]) {
        orderVc.typeFlage = 3;
    }
    else  if ([segue.identifier isEqualToString:@"getGoodsOrder"]) {
        orderVc.typeFlage = 4;
    }
    else  if ([segue.identifier isEqualToString:@"allOrder"]) {
        orderVc.typeFlage = 0;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (UIButton *)createMenuButton:(NSString *)title andIconName:(NSString *)iconName {
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, menuBtnH, menuBtnH)];
    sender.backgroundColor = [UIColor whiteColor];
    if (iconName.length>0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((sender.width-20)/2.0, sender.height/2.0-20, 20, 20)];
        img.image = [UIImage imageNamed:iconName];
        [sender addSubview:img];
    }
    sender.titleLabel.font = JSFontMin(12);
    sender.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    [sender setTitle:title forState:UIControlStateNormal];
    sender.titleEdgeInsets = UIEdgeInsetsMake(0, 0, autoScaleW(15), 0);
    return sender;
}

/** 我的钱包 */
- (IBAction)myWalletAction:(id)sender {
    if (![Utils isVerified]) {
        return;
    }
    JSMyWalletVC *vc = (JSMyWalletVC *)[Utils getViewController:@"Mine" WithVCName:@"JSMyWalletVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 我的圈子 */
- (IBAction)quanziAction:(id)sender {
    [Utils showToast:@"功能暂未开通，敬请期待"];
}

/** 我的社区 */
- (IBAction)shequAction:(id)sender {
    [Utils showToast:@"功能暂未开通，敬请期待"];
}

/** 我的帖子 */
- (IBAction)tieziAction:(id)sender {
    [Utils showToast:@"功能暂未开通，敬请期待"];
}

/** 我的草稿箱 */
- (IBAction)caogaoxiangAction:(id)sender {
    [Utils showToast:@"功能暂未开通，敬请期待"];
}

@end
