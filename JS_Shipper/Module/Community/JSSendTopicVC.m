//
//  JSPublishTopicVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSendTopicVC.h"
#import "NSString+NOEmoji.h"
#import "TZImagePickerController.h"
#import "RequestURLUtil.h"
#import "MyCustomButton.h"

#define PageCount 3

@interface JSSendTopicVC ()<TZImagePickerControllerDelegate>
{
    NSString *subjectName;
    MyCustomButton *lastBtn;
}
/** 图片 */
@property (nonatomic,copy)     NSString *imageID;;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;
- (IBAction)addImageAction:(UIButton *)sender;
- (IBAction)sendTopicAction:(UIButton *)sender;

@end

@implementation JSSendTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发帖";
    subjectName = @"1";
    if (_circleId.length==0) {
        _circleId = @"1";
    }
    _imageID = @"";
    _contentTV.borderColor = PageColor;
    _contentTV.borderWidth = 1;
    _addImageBtn.borderWidth = 1;
    _addImageBtn.borderColor = PageColor;
    [self initTopicListView];
    // Do any additional setup after loading the view.
}

- (void)initTopicListView {
    CGFloat leftSpace = 12;
    CGFloat viewW = (WIDTH-(PageCount+1)*leftSpace)/PageCount;
    CGFloat viewH = autoScaleW(44);
    NSArray *subjectImgName = @[@"social_circle_icon_blue",@"social_circle_icon_red",@"social_circle_icon_green",@"social_circle_icon_yellow"];
    NSInteger line = _subjectArr.count%PageCount==0?(_subjectArr.count/PageCount):((_subjectArr.count/PageCount)+1);
    NSInteger index = 0;
    for (NSInteger tempLine = 0; tempLine<line; tempLine++) {
        CGFloat maxRight = leftSpace;
        for (NSInteger i = 0; i<PageCount ; i++) {
            if (index>=_subjectArr.count) {
                break;
            }
            MyCustomButton *btn = [[MyCustomButton alloc]initWithFrame:CGRectMake(maxRight, leftSpace+tempLine*(viewH+leftSpace), viewW, viewH)];
            btn.cornerRadius = 2;
            [btn setTitle:_subjectArr[index] forState:UIControlStateNormal];
            NSInteger tempIndex = index%subjectImgName.count;
            [btn setImage:[UIImage imageNamed:subjectImgName[tempIndex]] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            btn.index = index;
            [btn addTarget:self action:@selector(selectSubject:) forControlEvents:UIControlEventTouchUpInside];
            [_topicScrollView addSubview:btn];
            btn.borderColor = [UIColor clearColor];
            maxRight = btn.right+leftSpace;
            index++;
        }
    }
    _topicScrollView.contentSize = CGSizeMake((viewH+leftSpace)*line+leftSpace, 0);
}

- (void)selectSubject:(MyCustomButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    sender.borderColor = AppThemeColor;
    if (lastBtn!=nil) {
        lastBtn.borderColor = [UIColor clearColor];
        lastBtn.selected = NO;
    }
    lastBtn = sender;
    subjectName = sender.currentTitle;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addImageAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];;
    vc.naviTitleColor = kBlackColor;
    vc.barItemTextColor = AppThemeColor;
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            UIImage *firstimg = [photos firstObject];
            [sender setImage:firstimg forState:UIControlStateNormal];
            [RequestURLUtil postImageWithData:firstimg result:^(NSString * _Nonnull imageID) {
                weakSelf.imageID = imageID;
            }];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)sendTopicAction:(UIButton *)sender {
    NSString *content = _contentTV.text;
    content = [content noEmoji];
    if (content.length==0) {
        if (_contentTV.text.length>0) {
            [Utils showToast:@"请输入合法字符串"];
            return;
        }
        [Utils showToast:@"请填写内容"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?circleId=%@&content=%@&subject=%@&image=%@",URL_PostAdd,_circleId,_contentTV.text,subjectName,_imageID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"发布成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}
@end
