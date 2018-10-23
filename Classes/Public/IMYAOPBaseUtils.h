//
//  IMYAOPBaseUtils.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPBaseInsertBody.h"
#import "IMYAOPBaseUtilsDefine.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  请使用对应的 TableViewUtils 或者  CollectionView Utils
 */
@interface IMYAOPBaseUtils : NSObject <IMY_UNAVAILABLE_ATTRIBUTE_ALLOC>

///插入sections 跟 indexPaths
- (void)insertWithSections:(nullable NSArray<__kindof IMYAOPBaseInsertBody *> *)sections;
- (void)insertWithIndexPaths:(nullable NSArray<__kindof IMYAOPBaseInsertBody *> *)indexPaths;

@end

/**
 *  转换 IndexPath
 */
@interface IMYAOPBaseUtils (IndexPath)

/// feedsView的 indexPath 转 业务使用的 indexPath
- (nullable NSIndexPath *)userIndexPathByFeeds:(nullable NSIndexPath *)feedsIndexPath;
/// 业务使用的 indexPath 转 feedsView使用的 indexPath
- (nullable NSIndexPath *)feedsIndexPathByUser:(nullable NSIndexPath *)userIndexPath;

/// feedsView section 转 业务使用的 section
- (NSInteger)userSectionByFeeds:(NSInteger)feedsSection;
/// 业务使用的 section 转 feedsView section
- (NSInteger)feedsSectionByUser:(NSInteger)userSection;

/// 数组转换, 效果跟上面一样
- (NSArray<NSIndexPath *> *)userIndexPathsByFeedsIndexPaths:(nullable NSArray<NSIndexPath *> *)feedsIndexPaths;
- (NSArray<NSIndexPath *> *)feedsIndexPathsByUserIndexPaths:(nullable NSArray<NSIndexPath *> *)userIndexPaths;

- (NSIndexSet *)userSectionsByFeedsSet:(nullable NSIndexSet *)feedsSet;
- (NSIndexSet *)feedsSectionsByUserSet:(nullable NSIndexSet *)userSet;

@end

NS_ASSUME_NONNULL_END
