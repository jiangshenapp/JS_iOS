//
//  BaseVC.h
//  Chaozhi
//  Notes：VC基类
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavBar.h"

@interface BaseVC : UIViewController

//self.navBar.hidden = YES; //隐藏导航条,在子类viewWillAppear里面调用
@property (nonatomic,retain) BaseNavBar *navBar;
@property (nonatomic,retain) UINavigationItem *navItem;
@property (nonatomic,retain) UIButton *backBtn;
/** 返回优先级 0默认返回上一页  -1返回根视图  1返回上上页  。。。依次类推 */
@property (nonatomic,assign) NSInteger backPriority;

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,assign) CGRect tableFrame;
@property (weak, nonatomic) IBOutlet UITableView *baseTabView;
@property (retain, nonatomic)  UIView *noDataView;
/** 分页 */
@property (nonatomic,assign) NSInteger currentPage;

/** 添加上拉加载 */
-(void)addTabMJ_FootView ;
/** 是否隐藏无数据 */
-(void)hiddenNoDataView:(BOOL)hidden;

/*!
 *  @brief 无网络
 */
- (void)netWorkDisappear;

/*!
 *  @brief 有网络
 */
- (void)netWorkAppear;

/*!
 *  @brief 初始化页面
 */
- (void)initView;

/*!
 *  @brief 获取数据
 */
- (void)getData;

/*!
 *  @brief 返回
 */
- (void)backAction;

/*!
 *  @brief 动画下拉刷新
// */
//- (void)tableViewGifHeaderWithRefreshingBlock:(void(^)(void)) block;
//
///*!
// *  @brief 动画上拉加载
// */
//- (void)tableViewGifFooterWithRefreshingBlock:(void(^)(void)) block;
//
///*!
// *  @brief 默认下拉刷新
// */
//- (void)tableViewNormalHeaderWithRefreshingBlock:(void(^)(void)) block;
//
///*!
// *  @brief 默认上拉加载
// */
//- (void)tableViewNormalFooterWithRefreshingBlock:(void(^)(void)) block;

/**
 *  短信验证码按钮封装
 */
- (void)startTimeCount:(UIButton *)l_timeButton;

@end
