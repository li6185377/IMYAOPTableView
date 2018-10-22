//
//  IMYAOPFeedsViewUtils.h
//  IMYAOPFeedsView
//
//  Created by ljh on 2018/10/19.
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

NS_ASSUME_NONNULL_END
