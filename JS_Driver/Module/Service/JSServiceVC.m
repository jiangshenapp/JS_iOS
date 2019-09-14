//
//  JSServiceVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSServiceVC.h"
#import "ServiceModel.h"

@interface JSServiceVC ()

/** 服务数组 */
@property (nonatomic,retain) NSArray *serviceArr;

@end

@implementation JSServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务";
    _bannerView.imageURLStringsGroup = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1554786828281&di=adb087e354b74cf42fffb75077e2c757&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F14%2F37%2F09%2F97a58PICQ6H_1024.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1554786828281&di=adb087e354b74cf42fffb75077e2c757&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F14%2F37%2F09%2F97a58PICQ6H_1024.jpg"];
    _bannerView.currentPageDotColor = AppThemeColor;
    _bannerView.pageDotColor = kWhiteColor;
    
    [self getData];
}

#pragma mark - get data
- (void)getData {
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
        self.fourBgView.hidden = YES;
    }
    
    for (int i = 0; i<7; i++) {
        UIButton *itemBtn = [self.view viewWithTag:100+i];
        if (i>=count) {
            itemBtn.hidden = YES;
        } else {
            ServiceModel *model = self.serviceArr[i];
            [itemBtn setTitle:model.title forState:UIControlStateNormal];
            [itemBtn sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal];
//            [itemBtn setImage:[[UIImage imageNamed:@"driver_service_icon_nearby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            //调整图片和文字上下显示
            itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
            [itemBtn setTitleEdgeInsets:UIEdgeInsetsMake(itemBtn.imageView.frame.size.height ,-itemBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
            [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(-itemBtn.imageView.frame.size.height, 0.0,0.0, -itemBtn.titleLabel.bounds.size.width)];
            [itemBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - methods
- (void)jumpAction:(UIButton *)btn {
    NSInteger index = btn.tag-100;
    ServiceModel *model = self.serviceArr[index];
    [BaseWebVC showWithContro:self withUrlStr:model.url withTitle:model.title isPresent:NO];
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
