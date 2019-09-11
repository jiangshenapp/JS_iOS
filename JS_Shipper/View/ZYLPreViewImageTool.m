//
//  ImageViewer.m
//  XWDC
//
//  Created by mac on 15/12/30.
//  Copyright © 2015年 hcb. All rights reserved.
//

#import "ZYLPreViewImageTool.h"

@implementation ZYLPreViewImageTool

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)data tag:(NSInteger)tagg andIsUrl:(BOOL)isUrl
{
    self = [super initWithFrame:frame];
    if (self) {

        UIScrollView *bgsc = [[UIScrollView alloc]initWithFrame:frame];
        bgsc.backgroundColor = [UIColor blackColor];
        [self addSubview:bgsc];
        bgsc.pagingEnabled = YES;
//        bgsc.delegate = self;
        bgsc.tag = 777;
        for (int i=0; i<data.count; i++) {
            
            
            UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            sc.tag = 1+i;
            sc.delegate = self;
            sc.maximumZoomScale=5.0;
            sc.minimumZoomScale=0.5;
            
            sc.showsHorizontalScrollIndicator=NO;
            sc.showsVerticalScrollIndicator=NO;
//            UIImageView *imageVV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            UIImageView *imageVV = [[UIImageView alloc]init];

            NSString *urlstr = @"";
            if (isUrl) {
                urlstr = data[i];

            }else{
                urlstr = [NSString stringWithFormat:@"%@%@",PIC_URL(),data[i]];
            }
            [imageVV sd_setImageWithURL: [NSURL URLWithString:urlstr] placeholderImage:nil];
            [sc addSubview:imageVV];

            [imageVV sd_setImageWithURL:[NSURL URLWithString:urlstr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!image) {
                    return ;
                }
                imageVV.frame = CGRectMake(0, 0, WIDTH,WIDTH/(image.size.width/image.size.height));
                imageVV.center = CGPointMake(sc.bounds.size.width *0.5,sc.bounds.size.height*0.5);
            }];
            [bgsc addSubview:sc];
            imageVV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf:)];
            [sc addGestureRecognizer:tap];
            imageVV.tag = 1+i;
            imageVV.clipsToBounds = YES;
            imageVV.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *atppp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleme:)];
            atppp.numberOfTapsRequired =2 ;

            [tap requireGestureRecognizerToFail:atppp];
            [sc  addGestureRecognizer:atppp];

        }
        
        if (tagg<data.count) {
            bgsc.contentOffset=CGPointMake(frame.size.width*tagg, 0);
        }
        
        bgsc.contentSize = CGSizeMake(frame.size.width*data.count, frame.size.height);
        bgsc.maximumZoomScale=2.5;
        bgsc.minimumZoomScale=0.5;


    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
//    scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(2.5, 2.5)];
//    scaleAnimation.springBounciness    = 15.f;
//    [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
//    
//    });

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andDataImgView:(NSArray *)data tag:(NSInteger)tagg {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIScrollView *bgsc = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:bgsc];
        bgsc.pagingEnabled = YES;
        //        bgsc.delegate = self;
        bgsc.tag = 777;
        for (int i=0; i<data.count; i++) {
            UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            sc.tag = 1+i;
            sc.delegate = self;
            sc.maximumZoomScale=5.0;
            sc.minimumZoomScale=0.5;
            
            sc.showsHorizontalScrollIndicator=NO;
            sc.showsVerticalScrollIndicator=NO;
            UIImageView *imageVV = data[i];
            imageVV.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [sc addSubview:imageVV];
            
            imageVV.center = CGPointMake(sc.bounds.size.width *0.5,sc.bounds.size.height*0.5);
            [bgsc addSubview:sc];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf:)];
            [sc addGestureRecognizer:tap];
            imageVV.tag = 1+i;
            imageVV.clipsToBounds = YES;
            imageVV.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *atppp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleme:)];
            atppp.numberOfTapsRequired =2 ;
            
            [tap requireGestureRecognizerToFail:atppp];
            [sc  addGestureRecognizer:atppp];
            
        }
        
        if (tagg<data.count) {
            bgsc.contentOffset=CGPointMake(frame.size.width*tagg, 0);
        }
        
        bgsc.contentSize = CGSizeMake(frame.size.width*data.count, frame.size.height);
        bgsc.maximumZoomScale=2.5;
        bgsc.minimumZoomScale=0.5;
    }
    return self;
}

-(void)scaleme:(UITapGestureRecognizer *)t{
    if ([t.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *sc= (UIScrollView *)t.view;
        [UIView animateWithDuration:0.25 animations:^{
            
        sc.zoomScale = sc.zoomScale == 2.5?1.0:2.5;
        }];
    }
    ////NSLog(@"双击收拾%@",t.view);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *vv = [scrollView subviews][0];
    return vv;
    return nil;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    UIImageView *imm = scrollView.subviews[0];
    CGRect contentsFrame = imm.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imm.frame = contentsFrame;
}

- (void)centerScrollViewContents {

}

-(void)hideSelf:(UITapGestureRecognizer *)tap{
    
    self.hidden = YES;

}





-(void)setHidden:(BOOL)hidden{
    
    if (hidden==YES) {

        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0.0;
            CGAffineTransform ttt = CGAffineTransformMakeScale(1, 1);
            self.transform = CGAffineTransformScale(ttt, 2, 2);
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
        
    }else{
        [super setHidden:hidden];
    }
    
    
}

@end
