//
//  CityCustomView.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/20.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "CityCustomView.h"

#define LineCount 4

@interface CityCustomView()
{
    //    UIImageView *shadowView;
    UILabel *currentCityLab;
    UIButton *backBtn;
    
    NSArray *provinceArr;
    NSArray *cityArr;
    NSArray *districtArr;
    
    NSInteger provinceIndex;
    NSInteger cityIndex;
    NSInteger districtIndex;
    NSDictionary *lastCityDic;//记录全国全市区
    
    CGFloat btnW;
    CGFloat btnH;
    CGFloat viewH;
}
/** 白背景 */
@property (nonatomic,retain) UIButton *backGroundBtn;
/** scrollView */
@property (nonatomic,retain)  UIScrollView *bgScro;;
/** 0全国   1全省   2全市 */
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation CityCustomView

-(instancetype)initWithFrame:(CGRect)frame {
    CGRect frame1 = CGRectMake(0, kNavBarH+46, WIDTH, HEIGHT-kNavBarH-46);
    self = [super initWithFrame:frame1];
    if (self) {
        viewH = HEIGHT-kNavBarH-44;
        [self setupView];
        
    }
    return self;
}

-(void)setLocName:(NSString *)locName {
    currentCityLab.text = [@"选择:" stringByAppendingString:locName];
}

- (void)setupView {
    self.clipsToBounds = YES;
    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
    [myWindow addSubview:self];
    self.hidden = YES;
    
    _backGroundBtn = [[UIButton alloc] initWithFrame:self.bounds];
    _backGroundBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backGroundBtn];
    
    currentCityLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, WIDTH/2.0, 20)];
    currentCityLab.text = @"选择:全国";
    currentCityLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:currentCityLab];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 0, 88, 30)];
    [backBtn setTitle:@"返回上一级" forState:UIControlStateNormal];
    [backBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    backBtn.hidden = YES;
    [backBtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    _bgScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, backBtn.bottom, WIDTH, _backGroundBtn.height-backBtn.bottom)];
    [self addSubview:_bgScro];
    
    btnW = (WIDTH-12*5)/LineCount;
    btnH = btnW/2.2;;
    provinceArr = [Utils readLocalFileWithName:@"Address"][@"data"];
    provinceIndex = 2000;
    cityIndex = 3000;
    districtIndex = 4000;
    _currentPage = 0;
    backBtn.hidden = YES;
    [self createCityBtnView:provinceArr baseTag:2000];
}


- (void)backPage {
    if (_currentPage==1) {
        [self createCityBtnView:provinceArr baseTag:2000];
    }
    else if (_currentPage==2){
        [self createCityBtnView:cityArr baseTag:3000];
    }
}

- (void)createCityBtnView:(NSArray *)dataSource baseTag:(NSInteger)baseTag {
    NSDictionary *firstDic = [dataSource firstObject];
    NSString *firstName  = @"全国";
    _currentPage = 0;
    NSLog(@"第一个：%@\n",firstDic[@"sysArea"]);

    NSString *lastCode = firstDic[@"sysArea"][@"parentCode"];;
    NSString *address = @"全国";;
    if (lastCode.length==0) {
        lastCode = @"0";
        address = @"全国";
    }
    if (baseTag==3000) {
        firstName = @"全省";
        _currentPage = 1;
        NSDictionary *dic = provinceArr[provinceIndex-2000-1];
         address = [NSString stringWithFormat:@"%@",dic[@"sysArea"][@"address"]];
    }
    else if (baseTag==4000) {
        firstName = @"全市";
        _currentPage = 2;
        NSDictionary *dic = cityArr[cityIndex-3000-1];
       address = [NSString stringWithFormat:@"%@",dic[@"sysArea"][@"address"]];
    }
    [_bgScro.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger index = 0;
    NSInteger line = dataSource.count%LineCount==0?dataSource.count/LineCount:dataSource.count/LineCount+1;
    for (NSInteger i = 0; i<line; i++) {
        for (NSInteger j = 0; j<4; j++) {
            if (index>=dataSource.count+1) {
                break;
            }
            NSString *title;
            NSDictionary *dataDic;
            if (index==0) {
                title = firstName;
                dataDic = @{@"address":address,@"code":lastCode,@"parentCode":lastCode};
            }
            else {
                NSDictionary *privonceDic = dataSource[index-1];
                dataDic = privonceDic[@"sysArea"];
                title = dataDic[@"address"];
            }
            MyCustomButton *sender = [[MyCustomButton alloc]initWithFrame:CGRectMake(12+j*(btnW+12), 12+i*(btnH+12), btnW, btnH)];
            [sender setTitle:title forState:UIControlStateNormal];
            [sender addTarget:self action:@selector(cityButtonTouchAction:) forControlEvents:UIControlEventTouchUpInside];
            sender.tag = baseTag+index;
            sender.dataDic = dataDic;
            if (sender.tag==provinceIndex||sender.tag==cityIndex||sender.tag==districtIndex) {
                sender.isSelect = YES;
            }
            [_bgScro addSubview:sender];
            index++;
        }
    }
    _bgScro.contentSize = CGSizeMake(0, MAX(_bgScro.height+1, line*(btnH+12)));
    backBtn.hidden = !_currentPage;
}

- (void)cityButtonTouchAction:(MyCustomButton *)sender {
    currentCityLab.text = [NSString stringWithFormat:@"选择：%@",sender.currentTitle];
    if (sender.tag>=2000&&sender.tag<3000) {//省份
        backBtn.hidden = NO;
        if (sender.tag==2000) {
            backBtn.hidden = YES;
        }
        MyCustomButton *lastBtn = [self viewWithTag:provinceIndex];
        lastBtn.isSelect = NO;
        provinceIndex = sender.tag;
        cityIndex = 3000;
        districtIndex = 4000;
        if (sender.tag==2000) {//全国
            [self hiddenView];
            if (_getCityData) {
                self.getCityData(sender.dataDic);
            }
        }else {
            NSDictionary *dic = provinceArr[sender.tag-2000-1];
            cityArr = dic[@"children"];
            if ([cityArr isKindOfClass:[NSArray class]]&&cityArr.count>0) {
                [self createCityBtnView:cityArr baseTag:3000];
            }
            else {
                [self hiddenView];
                if (_getCityData) {
                    self.getCityData(sender.dataDic);
                }
            }
        }
    }
    else if (sender.tag>=3000&&sender.tag<4000) {//市
        MyCustomButton *lastBtn = [self viewWithTag:cityIndex];
        lastBtn.isSelect = NO;
        backBtn.hidden = NO;
        cityIndex = sender.tag;
        if (sender.tag==3000) {
            [self hiddenView];
            if (_getCityData) {
                self.getCityData(sender.dataDic);
            }
        }
        else {
            districtArr = cityArr[sender.tag-3000-1][@"children"];
            districtIndex = 4000;
            if ([districtArr isKindOfClass:[NSArray class]]&&districtArr.count>0) {
                [self createCityBtnView:districtArr baseTag:4000];
            }
            else {
                [self hiddenView];
                if (_getCityData) {
                    self.getCityData(sender.dataDic);
                }
            }
        }
    }
    else if (sender.tag>=4000) {
        MyCustomButton *lastBtn = [self viewWithTag:districtIndex];
        lastBtn.isSelect = NO;
        districtIndex = sender.tag;
        [self hiddenView];
        if (_getCityData) {
            self.getCityData(sender.dataDic);
        }
    }
    sender.isSelect = YES;
}



- (void)showView {
    __weak typeof(self) weakSelf = self;
    weakSelf.height = 0;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = self->viewH;
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


