//
//  IMYAOPCollectionViewUtils+Private.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "IMYAOPBaseUtils+Private.h"
#import "IMYAOPCollectionViewUtils.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IAOPCollectionViewUtilsPrivate <IAOPBaseUtilsPrivate>

@property (nullable, nonatomic, weak) id<UICollectionViewDelegate> origDelegate;
@property (nullable, nonatomic, weak) id<UICollectionViewDataSource> origDataSource;

@property (nullable, nonatomic, weak) UICollectionView *collectionView;

@end

@interface IMYAOPCollectionViewUtils (Private) <IAOPCollectionViewUtilsPrivate>

@end

NS_ASSUME_NONNULL_END
