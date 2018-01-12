//
//  IMYAOPDemo.m
//  YYKitDemo
//
//  Created by ljh on 16/6/19.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "IMYAOPDemo.h"

@interface IMYAOPDemo () <IMYAOPTableViewDelegate, IMYAOPTableViewDataSource, IMYAOPTableViewGetModelProtocol>

@end
@implementation IMYAOPDemo
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ///只是为了不警告  该回调是不会被调用的
    return 0;
}
- (void)setAopUtils:(IMYAOPTableViewUtils *)aopUtils {
    _aopUtils = aopUtils;
    [self injectTableView];
}
- (void)injectTableView {
    [self.aopUtils.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AD"];

    ///广告回调，跟TableView的Delegate，DataSource 一样。
    self.aopUtils.delegate = self;
    self.aopUtils.dataSource = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self insertRows];
    });
}
///简单的rows插入
- (void)insertRows {
    NSMutableArray<IMYAOPTableViewInsertBody *> *insertBodys = [NSMutableArray array];
    ///随机生成了5个要插入的位置
    for (int i = 0; i < 5; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arc4random() % 10 inSection:0];
        [insertBodys addObject:[IMYAOPTableViewInsertBody insertBodyWithIndexPath:indexPath]];
    }
    ///清空 旧数据
    [self.aopUtils insertWithSections:nil];
    [self.aopUtils insertWithIndexPaths:nil];

    ///插入 新数据, 同一个 row 会按数组的顺序 row 进行 递增
    [self.aopUtils insertWithIndexPaths:insertBodys];

    ///调用tableView的reloadData，进行页面刷新
    [self.aopUtils.tableView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", self.aopUtils.allModels);
    });
}

/**
 *      插入sections demo
 *      单纯插入section 是没法显示的，要跟 row 配合。
 */
- (void)insertSections {
    NSMutableArray<IMYAOPTableViewInsertBody *> *insertBodys = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        NSInteger section = arc4random() % i;
        IMYAOPTableViewInsertBody *body = [IMYAOPTableViewInsertBody insertBodyWithSection:section];
        [insertBodys addObject:body];
    }
    [self.aopUtils insertWithSections:insertBodys];

    [insertBodys enumerateObjectsUsingBlock:^(IMYAOPTableViewInsertBody *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.indexPath = [NSIndexPath indexPathForRow:0 inSection:obj.resultSection];
    }];
    [self.aopUtils insertWithIndexPaths:insertBodys];

    [self.aopUtils.tableView reloadData];
}

#pragma mark -AOP Delegate
- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils numberOfSection:(NSInteger)sectionNumber {
    ///可以获取真实的 sectionNumber 可以在这边进行一些AOP的数据初始化
}

- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ///真实的 will display 回调. 有些时候统计需要
}

- (void)aopTableUtils:(IMYAOPTableViewUtils *)tableUtils didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ///真实的 did end display 回调. 有些时候统计需要
}

- (id)tableView:(UITableView *)tableView modelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"ad: %d, %d", indexPath.section, indexPath.row];
}

#pragma mark - UITableView 回调
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AD"];
    if (cell.contentView.subviews.count == 0) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageHeight = 162 * (screenWidth / 320.0f);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, imageHeight)];
        imageView.image = [UIImage imageNamed:@"aop_ad_image.jpeg"];
        imageView.layer.borderColor = [UIColor blackColor].CGColor;
        imageView.layer.borderWidth = 1;
        [cell.contentView addSubview:imageView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 200, 50)];
        label.text = @"不要脸的广告!";
        [cell.contentView addSubview:label];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageHeight = 162 * (screenWidth / 320.0f);
    return imageHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"插入的cell要显示啦");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"被点击了> <" message:[NSString stringWithFormat:@"我的位置: %@", indexPath] delegate:nil cancelButtonTitle:@"哦~滚" otherButtonTitles:nil];
    [alertView show];
}
@end
