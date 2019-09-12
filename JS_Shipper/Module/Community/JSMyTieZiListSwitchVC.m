//
//  JSMyTieZiListSwitchVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/11.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSMyTieZiListSwitchVC.h"
#import "JSTieziListVC.h"

@interface JSMyTieZiListSwitchVC ()

@end

@implementation JSMyTieZiListSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子列表";
    NSArray *paramsTypeArr = @[@"0", @"1",@"2"];
    NSArray *couponCateArr = @[@"发布", @"点赞", @"评论"];
    
    NSMutableArray *controllerArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i < [couponCateArr count]; i++) {
        
        JSTieziListVC *controller = (JSTieziListVC *)[Utils getViewController:@"Community" WithVCName:@"JSTieziListVC"];
        controller.type = paramsTypeArr[i];
        controller.yp_tabItemTitle = couponCateArr[i];
        [controllerArray addObject:controller];
    }
    
    self.tabBar.itemTitleColor = kBlackColor;
    self.tabBar.itemTitleSelectedColor = AppThemeColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
//    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(41, 0, 0, 10) tapSwitchAnimated:NO];
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    [self setTabBarFrame:CGRectMake(0, kNavBarH, WIDTH, 44)
        contentViewFrame:CGRectMake(0, kNavBarH + 44, WIDTH, HEIGHT - (kNavBarH + 44))];
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.viewControllers = [NSMutableArray arrayWithArray:controllerArray];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.tabBar.selectedItemIndex = weakSelf.type;
    });
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
