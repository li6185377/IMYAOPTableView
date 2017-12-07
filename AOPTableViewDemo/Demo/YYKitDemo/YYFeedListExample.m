//
//  YYFeedListExample.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYFeedListExample.h"
#import "IMYAOPDemo.h"
#import "YYKit.h"

@interface YYFeedListExample ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@property (nonatomic, strong) NSMutableArray *images;
///只是声明，防止提前释放
@property (nonatomic, strong) IMYAOPDemo *aopDemo;
@end

@implementation YYFeedListExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    self.images = @[].mutableCopy;

    [self addCell:@"Twitter" class:@"T1HomeTimelineItemsViewController" image:@"Twitter.jpg"];
    [self addCell:@"Weibo" class:@"WBStatusTimelineViewController" image:@"Weibo.jpg"];

    if (!kiOS7Later) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title class:(NSString *)className image:(NSString *)imageName {
    [self.titles addObject:title];
    [self.classNames addObject:className];
    [self.images addObject:[YYImage imageNamed:imageName]];
}

    - (void)viewDidAppear : (BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Feed List Demo";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    NSLog(@"test");
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.imageView.image = _images[indexPath.row];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 48 / 2;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;

        ///begin 插入3行代码
        self.aopDemo = [IMYAOPDemo new];
        UITableView *feedsTableView = [ctrl valueForKey:@"tableView"];
        [feedsTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@selector(viewDidLoad)];
        self.aopDemo.aopUtils = feedsTableView.aop_utils;
        ///end

        ctrl.title = _titles[indexPath.row];
        self.title = @" ";
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
