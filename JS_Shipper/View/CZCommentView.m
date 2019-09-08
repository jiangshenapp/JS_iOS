//
//  CZCommentView.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/8/19.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZCommentView.h"
#import "YYStarView.h"

#define MyAuto(width) (float)width / 375 * (MIN(WIDTH, HEIGHT))
#define ViewH (float)MyAuto(270)
#define BtnH (float)MyAuto(44)
#define BottomSpace (float)MyAuto(49)

@interface CZCommentView()
{
    UILabel *_titleLab;
    UIButton *_closeBtn;
    UIButton *submitBtn;
}
/** 几颗星 */
@property (nonatomic,assign) NSInteger star;
/** 白色背景 */
@property (nonatomic,retain) UIView *bgWhiteView;
/** 阴影背景 */
@property (nonatomic,retain) UIView *shadowView;

@end

@implementation CZCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    if (self) {
        [self refreshUI];
    }
    return self;
}

- (void)refreshUI {
    
    _shadowView = [[UIView alloc] initWithFrame:self.frame];
    _shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    [self addSubview:_shadowView];
    
    _bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, ViewH)];
    _bgWhiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgWhiteView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, MyAuto(50))];
    _titleLab.text = @"评价";
    _titleLab.font = [UIFont systemFontOfSize:17];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_titleLab sizeToFit];
    _titleLab.centerX = _bgWhiteView.width/2.0;
    _titleLab.height = MyAuto(50);
    _titleLab.top = 0;
    [_bgWhiteView addSubview:_titleLab];

    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MyAuto(40), MyAuto(50))];
    [_closeBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setImage:[UIImage imageNamed:@"evaluate_icon_close"] forState:UIControlStateNormal];
    _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_bgWhiteView addSubview:_closeBtn];

    YYStarView *starView = [[YYStarView alloc] initWithFrame:CGRectMake((self.width-MyAuto(280))/2, MyAuto(90), MyAuto(280), MyAuto(40))];
    self.star = 5; //默认显示五颗星
    starView.starScore = self.star;
    [_bgWhiteView addSubview:starView];
    __weak typeof(starView) weakStarView = starView;
    starView.starClick = ^{
        self.star = weakStarView.starScore;
    };

    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(MyAuto(28), ViewH-BtnH-BottomSpace, self.width-MyAuto(56), BtnH)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    submitBtn.cornerRadius = BtnH/2.0;
    submitBtn.backgroundColor = AppThemeColor;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgWhiteView addSubview:submitBtn];
}

#pragma mark - 提交数据
/** 提交数据 */
- (void)submitAction {
    if (_submitBlock) {
        _submitBlock([NSString stringWithFormat:@"%ld",_star]);
    }
}

/** 显示视图 */
- (void)showView {
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgWhiteView.top = self.height-ViewH;
        self.alpha = 1;
    }];
}

/** 隐藏视图 */
- (void)hiddenView {
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgWhiteView.top = self.height;
        self.alpha = 0;
    }];
}

@end
