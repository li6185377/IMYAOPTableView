//
//  IMYAOPTableViewUtils+Proxy.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPTableViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Inserted Cell API

///获取插入数据的代理方法
@interface IMYAOPTableViewUtils (InsertedProxy)

///获取插入集合内，显示中的cell
@property (nonatomic, readonly) NSArray<__kindof UITableViewCell *> *visibleInsertCells;

///获取显示中的cell
- (NSArray<__kindof UITableViewCell *> *)visibleCellsWithType:(IMYAOPType)type;

@end

#pragma mark - UITableView API

///对TableView执行原始数据的操作, 不进行AOP的处理
@interface IMYAOPTableViewUtils (TableViewProxy)

///不进行 IndexPath 处理，获取真实数据
- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath;

///不进行 IndexPath 处理，获取真实数据
- (nullable NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;

///不进行 IndexPath 处理，获取真实数据
- (nullable __kindof UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

///more... 可直接使用这个tableView进行方法调用,不经过AOP处理
- (nullable UITableView *)proxyRawTableView;

@end

#pragma mark - Model API

@protocol IMYAOPTableViewGetModelProtocol
/// 返回该 IndexPath 所对应的 数据Model
- (nullable id)tableView:(UITableView *)tableView modelForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface IMYAOPTableViewUtils (Models)

///需要 tableView.dataSource 实现 tableView:modelForRowAtIndexPath: 协议中的方法
- (NSArray<IMYAOPTableViewRawModel *> *)allModels;

///需要 tableView.dataSource 实现 IMYAOPTableViewGetModelProtocol 协议中的方法
- (nullable id)modelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
