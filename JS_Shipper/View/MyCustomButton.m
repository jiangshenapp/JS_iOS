//
//  MyCustomButton.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/5/28.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "MyCustomButton.h"

@implementation MyCustomButton
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = RGBValue(0xB4B4B4).CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius =2;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:AppThemeColor forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setIsSelect:(BOOL)isSelect {
    if (_isSelect!=isSelect) {
        _isSelect=isSelect;
    }
    if (isSelect) {
        self.backgroundColor = AppThemeColor;
        self.borderColor = kWhiteColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
        self.borderColor = RGBValue(0xB4B4B4);;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
