//
//  ImageViewer.h
//  XWDC
//
//  Created by mac on 15/12/30.
//  Copyright © 2015年 hcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYLPreViewImageTool : UIView<UIScrollViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)data tag:(NSInteger)tagg andIsUrl:(BOOL)isUrl;
- (instancetype)initWithFrame:(CGRect)frame andDataImgView:(NSArray *)data tag:(NSInteger)tagg ;

//@property (nonatomic,retain)NSArray *imageUrlArr;
//@property (nonatomic,assign)NSInteger curentTag;
@end
