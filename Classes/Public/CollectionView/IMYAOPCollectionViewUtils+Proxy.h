//
//  IMYAOPCollectionViewUtils+Proxy.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPCollectionViewInsertBody.h"
#import "IMYAOPCollectionViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Inserted Cell API

///获取插入数据的代理方法
@interface IMYAOPCollectionViewUtils (InsertedProxy)

///获取插入集合内，显示中的cell
@property (nonatomic, readonly) NSArray<__kindof UICollectionViewCell *> *visibleInsertCells;

///获取显示中的cell
- (NSArray<__kindof UICollectionViewCell *> *)visibleCellsWithType:(IMYAOPType)type;

@end

#pragma mark - UITableView API

///对TableView执行原始数据的操作, 不进行AOP的处理
@interface IMYAOPCollectionViewUtils (TableViewProxy)

///不进行 IndexPath 处理，获取真实数据
- (nullable NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell;

///不进行 IndexPath 处理，获取真实数据
- (nullable UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

///more... 可直接使用这个 collectionView 进行方法调用,不经过AOP处理
- (nullable UICollectionView *)proxyRawCollectionView;

@end

#pragma mark - Model API

@protocol IMYAOPCollectionViewGetModelProtocol
/// 返回该 IndexPath 所对应的 数据Model
- (nullable id)collectionView:(UICollectionView *)collectionView modelForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface IMYAOPCollectionViewUtils (Models)

///需要 collectionView.dataSource 实现 collectionView:modelForRowAtIndexPath: 协议中的方法
- (NSArray<IMYAOPCollectionViewRawModel *> *)allModels;

///需要 collectionView.dataSource 实现 IMYAOPCollectionViewGetModelProtocol 协议中的方法
- (nullable id)modelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END
