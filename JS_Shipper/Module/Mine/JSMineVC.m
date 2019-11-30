//
//  JSMineVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMineVC.h"
#import "JSAllOrderVC.h"
#import "JSMyWalletVC.h"
#import "AccountInfo.h"
#import "ServiceModel.h"
#import "CustomEaseUtils.h"
#import "AddressInfoModel.h"

#define LineCount 3

@interface JSMineVC ()
{
    CGFloat menuBtnH;
}

/** 图片数组 */
@property (nonatomic,retain) NSMutableArray *iconArr;
/** 标题数组 */
@property (nonatomic,retain) NSMutableArray *menuTileArr;
/** 服务数组 */
@property (nonatomic,retain) NSMutableArray *serviceArr;

@end

@implementation JSMineVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    
    self.iconArr = [NSMutableArray arrayWithObjects:@"personalcenter_icon_park",@"my_icon_authentication",@"personalcenter_icon_customer", nil];
    self.menuTileArr = [NSMutableArray arrayWithObjects:@"我的园区",@"认证管理",@"我的客服", nil];
    
    [self createUI];
//    [self getSysServiceList]; //获取系统服务列表
}

/** 获取系统服务列表 */
- (void)getSysServiceList {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetSysServiceList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        self.serviceArr = [ServiceModel mj_objectArrayWithKeyValuesArray:responseData];
        for (ServiceModel *model in self.serviceArr) {
            [self.iconArr addObject:model.icon];
            [self.menuTileArr addObject:model.title];
        }
        [self createUI];
    }];
}

- (void)createUI {
    menuBtnH = (WIDTH-2)/LineCount;
    NSInteger line = self.menuTileArr.count%LineCount==0?(self.menuTileArr.count/LineCount):(self.menuTileArr.count/LineCount+1);
    _bottomViewH.constant = menuBtnH*line;
    NSInteger index = 0;
    for (NSInteger j = 0; j<line; j++) {
        for (NSInteger i = 0; i < LineCount; i++) {
            NSString *title  = @"";
            NSString *imgName = @"";
            if (index<self.menuTileArr.count) {
                title = self.menuTileArr[index];
                imgName = self.iconArr[index];
            }
            UIButton *sender = [self createMenuButton:title andIconName:imgName];
            sender.tag = 1000+index;
            sender.frame = CGRectMake(i*(menuBtnH+1), j*(menuBtnH+1), menuBtnH, menuBtnH);
            [_bottomVIew addSubview:sender];
            [sender addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
    }
}

- (void)showAction:(UIButton *)sender {

    if ([sender.titleLabel.text isEqualToString:@"我的园区"]) {
        UIViewController *vc = [Utils getViewController:@"Garden" WithVCName:@"JSMyGardenVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([sender.currentTitle isEqualToString:@"认证管理"]) {
        UIViewController *vc = [Utils getViewController:@"Mine" WithVCName:@"JSAuthenticationVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([sender.currentTitle isEqualToString:@"我的客服"]) {
        [CustomEaseUtils EaseChatConversationID:OnlineCustomerEaseMobKey];
    }
    else { //系统服务配置
        NSInteger index = sender.tag-1000-2;
        ServiceModel *model = self.serviceArr[index];
        [BaseWebVC showWithVC:self withUrlStr:model.url withTitle:model.title];
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
            
            AddressInfoModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kSendAddressArchiver];
            if (!dataModel) {
                dataModel = [[AddressInfoModel alloc] init];
            }
            dataModel.phone = userInfo.mobile;
            dataModel.name = userInfo.nickName;
            [NSKeyedArchiver archiveRootObject:dataModel toFile:kSendAddressArchiver];
            
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"personalcenter_driver_icon_head_land"]];
            self.phoneLab.text = userInfo.mobile;
            self.nameLab.text = userInfo.nickName;
            
            //失败》已审核〉审核中》未提交
            if ([[UserInfo share].personConsignorVerified integerValue] == 3
                || [[UserInfo share].companyConsignorVerified integerValue] == 3) {
                self.stateLab.text = @"认证失败";
                return;
            }
            if ([[UserInfo share].personConsignorVerified integerValue] == 2
                || [[UserInfo share].companyConsignorVerified integerValue] == 2) {
                self.stateLab.text = @"已认证";
                return;
            }
            if ([[UserInfo share].personConsignorVerified integerValue] == 1
                || [[UserInfo share].companyConsignorVerified integerValue] == 1) {
                self.stateLab.text = @"认证中";
                return;
            }
            if ([[UserInfo share].personConsignorVerified integerValue] == 0
                && [[UserInfo share].companyConsignorVerified integerValue] == 0) {
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

#pragma mark - 创建底部视图
/** 创建底部视图 */
- (UIButton *)createMenuButton:(NSString *)title andIconName:(NSString *)iconName {
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, menuBtnH, menuBtnH)];
    sender.backgroundColor = [UIColor whiteColor];
    if (iconName.length>0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((sender.width-20)/2.0, sender.height/2.0-20, 20, 20)];
        if ([iconName containsString:@"http"]) {
            [img sd_setImageWithURL:[NSURL URLWithString:iconName]];
        } else {
            img.image = [UIImage imageNamed:iconName];
        }
        [sender addSubview:img];
    }
    sender.titleLabel.font = JSFontMin(12);
    sender.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    [sender setTitle:title forState:UIControlStateNormal];
    sender.titleEdgeInsets = UIEdgeInsetsMake(0, 0, autoScaleW(15), 0);
    return sender;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    JSAllOrderVC *orderVc = segue.destinationViewController;
    /** 0全部  1发布中 2待支付 3待配送 4待收货 */
    if ([segue.identifier isEqualToString:@"allOrder"]) { //全部
        orderVc.typeFlage = 0;
    }
    else if ([segue.identifier isEqualToString:@"ingOrder"]) { //发布中
        orderVc.typeFlage = 1;
    }
    else if ([segue.identifier isEqualToString:@"payOrder"]) { //待支付
        orderVc.typeFlage = 2;
    }
    else if ([segue.identifier isEqualToString:@"publishOrder"]) { //待配送
        orderVc.typeFlage = 3;
    }
    else if ([segue.identifier isEqualToString:@"getGoodsOrder"]) { //待收货
        orderVc.typeFlage = 4;
    }
}

/** 我的钱包 */
- (IBAction)myWalletAction:(id)sender {
    if (![Utils isVerified]) {
        return;
    }
    JSMyWalletVC *vc = (JSMyWalletVC *)[Utils getViewController:@"Mine" WithVCName:@"JSMyWalletVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
