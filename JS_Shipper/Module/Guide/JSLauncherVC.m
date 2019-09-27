//
//  JSLauncherVC.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/9/17.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSLauncherVC.h"
#import "BannerModel.h"
#import "BaseWebVC.h"

@interface JSLauncherVC ()

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UIImageView *adImgView;
@property (nonatomic, strong) UIButton *jumpBtn;

/** 广告model */
@property (nonatomic, retain) BannerModel *bannerModel;

@end

@implementation JSLauncherVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    [self getLauncherAd]; //获取启动页广告
}

#pragma mark - get data
/** 获取启动页广告 */
- (void)getLauncherAd {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",URL_GetBannerList,@"3"];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NSMutableArray *bannerArr = [BannerModel mj_objectArrayWithKeyValuesArray:responseData];
            if (bannerArr.count>0) {
                self.bannerModel = bannerArr[0];
                [self.adImgView sd_setImageWithURL:[NSURL URLWithString:self.bannerModel.image]];
                [self.view addSubview:self.adImgView];
                [self.view addSubview:self.jumpBtn];
                [self performSelector:@selector(doneAction) withObject:@"adShow" afterDelay:3.0];
            } else {
                [self doneAction];
            }
        } else {
            [self doneAction];
        }
    }];
}

#pragma mark - init view
- (void)initView {
    _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    _logoImgView.centerX = self.view.centerX;
    _logoImgView.centerY = self.view.centerY-20;
    _logoImgView.image = [UIImage imageNamed:@"app_abutus_logo"];
    [self.view addSubview:_logoImgView];
}

- (UIImageView *)adImgView {
    if (!_adImgView) {
        _adImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClickAction)];
        [_adImgView addGestureRecognizer:tap];
    }
    return _adImgView;
}

// 跳过
- (UIButton *)jumpBtn {
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpBtn.frame = CGRectMake(WIDTH - 15 - 50,kStatusBarH+20, 50, 25);
        [_jumpBtn.layer setMasksToBounds:YES];
        _jumpBtn.layer.cornerRadius = 25/2.0;
        _jumpBtn.backgroundColor = [UIColor whiteColor];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
        _jumpBtn.layer.borderWidth = 1;
        _jumpBtn.layer.borderColor = AppThemeColor.CGColor;
        [_jumpBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpBtn;
}

#pragma mark - methods
- (void)doneAction {
    if (self.doneBlock) {
        self.doneBlock();
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doneAction) object:@"adShow"];
}

- (void)adClickAction {
    [Utils showToast:@"广告点击"];
    
    BaseWebVC *vc = [[BaseWebVC alloc] initWithTitle:self.bannerModel.title withUrl:self.bannerModel.url];
    vc.backAction = ^{
        if (self.doneBlock) {
            self.doneBlock();
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
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
