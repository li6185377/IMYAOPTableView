//
//  UITableView+IMYAOPTableUtils.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/4/16.
//  Copyright © 2016年 IMY. All rights reserved.
//

#import "IMYAOPCollectionViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (IMYAOPOperation)

+ (SEL)aop_updateAnimationDidStopSEL;

+ (Class)imy_aopClass;

@end


@interface _IMYAOPCollectionView : UICollectionView

//+ (void)aop_setupConfigs;
- (void)aop_refreshDelegate;
- (void)aop_refreshDataSource;
///获取显示中的cell containType => 0：原生cell   1：插入的cell   2：全部cell
- (NSArray *)aop_containVisibleCells:(IMYAOPType)containType;
- (NSArray<UICollectionReusableView *> *)aop_containVisibleSupplementaryViews:(IMYAOPType)containType
                                                                       ofKind:(NSString *)elementKind;
@end

NS_ASSUME_NONNULL_END
