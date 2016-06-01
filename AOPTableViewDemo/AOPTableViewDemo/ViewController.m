//
//  ViewController.m
//  AOPTableView
//
//  Created by ljh on 16/5/30.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "ViewController.h"
#import "IMYAOPTableView.h"

@interface IMYAOPDemo : NSObject <IMYAOPTableViewDelegate, IMYAOPTableViewDataSource>
@property (weak, nonatomic) IMYAOPTableViewUtils *aopUtils;
@end

@implementation IMYAOPDemo
- (void)setAopUtils:(IMYAOPTableViewUtils *)aopUtils
{
    _aopUtils = aopUtils;
    [self injectTableView];
}
- (void)injectTableView
{
    [self.aopUtils.tableView registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"AD"];
    self.aopUtils.delegate = self;
    self.aopUtils.dataSource = self;

}
- (void)insertRows
{
    NSMutableArray<IMYAOPTableViewInsertBody*>* insertBodys = [NSMutableArray array];
    for (int i = 0 ; i< 5; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arc4random()%10 inSection:0];
        [insertBodys addObject:[IMYAOPTableViewInsertBody insertBodyWithIndexPath:indexPath]];
    }
    ///清空 sections
    [self.aopUtils insertWithSections:nil];
    [self.aopUtils insertWithIndexPaths:insertBodys];
    [self.aopUtils.tableView reloadData];
}
- (void)insertSections
{
    NSMutableArray<IMYAOPTableViewInsertBody*>* insertBodys = [NSMutableArray array];
    for (int i = 1 ; i< 6; i++) {
        NSInteger section = arc4random() % i;
        IMYAOPTableViewInsertBody* body = [IMYAOPTableViewInsertBody insertBodyWithSection:section];
        [insertBodys addObject:body];
    }
    [self.aopUtils insertWithSections:insertBodys];
    
    ///单纯插入section 是没法显示的。  要跟 row 配合
    ///同一个 row 会按数组的顺序 row 进行 递增
    [insertBodys enumerateObjectsUsingBlock:^(IMYAOPTableViewInsertBody * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.indexPath = [NSIndexPath indexPathForRow:0 inSection:obj.resultSection];
    }];
    [self.aopUtils insertWithIndexPaths:insertBodys];
    
    [self.aopUtils.tableView reloadData];
}

#pragma mark-AOP Delegate
- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils numberOfSection:(NSInteger)sectionNumber
{
    ///可以获取真实的 sectionNumber 可以在这边进行一些AOP的数据初始化
}
-(void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///真实的 will display 回调. 有些时候统计需要
}

#pragma mark- UITableView 回调
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ADADAD cellForRowAtIndexPath %ld ,%ld ",indexPath.section,indexPath.row);
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AD"];
    cell.textLabel.text = [NSString stringWithFormat:@"ADADAD %ld , %ld",indexPath.section,indexPath.row];
    cell.contentView.backgroundColor = [UIColor grayColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ADADAD willDisplayCell %ld ,%ld ",indexPath.section,indexPath.row);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ADADAD didSelectRowAtIndexPath %ld ,%ld ",indexPath.section,indexPath.row);
}
@end









@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IMYAOPDemo *aopDemo;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.aopDemo = [IMYAOPDemo new];
    self.aopDemo.aopUtils = self.tableView.aop_utils;
}

- (IBAction)insertRows:(id)sender {
    [self.aopDemo insertRows];
}

- (IBAction)insertSections:(id)sender {
    [self.aopDemo insertSections];
}

#pragma mark- TableView Delegate/DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willDisplayCell %ld ,%ld ",indexPath.section,indexPath.row);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath %ld ,%ld ",indexPath.section,indexPath.row);
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld , %ld",indexPath.section,indexPath.row];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %ld ,%ld ",indexPath.section,indexPath.row);
}
@end
