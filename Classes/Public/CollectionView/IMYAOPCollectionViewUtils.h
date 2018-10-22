//
//  IMYAOPCollectionViewUtils.h
//  IMYAOPFeedsView
//
//  Created by ljh on 2018/10/22.
//

#import "IMYAOPBaseUtils.h"
#import "IMYAOPCollectionViewUtilsDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMYAOPCollectionViewUtils : IMYAOPBaseUtils

@property (nullable, nonatomic, readonly, weak) UICollectionView *collectionView;

///AOP CollectionView 的回调
@property (nullable, nonatomic, weak) id<IMYAOPCollectionViewDelegate> delegate;
@property (nullable, nonatomic, weak) id<IMYAOPCollectionViewDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
