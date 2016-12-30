//
//  IMYAOPTableViewUtils.h
//  IMYAdvertisementDemo
//
//  Created by ljh on 16/4/15.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPTableViewInsertBody.h"
#import "IMYAOPTableViewUtilsDefine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  请通过TableView 的 aop_utils 方法，获取该实例, 禁止独立初始化
 *  原来所有的TableView方法将会被hook，如果需要调用原有方法请看 IMYAOPTableViewUtils+Proxy.h
 */
@interface IMYAOPTableViewUtils : NSObject <IMY_UNAVAILABLE_ATTRIBUTE_ALLOC>

@property (nullable, nonatomic, readonly, weak) UITableView *tableView;

///AOP TableView 的回调
@property (nullable, nonatomic, weak) id<IMYAOPTableViewDelegate> delegate;
@property (nullable, nonatomic, weak) id<IMYAOPTableViewDataSource> dataSource;

///插入sections 跟 indexPaths
- (void)insertWithSections:(nullable NSArray<IMYAOPTableViewInsertBody *> *)sections;
- (void)insertWithIndexPaths:(nullable NSArray<IMYAOPTableViewInsertBody *> *)indexPaths;

@end


///转换 IndexPath
@interface IMYAOPTableViewUtils (IndexPath)

///table的 indexPath 转 逻辑调用的indexPath
- (nullable NSIndexPath *)realIndexPathByTable:(nullable NSIndexPath *)tableIndexPath;
///逻辑indexPath 转 table 使用的indexPath
- (nullable NSIndexPath *)tableIndexPathByReal:(nullable NSIndexPath *)realIndexPath;

///table的section 转 逻辑调用的section
- (NSInteger)realSectionByTable:(NSInteger)tableSection;
///逻辑section 转 table 使用的section
- (NSInteger)tableSectionByReal:(NSInteger)realSection;

/// 数组转换, 效果跟上面一样
- (NSArray<NSIndexPath *> *)realIndexPathsByTableIndexPaths:(nullable NSArray<NSIndexPath *> *)tableIndexPaths;
- (NSArray<NSIndexPath *> *)tableIndexPathsByRealIndexPaths:(nullable NSArray<NSIndexPath *> *)realIndexPaths;

- (NSIndexSet *)realSectionsByTableSet:(nullable NSIndexSet *)tableSet;
- (NSIndexSet *)tableSectionsByRealSet:(nullable NSIndexSet *)realSet;

@end


@interface IMYAOPTableViewUtils (Deprecated_Nonfunctional)
/**
 *   已废弃, 由外部自己做合并
 */
@property BOOL combineReloadData __deprecated_msg("Deprecated");
@end

NS_ASSUME_NONNULL_END
