//
//  JSSearchCircleVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "JSCommunityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSearchCircleVC : BaseVC
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serachViewH;
@property (nonatomic,retain) NSMutableArray <JSCommunityModel *>*dataSource;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)searchActionClick:(UIButton *)sender;
/** 是否是搜索 */
@property (nonatomic,assign) BOOL isSearchResult;

@end

NS_ASSUME_NONNULL_END
