//
//  FilterCustomView.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/24.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "FilterCustomView.h"

#define HeaderHeight 30
#define LineCount 4
#define WorkSpace  10
#define ButtonWidth (WIDTH -WorkSpace*(LineCount+1))/LineCount

@interface FilterCustomView ()
{
    BOOL isClearAll;
    UIScrollView *bgScrollView;
    NSMutableArray *allCellViewArr;
    NSDictionary *_allDicKey;
}
/** 所选择的数组 */
@property (nonatomic,retain) NSMutableArray *selectArr;
/** <#object#> */
@property (nonatomic,retain) NSMutableDictionary *postDic;
/** <#object#> */
@property (nonatomic,retain) NSMutableArray *titlesArr;
;
@end

@implementation FilterCustomView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _allDicKey = @{@"useCarType":@"用车类型",@"carLength":@"车长",@"carModel":@"车型",@"goodsType":@"货物名称"};
    _selectArr = [NSMutableArray array];
    self.frame = CGRectMake(0, kNavBarH+46, WIDTH, HEIGHT-kNavBarH-46-kTabBarSafeH);
    self.backgroundColor = PageColor;
    self.clipsToBounds = YES;
    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
    [myWindow addSubview:self];
    self.hidden = YES;
    self.viewHeight = self.height;
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width-12, self.height-autoScaleW(50))];
    [self addSubview:bgScrollView];
    
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height-autoScaleW(50), autoScaleW(150), autoScaleW(50))];
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [sender setTitle:@"清空" forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(clearAllSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(sender.right, sender.top, WIDTH-sender.width, sender.height)];
    sureBtn.backgroundColor = AppThemeColor;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(confirmSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sender.top, WIDTH, 1)];
    lineView.backgroundColor = PageColor;
    [self addSubview:lineView];
    
    [bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-autoScaleW(50));
    }];
    
    [sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH*0.4, autoScaleW(50)));
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
    }];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH*0.6, autoScaleW(50)));
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.left.mas_equalTo(sender.mas_right).offset(0);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH, 1));
        make.bottom.mas_equalTo(sender.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
}

-(void)confirmSelect {
    if (self.getPostDic) {
        self.getPostDic(_postDic, _titlesArr);
    }
    [self hiddenView];
}

- (void)refreshUI {
    [bgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _postDic = [NSMutableDictionary dictionary];;
    __weak typeof(self) weakSelf = self;
    allCellViewArr = [NSMutableArray array];
    CGFloat maxViewBottom = 0;
    NSInteger index = 0;
    for (NSString *keys in _dataDic.allKeys) {
        
        if ([keys isEqualToString:@"goodsType"] || [keys isEqualToString:@"useCarType"]) { //去掉货物名称、用车类型筛选
            continue;
        }
        NSArray *arr = _dataDic[keys];
        BOOL isSingle = NO;
        NSString *titleStr = _allDicKey[keys];
        if ([titleStr containsString:@"用车"]) {
            isSingle = YES;
        }
        else {
            titleStr = [titleStr stringByAppendingString:@"：(可多选)"];
        }
        MyCustomView *view = [[MyCustomView alloc]initWithdataSource:arr andTilte:titleStr];
        view.top = maxViewBottom;
        //        BOOL isSingle = [_singleArr[index] boolValue];
        view.isSingle = isSingle;
        maxViewBottom = view.height+maxViewBottom;
        view.getSlectInfoStr = ^(NSString * _Nonnull titles, NSString * _Nonnull values) {
            if (values.length>0) {
                values = [values substringToIndex:values.length-1];
            }
            if (titles.length>0) {
                titles = [titles substringToIndex:titles.length-1];
            }
            [weakSelf.postDic setObject:values forKey:keys];
            [weakSelf.titlesArr replaceObjectAtIndex:index withObject:titles];
        };
        [bgScrollView addSubview:view];
        [allCellViewArr addObject:view];
        index ++;
    }
    bgScrollView.contentSize = CGSizeMake(0, MAX(bgScrollView.height+1, maxViewBottom));
}


- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic!=dataDic) {
        _dataDic=dataDic;
    }
    _titlesArr = [NSMutableArray array];
    for (NSInteger index = 0; index<dataDic.allKeys.count; index++) {
        [_titlesArr addObject:@"不限"];
    }
    [self refreshUI];
}

- (void)clearAllSelect{
    isClearAll = YES;
    for (NSInteger index = 0; index<_dataDic.allKeys.count; index++) {
        [_titlesArr addObject:@"不限"];
    }
    _postDic = [NSMutableDictionary dictionary];;
    for (MyCustomView *view in allCellViewArr) {
        view.isClear = YES;
    }
    isClearAll = NO;
}

- (void)showView {
    __weak typeof(self) weakSelf = self;
    weakSelf.height = 0;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = weakSelf.viewHeight;
    } completion:^(BOOL finished) {
    }];
}


- (void)hiddenView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = 0;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation MyCustomView

- (instancetype)initWithdataSource:(NSArray *)dataSource andTilte:(NSString *)titleStr {
    self = [super init];
    if (self) {
        _titles = @"";
        _values = @"";
        self.backgroundColor = [UIColor whiteColor];
        allButtonArr = [NSMutableArray array];
        NSInteger count = dataSource.count+1;
        NSInteger line = count%LineCount==0?(count/LineCount):((count/LineCount)+1);
        CGFloat cellH = HeaderHeight+ WorkSpace+(line*(ButtonWidth*0.5+WorkSpace))+20;
        self.frame = CGRectMake(0, 0, WIDTH, cellH);
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, WIDTH/2.0, HeaderHeight)];
        titleLab.text = titleStr;
        titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLab];
        
        NSInteger index = 0;
        for (NSInteger i = 0; i<line; i++) {
            for (NSInteger j =0; j < LineCount; j ++) {
                if (index>=count) {
                    break;
                }
                MyCustomButton *_button = [[MyCustomButton alloc]initWithFrame:CGRectMake(WorkSpace+(j*(ButtonWidth+WorkSpace)), HeaderHeight+WorkSpace+(i*(ButtonWidth*0.5+WorkSpace)), ButtonWidth, ButtonWidth*0.5)];
                _button.isSelect = NO;
                if (index==0) {
                    [_button setTitle:@"不限" forState:UIControlStateNormal];
                    _button.dataDic = @{@"value":@"",@"label":@"不限"};
                    if (_titles.length==0) {
                        _button.isSelect = YES;
                    }
                    if (lastSelectBtn==nil) {
                        lastSelectBtn = _button;
                    }
                }
                else {
                    [_button setTitle:dataSource[index-1][@"label"] forState:UIControlStateNormal];
                    _button.dataDic = dataSource[index-1];
                }
                if ([_titles containsString:[NSString stringWithFormat:@"%@,",_button.currentTitle]]) {
                    _button.isSelect = YES;
                }
                _button.index = index;
                [_button addTarget:self action:@selector(buttonTouchAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_button];
                [allButtonArr addObject:_button];
                index++;
            }
            if (index>count) {
                break;
            }
        }
        UITextField *contentTF = [[UITextField alloc]initWithFrame:CGRectMake(12, 10, WIDTH/2.0, 36)];
        contentTF.placeholder = @"请输入其他车长";
        contentTF.layer.borderColor = RGBValue(0xB4B4B4).CGColor;
        contentTF.layer.borderWidth = 0.5;
        contentTF.layer.cornerRadius =2;
        contentTF.layer.masksToBounds = YES;
        contentTF.hidden = YES;
        contentTF.font = [UIFont systemFontOfSize:14];
        [self addSubview:contentTF];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 1)];
        contentTF.leftView = lineView;
        contentTF.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-10, WIDTH, 10)];
        bgView.backgroundColor = PageColor;
        [self addSubview:bgView];
    }
    return self;
}

- (void)buttonTouchAction:(MyCustomButton *)sender {
    if (_isSingle) {//是单选
        lastSelectBtn.isSelect = NO;
        lastSelectBtn = sender;
        _titles = @"";
        _values = @"";
    }
    else {
        if (sender.index==0) {
            _titles = @"";
            _values = @"";
            for (MyCustomButton *btn in allButtonArr) {
                if (btn.index!=0) {
                    btn.isSelect = NO;
                }
            }
        }
        else {
            MyCustomButton *btn = [allButtonArr firstObject];
            btn.isSelect = NO;
        }
    }
    sender.isSelect = !sender.isSelect;
    if (sender.isSelect) {
            _titles = [_titles stringByAppendingString:[NSString stringWithFormat:@"%@,",sender.dataDic[@"label"]]];
            _values = [_values stringByAppendingString:[NSString stringWithFormat:@"%@,",sender.dataDic[@"value"]]];
    }
    else {
        _titles = [_titles stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",sender.dataDic[@"label"]] withString:@""];
        _values = [_values stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",sender.dataDic[@"value"]] withString:@""];
    }
    if (_getSlectInfoStr) {
        self.getSlectInfoStr(_titles, _values);
    }
}

- (void)setIsClear:(BOOL)isClear {
    if (_isClear!=isClear) {
        _isClear = isClear;
    }
    _titles = @"";
    _values = @"";
    NSInteger index = 0;
    for (MyCustomButton *btn in allButtonArr) {
        if (index==0) {
            btn.isSelect = YES;
            lastSelectBtn = btn;
        }
        else {
            btn.isSelect = NO;
        }
        index++;
    }
    if (_getSlectInfoStr) {
        self.getSlectInfoStr(@"", @"");
    }
}

@end

