//
//  BaseTabBarVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseTabBarVC.h"
#import "BaseNC.h"
#import "EMConversationsViewController.h"

@interface BaseTabBarVC ()
@property (nonatomic,assign) NSInteger  indexFlag;　　//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0
@end

@implementation BaseTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabBar];
    self.tabBar.barStyle = UIBarStyleBlack;
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.tabBar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity =0.2;
}

- (void)createTabBar {
    //视图数组
    NSArray *controllerArr ;
    //标题数组
    NSArray *titleArr;
    //图片数组
    NSArray *picArr ;

    //storyboard name 数组
    NSArray *storyArr ;
    
      if ([AppChannel isEqualToString:@"1"]) { //货主端
          controllerArr = @[@"JSGardenVC",@"JSDeliverGoodsVC",@"JSHomeMessageVC",@"JSCommunityVC",@"JSMineVC"];
          titleArr = @[@"园区",@"发货",@"消息",@"社区",@"我的"];
          picArr = @[@"app_menubar_icon_searchcar_black",@"app_menubar_icon_goods_black",@"app_menubar_icon_news_black",@"app_menubar_icon_community_black",@"app_menubar_icon_my_black"];
          storyArr = @[@"Garden",@"DeliverGoods",@"Message",@"Community",@"Mine"];
      }
      else if ([AppChannel isEqualToString:@"2"]) {
          controllerArr = @[@"JSFindGoodsVC",@"JSServiceVC",@"JSHomeMessageVC",@"JSCommunityVC",@"JSMineVC"];
          titleArr = @[@"找货",@"服务",@"消息",@"社区",@"我的"];
          picArr = @[@"app_menubar_icon_searchcar_black",@"app_menubar_icon_goods_black",@"app_menubar_icon_news_black",@"app_menubar_icon_community_black",@"app_menubar_icon_my_black"];
          storyArr = @[@"FindGoods",@"Service",@"Message",@"Community",@"Mine"];
      }
   
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0; i<picArr.count; i++) {
        NSString *stordyName = storyArr[i];
        UIViewController *controller;
        if (stordyName.length>0) {
            controller = [[UIStoryboard storyboardWithName:storyArr[i] bundle:nil] instantiateViewControllerWithIdentifier:controllerArr[i]];
        }
        else {
            controller = [[EMConversationsViewController alloc] init];;
        }
        controller.title = titleArr[i];
        
        BaseNC *nv = [[BaseNC alloc] initWithRootViewController:controller];
        nv.tabBarItem.title = titleArr[i];
        NSString *norName = picArr[i];
        nv.tabBarItem.image = [[UIImage imageNamed:norName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",[norName stringByReplacingOccurrencesOfString:@"black" withString:@"yellow"]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [array addObject:nv];
    }
    
    //设置字体的颜色和大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:AppThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateNormal];
    
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kTabBarH)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:barBgView atIndex:0];
    self.tabBar.opaque = YES;
    
    self.viewControllers = array;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
        //添加动画
//        //放大效果
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        //速度控制函数，控制动画运行的节奏
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.duration = 0.2;       //执行时间
//        animation.repeatCount = 1;      //执行次数
//        animation.removedOnCompletion = NO;
//        animation.fillMode = kCAFillModeForwards;           //保证动画效果延续
//        animation.fromValue = [NSNumber numberWithFloat:1.0];   //初始伸缩倍数
//        animation.toValue = [NSNumber numberWithFloat:1.15];     //结束伸缩倍数
//        [[arry[index] layer] addAnimation:animation forKey:nil];
//        //移除其他tabbar的动画
//        for (int i = 0; i<arry.count; i++) {
//            if (i != index) {
//                [[arry[i] layer] removeAllAnimations];
//            }
//        }
        
        //放大效果，并回到原位
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 0.2;       //执行时间
        animation.repeatCount = 1;      //执行次数
        animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
        animation.fromValue = [NSNumber numberWithFloat:0.8];   //初始伸缩倍数
        animation.toValue = [NSNumber numberWithFloat:1.2];     //结束伸缩倍数
        [[arry[index] layer] addAnimation:animation forKey:nil];
        
        self.indexFlag = index;
    }
}

@end
