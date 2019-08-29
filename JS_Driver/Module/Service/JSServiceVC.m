//
//  JSServiceVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSServiceVC.h"

@interface JSServiceVC ()

@end

@implementation JSServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务";
    _bannerView.imageURLStringsGroup = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1554786828281&di=adb087e354b74cf42fffb75077e2c757&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F14%2F37%2F09%2F97a58PICQ6H_1024.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1554786828281&di=adb087e354b74cf42fffb75077e2c757&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F14%2F37%2F09%2F97a58PICQ6H_1024.jpg"];
    _bannerView.currentPageDotColor = AppThemeColor;
    _bannerView.pageDotColor = kWhiteColor;
    // Do any additional setup after loading the view.
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
