//
//  JSOrderDetailMapVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/29.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSOrderDetailMapVC.h"

#define AnimateDamping 0.8
#define AnimateSpringVelocity 0.1
#define ViewShowHeight 44*4
#define ScrollDisatnce 30

CGFloat const gestureMinimumTranslation = 100.0 ;

typedef enum : NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection;


@interface JSOrderDetailMapVC ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    CameraMoveDirection direction;
    CGFloat bottomViewY;
    CGFloat lastGestureY;

}
//@property (nonatomic,strong) UISwipeGestureRecognizer *swipeGesRecognizer;
/** 拖动手势 */
@property (nonatomic,strong) UIPanGestureRecognizer *panGesRecognizer;
@end

@implementation JSOrderDetailMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单详情";
    self.baseTabView.top = HEIGHT-ViewShowHeight;
    _panGesRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panViewAction:)];
    _panGesRecognizer.delegate = self;
    [self.baseTabView addGestureRecognizer:_panGesRecognizer];
    bottomViewY = HEIGHT- ViewShowHeight;
    lastGestureY = 0;
    self.baseTabView.height = HEIGHT-kNavBarH-kTabBarSafeH-8*2;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MapLogisticsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapLogisticsTabCell"];
    return cell;
}


- (void)panViewAction:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:self.view];
    CGPoint translation = [gesture translationInView: self .view];
    if (gesture.state == UIGestureRecognizerStateBegan ){
        direction = kCameraMoveDirectionNone;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone) {
        direction = [ self determineCameraDirectionIfNeeded:translation];
        gesture.view.center = CGPointMake(WIDTH/2.0, MAX(gesture.view.center.y + point.y, HEIGHT/2.0));
//        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ) {
        switch (direction) {
            case kCameraMoveDirectionDown:
                NSLog (@ "Start moving down" );
            {
                [self viewWithBottom];
                
            }
                break ;
                
            case kCameraMoveDirectionUp:
                NSLog (@ "Start moving up" );
            {
                [self viewWithTop];
                
            }
                break ;
            case kCameraMoveDirectionRight:
                NSLog (@ "Start moving right" );
                break ;
            case kCameraMoveDirectionLeft:
                NSLog (@ "Start moving left" );
                break ;
            default :
            {
                if ((-gesture.view.top+bottomViewY)>ScrollDisatnce) {
                    [self viewWithTop];
                }else{
                    [self viewWithBottom];
                }
            }
                break ;
        }
    }
}

- (void)viewWithBottom{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:AnimateDamping initialSpringVelocity:AnimateSpringVelocity options:UIViewAnimationOptionTransitionCurlUp animations:^{
        weakSelf.baseTabView.top = HEIGHT- ViewShowHeight;
//        [weakSelf.baseTabView setContentOffset:CGPointMake(0, 0) animated:YES];
    } completion:^(BOOL finished) {
    }];
}

- (void)viewWithTop{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:AnimateDamping initialSpringVelocity:AnimateSpringVelocity options:UIViewAnimationOptionTransitionCurlUp animations:^{
        weakSelf.baseTabView.top = kNavBarH+8;;
//        [self.baseTabView setContentOffset:CGPointMake(0, 0) ];
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    // UITableViewCellContentView就是点击了tableViewCell，则不截获点击事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
    }
    return  YES;
}

- ( CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation{
    if (direction != kCameraMoveDirectionNone)
        return direction;
    if (fabs(translation.x) > gestureMinimumTranslation)
    {
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        
        if (gestureHorizontal)
        {
            if (translation.x > 0.0 )
                return kCameraMoveDirectionRight;
            else
                return kCameraMoveDirectionLeft;
        }
    }else if (fabs(translation.y) > gestureMinimumTranslation){
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
            gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        
        if (gestureVertical)
        {
            if (translation.y > 0.0 )
                return kCameraMoveDirectionDown;
            else
                return kCameraMoveDirectionUp;
        }
    }
    return direction;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation MapLogisticsTabCell

@end
