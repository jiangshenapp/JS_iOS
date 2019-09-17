//
//  JSServiceVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSServiceVC.h"
#import "BannerModel.h"
#import "ServiceModel.h"

@interface JSServiceVC ()<SDCycleScrollViewDelegate>

/** 服务数组 */
@property (nonatomic,retain) NSMutableArray *serviceArr;
/** banner数组 */
@property (nonatomic,retain) NSMutableArray *bannerArr;

@end

@implementation JSServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务";
    
    [self getData];
    
    self.bannerView.backgroundColor = [UIColor clearColor];
    self.bannerView.delegate = self;
    self.bannerView.currentPageDotColor = AppThemeColor;
    self.bannerView.pageDotColor = kWhiteColor;
}

#pragma mark - get data
- (void)getData {
    [self getSysServiceBanner]; //获取系统服务banner
    [self getSysServiceList]; //获取系统服务列表
}

/** 获取系统服务banner */
- (void)getSysServiceBanner {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil];
    [[NetworkManager sharedManager] postJSON:URL_GetBannerList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        self.bannerArr = [BannerModel mj_objectArrayWithKeyValuesArray:responseData];
        NSMutableArray *imageArr = [NSMutableArray array];
        for (BannerModel *model in self.bannerArr) {
            [imageArr addObject:model.bannerImage];
        }
        self.bannerView.imageURLStringsGroup = imageArr;
    }];
}

/** 获取系统服务列表 */
- (void)getSysServiceList {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetSysServiceList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        self.serviceArr = [ServiceModel mj_objectArrayWithKeyValuesArray:responseData];
        [self initView];
    }];
}

#pragma mark - init view
- (void)initView {
    int count = (int)self.serviceArr.count;
    if (count == 0) {
        [self.view viewWithTag:1000].hidden = YES;
    }
    for (int i = 0; i<7; i++) {
        UIView *itemView = [self.view viewWithTag:100+i];
        UIButton *itemBtn = [self.view viewWithTag:200+i];
        UIImageView *itemImgView = [self.view viewWithTag:300+i];
        if (i>=count) {
            itemView.hidden = YES;
        } else {
            ServiceModel *model = self.serviceArr[i];
            [itemBtn setTitle:model.title forState:UIControlStateNormal];
            [itemBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
            [itemImgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
        }
    }
}

#pragma mark - methods
- (void)jumpAction:(UIButton *)btn {
    NSInteger index = btn.tag-200;
    ServiceModel *model = self.serviceArr[index];
    [BaseWebVC showWithVC:self withUrlStr:model.url withTitle:model.title];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *model = self.bannerArr[index];
    [BaseWebVC showWithVC:self withUrlStr:model.url withTitle:model.title];
}

//- (void)initView {
//    int count = (int)self.serviceArr.count;
//
//    if (count == 0) {
//        self.fourBgView.hidden = YES;
//    }
//
//    for (int i = 0; i<7; i++) {
//        UIButton *itemBtn = [self.view viewWithTag:100+i];
//        if (i>=count) {
//            itemBtn.hidden = YES;
//        } else {
//            ServiceModel *model = self.serviceArr[i];
//            [itemBtn setTitle:model.title forState:UIControlStateNormal];
//            [itemBtn setImage:[[UIImage imageNamed:@"driver_service_icon_nearby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//            //调整图片和文字上下显示
//            itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//            [itemBtn setTitleEdgeInsets:UIEdgeInsetsMake(itemBtn.imageView.frame.size.height ,-itemBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//            [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(-itemBtn.imageView.frame.size.height, 0.0,0.0, -itemBtn.titleLabel.bounds.size.width)];
//            [itemBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
