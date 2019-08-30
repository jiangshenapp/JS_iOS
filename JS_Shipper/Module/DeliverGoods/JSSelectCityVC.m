//
//  JSSelectCityVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/26.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSelectCityVC.h"

@interface JSSelectCityVC ()<UITableViewDelegate,UITableViewDataSource>
/** <#object#> */
@property (nonatomic,retain) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *groupTempArray;   /*用来存放分组的首字母 A --- Z*/
@property (nonatomic, strong) NSMutableDictionary *cityDic;     /*用来存放分组之后的数据*/
@end

@implementation JSSelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市选择";
    _cityDic = [NSMutableDictionary dictionary];
    _groupTempArray = [NSMutableArray array];
    [self getCityList];
    // Do any additional setup after loading the view.
}


#pragma mark - 获取数据
- (void)getCityList {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetCityList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.datas = responseData;
            [weakSelf processData];
        }
        
    }];
}


- (void)processData {
    NSMutableArray *arr = nil;
    for (NSDictionary *model in self.datas) {
        NSString *firstT = [self firstCharactor:model[@"address"]];
        ;
        if ([[_cityDic allKeys] containsObject:firstT]) {
            arr = [_cityDic objectForKey:firstT];
            [arr addObject:model];
            [_cityDic setObject:arr forKey:firstT];
        }
        else {
            arr = [[NSMutableArray alloc] initWithObjects:model, nil];
            [_cityDic setObject:arr forKey:firstT];
        }
    }
    
    self.groupTempArray= [NSMutableArray arrayWithArray:[[_cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [self.baseTabView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    for (UIView *view in [tableView subviews]) {
//        //改变索引的颜色值
//        if ([[[view class] description] isEqualToString:@"UITableViewIndex"]) {
//            UILabel *desLab = (UILabel *)view;
//            desLab.height = 40;
//            [desLab setFont:XLGFont(14)];
//        }
//    }
    return self.groupTempArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = [self.cityDic objectForKey:self.groupTempArray[section]];
    return array.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textColor = RGBValue(0x5A5A5A);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    NSArray *array = [self.cityDic objectForKey:self.groupTempArray[indexPath.section]];
    cell.textLabel.text = array[indexPath.row][@"address"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.groupTempArray[section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = RGBValue(0xB4B4B4);
    header.textLabel.font = [UIFont systemFontOfSize:13];
    header.backgroundColor = RGBValue(0xFAFAFA);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.groupTempArray];
//    [arr insertObject:@"区县" atIndex:0];
//    [arr insertObject:@"选择" atIndex:1];
    return arr;
}

#pragma mark - <MJNIndexViewDataSource>

//- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
//{
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.groupTempArray];
//    [arr insertObject:@"区县" atIndex:0];
//    [arr insertObject:@"选择" atIndex:1];
//    return arr;
//}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index-2] atScrollPosition: UITableViewScrollPositionTop animated:YES];
//    return index-2;
//}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    if (index>=2) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index-2] atScrollPosition: UITableViewScrollPositionTop animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = [self.cityDic objectForKey:self.groupTempArray[indexPath.section]];
    if (_getSelectDic) {
        self.getSelectDic(array[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 汉子转拼音首字母
- (NSString *)firstCharactor:(NSString *)aString {
    if ([NSString isEmpty:aString]) {
        return @"";
    }
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    /*多音字处理*/
    if ([[(NSString *)aString substringToIndex:1] compare:@"长"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([[(NSString *)aString substringToIndex:1] compare:@"沈"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[(NSString *)aString substringToIndex:1] compare:@"厦"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([[(NSString *)aString substringToIndex:1] compare:@"地"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 3) withString:@"di"];
    }
    if ([[(NSString *)aString substringToIndex:1] compare:@"重"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
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
