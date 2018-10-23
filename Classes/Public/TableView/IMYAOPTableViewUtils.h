//
//  IMYAOPTableViewUtils.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPBaseUtils.h"
#import "IMYAOPTableViewInsertBody.h"
#import "IMYAOPTableViewUtilsDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  请通过TableView 的 aop_utils 方法，获取该实例, 禁止独立初始化
 *  原来所有的TableView方法将会被hook，如果需要调用原有方法请看 IMYAOPTableViewUtils+Proxy.h
 */
@interface IMYAOPTableViewUtils : IMYAOPBaseUtils

@property (nullable, nonatomic, readonly, weak) UITableView *tableView;

///AOP TableView 的回调
@property (nullable, nonatomic, weak) id<IMYAOPTableViewDelegate> delegate;
@property (nullable, nonatomic, weak) id<IMYAOPTableViewDataSource> dataSource;

@end

@interface IMYAOPTableViewUtils (IndexPathDeprecated)

- (nullable NSIndexPath *)realIndexPathByTable:(NSIndexPath *)tableIndexPath __deprecated_msg("Use `userIndexPathByFeeds:`");
- (nullable NSIndexPath *)tableIndexPathByReal:(NSIndexPath *)realIndexPath __deprecated_msg("Use `feedsIndexPathByUser:`");
- (NSInteger)realSectionByTable:(NSInteger)tableSection __deprecated_msg("Use `userSectionByFeeds:`");
- (NSInteger)tableSectionByReal:(NSInteger)realSection __deprecated_msg("Use `feedsSectionByUser:`");
- (NSArray<NSIndexPath *> *)realIndexPathsByTableIndexPaths:(NSArray<NSIndexPath *> *)tableIndexPaths __deprecated_msg("Use `userIndexPathsByFeedsIndexPaths:`");
- (NSArray<NSIndexPath *> *)tableIndexPathsByRealIndexPaths:(NSArray<NSIndexPath *> *)realIndexPaths __deprecated_msg("Use `feedsIndexPathsByUserIndexPaths:`");
- (NSIndexSet *)realSectionsByTableSet:(NSIndexSet *)tableSet __deprecated_msg("Use `userSectionsByFeedsSet:`");
- (NSIndexSet *)tableSectionsByRealSet:(NSIndexSet *)realSet __deprecated_msg("Use `feedsSectionsByUserSet:`");

@end

NS_ASSUME_NONNULL_END
