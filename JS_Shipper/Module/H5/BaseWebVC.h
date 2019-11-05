//
//  BaseWebVC.h
//  Chaozhi
//  Notes：WebView基类
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseVC.h"

@interface BaseWebVC : BaseVC

@property (nonatomic, assign) BOOL isShowWebTitle;
@property (strong, nonatomic) NSString *homeUrl;
@property (strong, nonatomic) NSString *webTitle;

/** 返回按钮回调 */
@property (nonatomic, copy) dispatch_block_t backBlock;

/** 传入控制器、url、标题*/
+ (void)showWithVC:(UIViewController *)vc withUrlStr:(NSString *)urlStr withTitle:(NSString *)title;

/**
 适用于传可扩展的参数
 
 @param title 标题【值为空用网页的title】
 @param url url
 @return 当前控制器
 */
- (instancetype)initWithTitle:(NSString *)title withUrl:(NSString *)url;

@end
