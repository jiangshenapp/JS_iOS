//
//  YPTabBar.h
//  YPTabBarController
//
//  Created by 喻平 on 15/8/11.
//  Copyright (c) 2015年 YPTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPTabItem.h"

@class YPTabBar;

@protocol YPTabBarDelegate <NSObject>

@optional

- (BOOL)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSInteger)index;
- (void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSInteger)index;

@end

@interface YPTabBar : UIView <UIScrollViewDelegate>
{
     NSArray <YPTabItem *> *_items;
}


@property (nonatomic, strong) YPTabItem *specialItem;

// 当Item匹配title的文字宽度时，左右留出的空隙，item的宽度 = 文字宽度 + spacing
@property (nonatomic, assign) CGFloat itemFitTextWidthSpacing;

// Item是否匹配title的文字宽度
@property (nonatomic, assign) BOOL itemFitTextWidth;

// 当TabBar支持滚动时，使用此scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  TabItems，提供给YPTabBarController使用，一般不手动设置此属性
 */
@property (nonatomic, copy) NSArray <YPTabItem *> *items;

@property (nonatomic, strong) UIColor *itemSelectedBgColor;         // item选中背景颜色
@property (nonatomic, strong) UIImage *itemSelectedBgImage;         // item选中背景图像
@property (nonatomic, assign) CGFloat itemSelectedBgCornerRadius;   // item选中背景圆角

@property (nonatomic, strong) UIColor *itemTitleColor;              // 标题颜色
@property (nonatomic, strong) UIColor *itemTitleSelectedColor;      // 选中时标题的颜色
@property (nonatomic, strong) UIFont  *itemTitleFont;               // 标题字体
@property (nonatomic, strong) UIFont  *itemTitleSelectedFont;       // 选中时标题的字体

// item的宽度
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) CGFloat leftAndRightSpacing;          // TabBar边缘与第一个和最后一个item的距离

@property (nonatomic, assign) NSInteger selectedItemIndex;          // 选中某一个item

// 选中背景
@property (nonatomic, strong) UIImageView *itemSelectedBgImageView;


/**
 *  拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为YES
 */
@property (nonatomic, assign, getter = isItemColorChangeFollowContentScroll) BOOL itemColorChangeFollowContentScroll;

/**
 *  拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
 */
@property (nonatomic, assign, getter = isItemFontChangeFollowContentScroll) BOOL itemFontChangeFollowContentScroll;

/**
 *  TabItem的选中背景是否随contentView滑动而移动
 */
@property (nonatomic, assign, getter = isItemSelectedBgScrollFollowContent) BOOL itemSelectedBgScrollFollowContent;

/**
 *  将Image和Title设置为水平居中，默认为YES
 */
@property (nonatomic, assign, getter = isItemContentHorizontalCenter) BOOL itemContentHorizontalCenter;

@property (nonatomic, weak) id<YPTabBarDelegate> delegate;



@property (nonatomic, copy) void (^specialItemHandler)(YPTabItem *item);



// 选中背景相对于YPTabItem的insets
@property (nonatomic, assign) UIEdgeInsets itemSelectedBgInsets;

// TabItem选中切换时，是否显示动画
@property (nonatomic, assign) BOOL itemSelectedBgSwitchAnimated;







// item的内容水平居中时，image与顶部的距离
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterVerticalOffset;

// item的内容水平居中时，title与image的距离
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterSpacing;



// 分割线相关属性
@property (nonatomic, strong) NSMutableArray *separatorLayers;
@property (nonatomic, strong) UIColor *itemSeparatorColor;
@property (nonatomic, assign) CGFloat itemSeparatorWidth;
@property (nonatomic, assign) CGFloat itemSeparatorMarginTop;
@property (nonatomic, assign) CGFloat itemSeparatorMarginBottom;


/**
 *  返回已选中的item
 */
- (YPTabItem *)selectedItem;

/**
 *  根据titles创建item
 */
- (void)setTitles:(NSArray <NSString *> *)titles;

- (CGFloat)itemTitleUnselectedFontScale;

/**
 *  设置tabItem的选中背景，这个背景可以是一个横条
 *
 *  @param insets       选中背景的insets
 *  @param animated     点击item进行背景切换的时候，是否支持动画
 */
- (void)setItemSelectedBgInsets:(UIEdgeInsets)insets tapSwitchAnimated:(BOOL)animated;

/**
 *  设置tabBar可以左右滑动
 *  此方法与setScrollEnabledAndItemFitTextWidthWithSpacing这个方法是两种模式，哪个后调用哪个生效
 *
 *  @param width 每个tabItem的宽度
 */
- (void)setScrollEnabledAndItemWidth:(CGFloat)width;

/**
 *  设置tabBar可以左右滑动，并且item的宽度根据标题的宽度来匹配
 *  此方法与setScrollEnabledAndItemWidth这个方法是两种模式，哪个后调用哪个生效
 *
 *  @param spacing  item的宽度 = 文字宽度 + spacing 
 */
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing;

/**
 *  将tabItem的image和title设置为居中，并且调整其在竖直方向的位置
 *
 *  @param verticalOffset  竖直方向的偏移量
 *  @param spacing         image和title的距离
 */
- (void)setItemContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                                 spacing:(CGFloat)spacing;


/**
 *  设置分割线
 *
 *  @param itemSeparatorColor 分割线颜色
 *  @param width              宽度
 *  @param marginTop          与tabBar顶部距离
 *  @param marginBottom       与tabBar底部距离
 */
- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor
                        width:(CGFloat)width
                    marginTop:(CGFloat)marginTop
                 marginBottom:(CGFloat)marginBottom;

- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor
                    marginTop:(CGFloat)marginTop
                 marginBottom:(CGFloat)marginBottom;

/**
 *  添加一个特殊的YPTabItem到tabBar上，此TabItem不包含在tabBar的items数组里
 *  主要用于有的项目需要在tabBar的中间放置一个单独的按钮，类似于新浪微博等。
 *  此方法仅适用于不可滚动类型的tabBar
 *
 *  @param item    YPTabItem对象
 *  @param index   将其放在此index的item后面
 *  @param handler 点击事件回调
 */
- (void)setSpecialItem:(YPTabItem *)item
    afterItemWithIndex:(NSInteger)index
            tapHandler:(void (^)(YPTabItem *item))handler;

@end
