//
//  IMYAOPCollectionViewUtilsDelegate.h
//  IMYAOPFeedsView
//
//  Created by ljh on 16/5/20.
//  Copyright © 2016年 ljh. All rights reserved.
//

#if __has_include(<CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>)
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#define _has_chtwaterfall_layout_ 1
#else
#define _has_chtwaterfall_layout_ 0
#endif

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IMYAOPCollectionViewInsertBody, IMYAOPCollectionViewUtils;

#if _has_chtwaterfall_layout_
@protocol IMYAOPCollectionViewDelegate <UICollectionViewDelegateFlowLayout, CHTCollectionViewDelegateWaterfallLayout>
#else
@protocol IMYAOPCollectionViewDelegate <UICollectionViewDelegateFlowLayout>
#endif

@optional
- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol IMYAOPCollectionViewDataSource <UICollectionViewDataSource>
@required
//可以获取真实的 sectionNumber 并在这边进行一些AOP的数据初始化
- (void)aopCollectionUtils:(IMYAOPCollectionViewUtils *)collectionUtils numberOfSections:(NSInteger)sectionNumber;

@end

NS_ASSUME_NONNULL_END
