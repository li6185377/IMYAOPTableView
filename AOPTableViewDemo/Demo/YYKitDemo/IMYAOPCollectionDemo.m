//
//  IMYAOPCollectionDemo.m
//  YYKitDemo
//
//  Created by ljh on 2018/10/22.
//  Copyright © 2018 ibireme. All rights reserved.
//

#import "IMYAOPCollectionDemo.h"

@interface IMYAOPCollectionDemo () <IMYAOPCollectionViewDelegate, IMYAOPCollectionViewDataSource, IMYAOPCollectionViewGetModelProtocol>

@end

@implementation IMYAOPCollectionDemo

- (void)setAopUtils:(IMYAOPCollectionViewUtils *)aopUtils {
    _aopUtils = aopUtils;
    [self injectTableView];
}

- (void)injectTableView {
    [self.aopUtils.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AD"];

    ///广告回调，跟TableView的Delegate，DataSource 一样。
    self.aopUtils.delegate = self;
    self.aopUtils.dataSource = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self insertRows];
    });
}
///简单的rows插入
- (void)insertRows {
    NSMutableArray<IMYAOPCollectionViewInsertBody *> *insertBodys = [NSMutableArray array];
    ///随机生成了5个要插入的位置
    for (int i = 0; i < 5; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arc4random() % 10 inSection:0];
        [insertBodys addObject:[IMYAOPCollectionViewInsertBody insertBodyWithIndexPath:indexPath]];
    }
    ///清空 旧数据
    [self.aopUtils insertWithSections:nil];
    [self.aopUtils insertWithIndexPaths:nil];

    ///插入 新数据, 同一个 row 会按数组的顺序 row 进行 递增
    [self.aopUtils insertWithIndexPaths:insertBodys];

    ///调用tableView的reloadData，进行页面刷新
    [self.aopUtils.collectionView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", self.aopUtils.allModels);
    });
}

/**
 *      插入sections demo
 *      单纯插入section 是没法显示的，要跟 row 配合。
 */
- (void)insertSections {
    NSMutableArray<IMYAOPCollectionViewInsertBody *> *insertBodys = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        NSInteger section = arc4random() % i;
        IMYAOPCollectionViewInsertBody *body = [IMYAOPCollectionViewInsertBody insertBodyWithSection:section];
        [insertBodys addObject:body];
    }
    [self.aopUtils insertWithSections:insertBodys];

    [insertBodys enumerateObjectsUsingBlock:^(IMYAOPCollectionViewInsertBody *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.indexPath = [NSIndexPath indexPathForRow:0 inSection:obj.resultSection];
    }];
    [self.aopUtils insertWithIndexPaths:insertBodys];

    [self.aopUtils.collectionView reloadData];
}

#pragma mark -AOP Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 防止警告用的，并不会调用
    return 1;
}

- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils numberOfSections:(NSInteger)sectionNumber {
    ///可以获取真实的 sectionNumber 可以在这边进行一些AOP的数据初始化
}

- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ///真实的 will display 回调. 有些时候统计需要
}

- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ///真实的 did end display 回调. 有些时候统计需要
}

- (id)collectionView:(UICollectionView *)collectionView modelForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"ad: %ld, %ld", indexPath.section, indexPath.row];
}

#pragma mark - UITableView 回调
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AD" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    UILabel *titleLabel = [cell.contentView viewWithTag:100];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
        titleLabel.tag = 100;
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
    }
    titleLabel.text = [NSString stringWithFormat:@"ad cell %ld", indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 100);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"插入的 ad cell 要显示啦 %ld", indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"被点击了> <" message:[NSString stringWithFormat:@"我的位置: %@", indexPath] delegate:nil cancelButtonTitle:@"哦~滚" otherButtonTitles:nil];
    [alertView show];
}

@end
